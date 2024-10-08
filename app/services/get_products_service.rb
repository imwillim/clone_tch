# frozen_string_literal: true

class GetProductsService < BaseService
  def initialize(category_id)
    super()
    @category_id = category_id
  end

  def call
    validate
    return self if error?

    fetch_products
    self
  end

  private

  attr_reader :category_id

  def build_category_cte
    conn = ActiveRecord::Base.connection
    if Category.where(id: @category_id, parent_id: nil).present?
      query_statement = <<-SQL
      WITH category_cte AS (
        SELECT categories.id as id, categories.name as name
        FROM categories
        LEFT OUTER JOIN categories AS parents  ON categories.parent_id = parents.id
      )

     SELECT categories.id AS category_id
             , categories.name as category_name
             , products.id as product_id
             , products.name as product_name
             , products.price as product_price
             , products.thumbnail as product_thumbnail
             , tags.name as tag_name
             , tags.color as tag_color
        FROM category_cte AS categories
        JOIN products ON categories.id = products.category_id
        LEFT OUTER JOIN tags ON tags.product_id = products.id;
      SQL
      conn.exec_query(query_statement)
    else
      query_statement = <<-SQL
    WITH category_cte AS (
        SELECT categories.id as id, categories.name as name
        FROM categories
        LEFT OUTER JOIN categories AS parents ON categories.parent_id = parents.id
        WHERE categories.parent_id = :category_id
        OR categories.id = :category_id
      )
    
    SELECT categories.id AS category_id
             , categories.name as category_name
             , products.id as product_id
             , products.name as product_name
             , products.price as product_price
             , products.thumbnail as product_thumbnail
             , tags.name as tag_name
             , tags.color as tag_color
        FROM category_cte AS categories
        JOIN products ON categories.id = products.category_id
        LEFT OUTER JOIN tags ON tags.product_id = products.id;
      SQL

      conn.exec_query(
        ApplicationRecord.sanitize_sql([query_statement, { category_id: @category_id }])
      )
    end
  end

  def build_query
    build_category_cte
  end

  def fetch_products
    products = build_query
    @result = products.group_by { |product| product[:category_name] }.map do |category_name, elements|
      {
        name: category_name,
        products: elements.map! do |element|
          transform_product(element)
        end
      }
    end
  end

  def transform_product(product)
    {
      id: product[:product_id],
      name: product[:product_name],
      price: product[:product_price],
      thumbnail: product[:product_thumbnail],
      tag: {
        name: product[:tag_name],
        color: product[:tag_color]
      }
    }
  end

  def validate
    add_error(I18n.t('errors.models.not_found', record: :category)) if Category.where(id: @category_id).blank?
  end
end

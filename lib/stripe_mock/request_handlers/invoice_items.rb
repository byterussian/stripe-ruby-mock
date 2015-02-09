module StripeMock
  module RequestHandlers
    module InvoiceItems

      def InvoiceItems.included(klass)
        klass.add_handler 'post /v1/invoiceitems',        :new_invoice_item
        klass.add_handler 'post /v1/invoiceitems/(.*)',   :update_invoice_item
        klass.add_handler 'get /v1/invoiceitems/(.*)',    :get_invoice_item
        klass.add_handler 'get /v1/invoiceitems',         :list_invoice_items
        klass.add_handler 'delete /v1/invoiceitems/(.*)', :delete_invoice_item
        klass.add_handler 'get /v1/invoiceitems/(.*)',  :get_invoice_item
        klass.add_handler 'get /v1/invoiceitems',       :list_invoice_items
      end

      def new_invoice_item(route, method_url, params, headers)
        params[:id] ||= new_id('ii')
        invoice_items[ params[:id] ] = Data.mock_invoice_item(params)
        invoice_items[ params[:id] ]
      end

      def update_invoice_item(route, method_url, params, headers)
        route =~ method_url
        list_item = assert_existence :list_item, $1, invoice_items[$1]
        list_item.merge!(params)
      end

      def delete_invoice_item(route, method_url, params, headers)
        route =~ method_url
        assert_existence :list_item, $1, invoice_items[$1]

        invoice_items[$1] = {
          id: invoice_items[$1][:id],
          deleted: true
        }
      end

      def list_invoice_items(route, method_url, params, headers)
        invoice_items.values
      end

      def get_invoice_item(route, method_url, params, headers)
        route =~ method_url
        assert_existence :invoice_item, $1, invoice_items[$1]
        invoice_items[$1] ||= Data.mock_invoice_item([], :id => $1)
      end

      def list_invoice_items(route, method_url, params, headers)
        invoice_items.values
      end
    end
  end
end

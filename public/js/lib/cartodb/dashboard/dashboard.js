/**
 *  entry point for dashboard
 */


$(function() {

    var Dashboard = cdb.core.View.extend({

        el: document.body,

        events: {
          'click a[href=#create_new]':  'show_dialog',
          'click':                      'onClickOut'
        },


        initialize: function() {
          this._initModels();
          this._initViews();

          this.tables.fetch();
        },

        _initModels: function() {
          this.tables = new cdb.admin.Tables();
        },

        _initViews: function() {
          this.tableList = new cdb.admin.dashboard.TableList({
            el: this.$('.content > ul'),
            model: this.tables
          });

          // D3 API Requests
          var stats = this.stats = new cdb.admin.D3Stats({
            el: this.$("div.stats")
          });

          // User settings
          var settings = this.settings = new cdb.admin.Dropdown({
            target: 'a.account',
            model: {username: username},
            template_base: "dashboard/views/settings_item"
          })
          .on("optionClicked",function(ev){})

          cdb.god.bind("closeDialogs", settings.hide, settings);

          this.$el.append(this.settings.render().el);
        },

        show_dialog: function() {
          var dialog = new cdb.admin.CreateTableDialog();
          this.$el.append(dialog.render().el);
          dialog.open();

        },

        onClickOut: function(ev) {
          cdb.god.trigger("closeDialogs");
        }
    });

    var DashboardRouter = Backbone.Router.extend({

        routes: {
            '/': 'index'
        },

        index: function() {
        }

    });

    cdb.init(function() {
      var dashboard = new Dashboard();
      var router = new DashboardRouter();
      // expose to debug
      window.dashboard = dashboard;
    });




});
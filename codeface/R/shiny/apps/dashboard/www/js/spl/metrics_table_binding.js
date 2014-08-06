(function(){
  var Shiny = window.Shiny;
  var releaseMetricsOutput = new Shiny.OutputBinding();

  var renderTemplateTo = function(template, target, data, append) {
    append = typeof append !== 'undefined' ? append : false;

    var rendered = Mustache.render(template, data);

    if (append) {
      target.append(rendered);
    } else {
      target.html(rendered);
    }
  }

  var getTemplateExecute = function(name, callback) {
    $.get('/apps/dashboard/templates/' + name + '.mst', function(data) {
      callback.call(this, data);
    });
  }

  var getTrendClass = function(trend) {
    var className = 'down';

    if (trend > 0) {
      className = 'up';
    } else if (trend == 0) {
      className = 'stable';
    }

    return className;
  }

  var importance = {
    'general': function(val) {
      var abs = Math.abs(val);
      var className = 'low';

      if (abs > 20) {
        className = 'high'
      } else if (abs > 2) {
        className = 'med'
      }

      return className;
    }
  }

  var releaseUrl = function(projectId, releaseId) {
    return './?topic=spl-release&projectid=' + projectId + '&release=' + releaseId;
  }

  $('html').on('click', 'table.spl.releases tr', function(ev){
    var el = $(ev.target).parents('tr');
    var rid = el.data('spl-rid');
    var pid = el.data('spl-pid');
    if (pid && rid) {
      var url = releaseUrl(pid, rid);
      document.location.href = url;
    }
  });

  $.extend(releaseMetricsOutput, {
    find: function(scope){
      return $(scope).find('.spl.releases.output');
    },
    renderValue: function(el, data) {
      $el = $(el).find('table');
      getTemplateExecute('row', function(tpl) {
        $.each(data.revision, function(i, v) {
          var tplVars = {
            'revision': data.revision[i],
            'pid' : data.pid[i],
            'rid': data.rid[i],
            'loc': {
              'var': data.LOC[i],
              'diff': data['loc.diff'][i],
              'change': data['loc.change'][i],
              'dir': getTrendClass(data['loc.diff'][i]),
              'importance': importance.general(data['loc.change'][i])
            },
            'lof': {
              'var': data.LOF[i],
              'diff': data['lof.diff'][i],
              'change': data['lof.change'][i],
              'dir': getTrendClass(data['lof.diff'][i]),
              'importance': importance.general(data['lof.change'][i])
            },
            'nofc': {
              'var': data.NOFC[i],
              'diff': data['nofc.diff'][i],
              'change': data['nofc.change'][i],
              'dir': getTrendClass(data['nofc.diff'][i]),
              'importance': importance.general(data['nofc.change'][i])
            },
            'and': {
              'var': data.ANDAVG[i],
              'diff': data['and.diff'][i],
              'change': data['and.change'][i],
              'dir': getTrendClass(data['and.diff'][i]),
              'importance': importance.general(data['and.change'][i])
            },
            'nofpfc': {
              'var': data.NOFPFCMEAN[i],
              'diff': data['nofpfc.diff'][i],
              'change': data['nofpfc.change'][i],
              'dir': getTrendClass(data['nofpfc.diff'][i]),
              'importance': importance.general(data['nofpfc.change'][i])
            },
            'sdeg': {
              'var': data.SDEGMEAN[i],
              'diff': data['sdeg.diff'][i],
              'change': data['sdeg.change'][i],
              'dir': getTrendClass(data['sdeg.diff'][i]),
              'importance': importance.general(data['sdeg.change'][i])
            },
            'tdeg': {
              'var': data.TDEGMEAN[i],
              'diff': data['tdeg.diff'][i],
              'change': data['tdeg.change'][i],
              'dir': getTrendClass(data['tdeg.diff'][i]),
              'importance': importance.general(data['tdeg.change'][i])
            }
          };
          renderTemplateTo(tpl, $el, tplVars, true);
        });
      });
    }
  });

  Shiny.outputBindings.register(releaseMetricsOutput, "widget.spl.release.metrics");
})();

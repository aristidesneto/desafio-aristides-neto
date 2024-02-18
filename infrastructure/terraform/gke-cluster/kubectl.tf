provider "kubectl" {
  host                   = "https://${google_container_cluster.desafio_globo.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.desafio_globo.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}

resource "kubectl_manifest" "dashboard-loki" {
  depends_on = [ helm_release.kube_stack_prometheus ]
  yaml_body = <<YAML
kind: ConfigMap
apiVersion: v1
metadata:
  name: dashboard-loki
  namespace: prometheus
  labels:
    grafana_dashboard: "1"
data:
  dashboard-loki.json: |
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "grafana",
              "uid": "-- Grafana --"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "type": "dashboard"
          }
        ]
      },
      "description": "Dashboard para visualização da aplicação de comentários provisionada com terraform",
      "editable": true,
      "fiscalYearStartMonth": 0,
      "graphTooltip": 0,
      "id": 38,
      "links": [],
      "liveNow": false,
      "panels": [
        {
          "datasource": {
            "type": "loki",
            "uid": "P8E80F9AEF21F6940"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              },
              "unit": "short",
              "unitScale": true
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 15,
            "x": 0,
            "y": 0
          },
          "id": 2,
          "interval": "30s",
          "options": {
            "colorMode": "background",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": ["sum"],
              "fields": "",
              "values": false
            },
            "showPercentChange": false,
            "textMode": "auto",
            "wideLayout": true
          },
          "pluginVersion": "10.3.1",
          "targets": [
            {
              "datasource": {
                "type": "loki",
                "uid": "P8E80F9AEF21F6940"
              },
              "editorMode": "code",
              "expr": "sum by (status) (count_over_time({namespace=\"$namespace\"} | json | status != `` | __error__=\"\" [$__interval]))",
              "legendFormat": "HTTP Status: {{status}}",
              "queryType": "range",
              "refId": "A"
            }
          ],
          "title": "Requests per status code",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "loki",
            "uid": "P8E80F9AEF21F6940"
          },
          "gridPos": {
            "h": 12,
            "w": 24,
            "x": 0,
            "y": 8
          },
          "id": 1,
          "options": {
            "dedupStrategy": "none",
            "enableLogDetails": true,
            "prettifyLogMessage": false,
            "showCommonLabels": false,
            "showLabels": false,
            "showTime": false,
            "sortOrder": "Descending",
            "wrapLogMessage": false
          },
          "targets": [
            {
              "datasource": {
                "type": "loki",
                "uid": "P8E80F9AEF21F6940"
              },
              "editorMode": "code",
              "expr": "{namespace=\"$namespace\"} |= `` | json | __error__=`` | status != `` | line_format `request {{.method}} for {{.full_path}} with HTTP status {{.status}} from {{.remote_addr}}`",
              "queryType": "range",
              "refId": "A"
            }
          ],
          "title": "Recents requests",
          "type": "logs"
        }
      ],
      "refresh": "5s",
      "schemaVersion": 39,
      "tags": ["loki", "terraform"],
      "templating": {
        "list": [
          {
            "current": {
              "selected": false,
              "text": "api-prd",
              "value": "api-prd"
            },
            "datasource": {
              "type": "loki",
              "uid": "P8E80F9AEF21F6940"
            },
            "definition": "",
            "hide": 0,
            "includeAll": false,
            "label": "Namespace",
            "multi": false,
            "name": "namespace",
            "options": [],
            "query": {
              "label": "namespace",
              "refId": "LokiVariableQueryEditor-VariableQuery",
              "stream": "",
              "type": 1
            },
            "refresh": 1,
            "regex": "",
            "skipUrlSync": false,
            "sort": 0,
            "type": "query"
          }
        ]
      },
      "time": {
        "from": "now-6h",
        "to": "now"
      },
      "timepicker": {},
      "timezone": "",
      "title": "Loki / Requests",
      "uid": "e207e5d7-80eb-481d-ab68-8dceec646074",
      "version": 7,
      "weekStart": ""
    }
YAML
}
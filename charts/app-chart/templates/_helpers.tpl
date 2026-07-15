{{- define "app-chart.monitoringConfig" -}}
monitoring:
  enabled: {{ .Values.monitoring.enabled }}
  server:
    host: "0.0.0.0"
    port: {{ .Values.monitoring.server.port }}
    read_timeout: {{ .Values.monitoring.server.read_timeout | quote }}
    write_timeout: {{ .Values.monitoring.server.write_timeout | quote }}
    idle_timeout: {{ .Values.monitoring.server.idle_timeout | quote }}
    shutdown_timeout: {{ .Values.monitoring.server.shutdown_timeout | quote }}
  health_check_url: {{ .Values.monitoring.health_check_url | quote }}
{{- end }}

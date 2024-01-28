{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "example.name" -}}
{{- default "undefined" $.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

.PHONY: run-monitoring
run-monitoring:
	kubectl create namespace monitoring
	helm install prom stable/prometheus-operator -f ./deploy/helm/monitoring/prometheus.yaml --atomic -n monitoring
	helm install postgre-metrics stable/prometheus-postgres-exporter -n monitoring

.PHONY: run-nginx
run-nginx:
	kubectl create namespace nginx
	helm install nginx stable/nginx-ingress -f ./deploy/helm/nginx-ingress.yaml --atomic -n nginx

.PHONY: run
prepare:
	kubectl create namespace eshop

.PHONY: run
run:
	helm install catalog-service ./deploy/helm/catalogservice -n eshop

.PHONY: stop
stop:
	helm uninstall catalog-service -n eshop

.PHONY: remove-all
remove-all: stop
	helm uninstall nginx -n nginx
	helm uninstall prom -n monitoring
	helm uninstall postges-metrics -n monitoring
	kubectl delete namespace eshop
	kubectl delete namespace nginx
	kubectl delete namespace monitoring
package de.frosner.broccoli

package object conf {

  val CONSUL_URL_KEY = "broccoli.consul.url"
  val CONSUL_URL_DEFAULT = "http://localhost:8500"

  val CONSUL_LOOKUP_METHOD_KEY = "broccoli.consul.lookup"
  val CONSUL_DOMAIN_URL_KEY = "broccoli.consul.domain-url"
  val CONSUL_DOMAIN_PATH_KEY = "broccoli.consul.domain-path"
  val CONSUL_LOOKUP_METHOD_IP = "ip"
  val CONSUL_LOOKUP_METHOD_DNS = "dns"

}

When(/^I call the metric results of method with the results root id of the given processing$/) do
  @response = KalibroGatekeeperClient::Entities::MetricResult.metric_results_of(@response.results_root_id)
end

Given(/^I search a metric result with descendant results for the given metric result$/) do
  first_module_result = KalibroGatekeeperClient::Entities::ModuleResult.find(@response.results_root_id)

  metric_results = KalibroGatekeeperClient::Entities::MetricResult.metric_results_of(first_module_result.id)
  @response = metric_results.first.descendant_results
end

When(/^I call the history of method with the metric name and the results root id of the given processing$/) do
  @response = KalibroGatekeeperClient::Entities::MetricResult.history_of(@metric.name, @response.results_root_id)
end

Then (/^I should get a Float list$/) do
  expect(@response).to be_a(Array)
  expect(@response.first).to be_a(Float)
end

Then(/^I should get a list of metric results$/) do
  expect(@response).to be_a(Array)
  expect(@response.first).to be_a(KalibroGatekeeperClient::Entities::MetricResult)
end

Then(/^I should get a list of date metric results$/) do
  expect(@response).to be_a(Array)
  expect(@response.first).to be_a(KalibroGatekeeperClient::Entities::DateMetricResult)
end

Then(/^the first metric result should have a metric configuration snapshot$/) do
  expect(@response.first.configuration).to be_a(KalibroGatekeeperClient::Entities::MetricConfigurationSnapshot)
end
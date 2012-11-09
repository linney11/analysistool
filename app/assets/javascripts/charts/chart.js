/**
 * Created with JetBrains RubyMine.
 * User: Linney
 * Date: 8/11/12
 * Time: 01:55 PM
 * To change this template use File | Settings | File Templates.
 */

$(function() {
    var id = document.getElementById('id').value;

    var seriesOptions = [],
        yAxisOptions = [],
        seriesCounter = 0,
        names = id.split(","),
        colors = Highcharts.getOptions().colors;

    $.each(names, function(i, name) {

        $.getJSON('http://localhost:3000/users/showAC?id='+name+'.json', function(data) {

            seriesOptions[i] = {
                name: name,
                data: data,
                pointStart:1321430400000,
                pointInterval: 60*1000,
                tooltip: {
                    valueDecimalS:0
                }

            };

            // As we're loading the data asynchronously, we don't know what order it will arrive. So
            // we keep a counter and create the chart when all the data is loaded.
            seriesCounter++;

            if (seriesCounter == names.length) {
                createChart();
            }
        });
    });



    // create the chart when all data is loaded
    function createChart() {

        chart = new Highcharts.StockChart({
            chart: {
                renderTo: 'container'
            },

            rangeSelector: {
                selected: 4
            },
            title: {
                text: 'Activity Count'
            },

            yAxis: {

                plotLines: [{
                    value: 0,
                    width: 2,
                    color: 'silver'
                }]
            },

            plotOptions: {
                series: {
                    compare: 'percent'
                }
            },

            tooltip: {
                valueDecimals: 2
            },

            series: seriesOptions
        });
    }

});

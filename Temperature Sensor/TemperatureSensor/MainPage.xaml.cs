using Sensors.Dht;
using System;
using Windows.Devices.Gpio;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace TemperatureSensor
{
    public sealed partial class MainPage : Page
    {
        private const int DHTPIN = 4;
        private IDht dht = null;
        private GpioPin dhtPin = null;
        private DispatcherTimer sensorTimer = new DispatcherTimer();

        public MainPage()
        {
            this.InitializeComponent();

            dhtPin = GpioController.GetDefault().OpenPin(DHTPIN, GpioSharingMode.Exclusive);
            dht = new Dht11(dhtPin, GpioPinDriveMode.Input);
            sensorTimer.Interval = TimeSpan.FromSeconds(1);
            sensorTimer.Tick += sensorTimer_Tick;
            sensorTimer.Start();

            temperatureMeter.Value = "OFF";
            humidityMeter.Value = "OFF";
        }

        private void sensorTimer_Tick(object sender, object e)
        {
            readSensor();
        }

        private async void readSensor()
        {
            double temp = 0;
            double humidity = 0;

            DhtReading reading = await dht.GetReadingAsync().AsTask();
            if (reading.IsValid)
            {
                temp = reading.Temperature;
                humidity = reading.Humidity;

                temperatureMeter.Value = string.Format("{0:0.0}", temp);
                humidityMeter.Value = string.Format("{0:0}", humidity);
            }
        }
    }
}

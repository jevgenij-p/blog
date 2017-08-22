using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace TemperatureSensor.Controls
{
    public sealed partial class RadialMeter : UserControl
    {
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value",
            typeof(string),
            typeof(RadialMeter),
            new PropertyMetadata(default(string)));

        public string Value
        {
            get { return (string)GetValue(ValueProperty); }
            set { SetValue(ValueProperty, value); }
        }

        public RadialMeter()
        {
            this.InitializeComponent();
            this.DataContext = this;
        }
    }
}

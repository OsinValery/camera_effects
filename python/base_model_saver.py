import tensorflow as tf

Model = tf.keras.applications.mobilenet_v2.MobileNetV2(
    input_shape=None,
    alpha=1.0,
    include_top=True,
    weights='imagenet',
    input_tensor=None,
    pooling=None,
    classes=1000,
    classifier_activation='softmax',
)

Model.save('./base.model', save_format=None)
print(dir(Model))
print(Model)

print('\n\n')
#print(Model.get_config())
print('\n\n')
layers = Model.layers
names = [var.name for var in layers ]
print(names)

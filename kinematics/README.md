# Leg Forward Kinematics

This describes the forward kinematic calculations implemented in ```compute_kinematics.m```

### Knees
The positions of the left and right knees can be calculated from the hip width $w$ the femur length $l_f$ and the left and right hip angles, $\theta_L$ and $\theta_R$ respectively.

$$ x_{Rk} = l_f\cos(\theta_R) + \frac{w}{2} \hspace{35pt} y_{Rk} = l_f\sin(\theta_R) $$

$$ x_{Lk} = l_f\cos(\theta_L) - \frac{w}{2} \hspace{35pt} y_{Lk} = l_f\sin(\theta_L) $$

### Ankle

Let $R$ be the distance between the knees

$$ R^2 = (x_{Rk} - x_{Lk})^2 + (y_{Rk} - y_{Lk})^2 $$

The location of the ankle is then simply given by the intersection points of two circles of radius $l_t$ placed at either knee.

$$ x_a = \frac{x_{Rk} + x_{Lk}}{2} - \frac{1}{2}\sqrt{4\frac{l_t^2}{R^2}-1}(y_{Lk} - y_{Rk}) $$

$$ y_a = \frac{y_{Rk} + y_{Lk}}{2} - \frac{1}{2}\sqrt{4\frac{l_t^2}{R^2}-1}(x_{Rk} - x_{Lk}) $$

### Foot

The foot is an extension of the right tibia link. The angle of this link is given by

$$ \alpha = \text{atan2}(y_a - y_{Rk}, x_a - x_{Rk}) $$

Using $\alpha$ the position of the foot can be calculated from the ankle

$$ x_{f} = x_a + l_{a\parallel}\cos(\alpha) + l_{a\perp}\cos(\alpha+\frac{\pi}{2}) $$

$$ y_{f} = y_a + l_{a\parallel}\sin(\alpha) + l_{a\perp}\sin(\alpha+\frac{\pi}{2}) $$



### Jacobian Weirdness


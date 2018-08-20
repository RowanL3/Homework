i_height = float(input("initial height: "))
u_velocity = float(input("upwards velocity: "))

t_max_height = u_velocity/9.8

height = i_height + u_velocity * t_max_height - 4.9 * (t_max_height *t_max_height)

print(height)





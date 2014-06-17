<?xml version="1.0" encoding="UTF-8"?>
<GestureMarkupLanguage>
			
	<Gesture_set gesture_set_name="core-finger-touch-gestures">
	
		<Gesture id="1-finger-drag" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="1" point_number_min="1" point_number_max="1"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="3-finger-drag" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="3" point_number_min="3" point_number_max="3"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="5-finger-drag" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="5" point_number_min="5" point_number_max="5"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="3-finger-drag-3d" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="1" point_number_min="1" point_number_max="1"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
						<property id="drag_dz" result="dz"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
					<property ref="drag_dz" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dz" active="true" delta_min="0" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
						<property ref="drag_dz" target="z"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="2-finger-scale" type="scale">
			<match>
				<action>
					<initial>
						<cluster point_number="2" point_number_min="2" point_number_max="2"/>
					</initial>
				</action>
			</match>
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="scale"/>
					<returns>
						<property id="scale_dsx" result="ds"/>
						<property id="scale_dsy" result="ds"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="scale_dsx" active="true" friction="0.9"/>
					<property ref="scale_dsy" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="scale_dsx" active="true" delta_min="0.0005" delta_max="0.5"/>
					<property ref="scale_dsy" active="true" delta_min="0.0005" delta_max="0.5"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="scale">
						<property ref="scale_dsx" target="scaleX"/>
						<property ref="scale_dsy" target="scaleY"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="1-finger-tap" type="tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="200" translation_max="10"/>
										<cluster point_number="1" point_number_min="1" point_number_max="1"/>
										<event touch_event="touchEnd"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="tap"/>
									<returns>
										<property id="tap_x" result="x"/>
										<property id="tap_y" result="y"/>
										<property id="tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="tap">
										<property ref="tap_x"/>
										<property ref="tap_y"/>
										<property ref="tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
		
	</Gesture_set>
	
	<Gesture_set gesture_set_name="custom-tag-touch-gestures">
		
		<Gesture id="3-tag-drag-3d" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="3" point_number_min="3" point_number_max="3"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
						<property id="drag_dz" result="dz"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
					<property ref="drag_dz" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dz" active="true" delta_min="0" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
						<property ref="drag_dz" target="z"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="5-tag-drag-3d" type="drag">
			<match>
				<action>
					<initial>
						<cluster point_number="5" point_number_min="5" point_number_max="5"/>
					</initial>
				</action>
			</match>	
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="drag"/>
					<returns>
						<property id="drag_dx" result="dx"/>
						<property id="drag_dy" result="dy"/>
						<property id="drag_dz" result="dz"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="drag_dx" active="true" friction="0.9"/>
					<property ref="drag_dy" active="true" friction="0.9"/>
					<property ref="drag_dz" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="drag_dx" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dy" active="true" delta_min="0" delta_max="500"/>
					<property ref="drag_dz" active="true" delta_min="0" delta_max="500"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="drag">
						<property ref="drag_dx" target="x"/>
						<property ref="drag_dy" target="y"/>
						<property ref="drag_dz" target="z"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="4-tag-rotate-3d" type="rotate">
			<match>
				<action>
					<initial>
						<cluster point_number="4" point_number_min="4" point_number_max="4"/>
					</initial>
				</action>
			</match>
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="rotate"/>
					<returns>
						<property id="rotate_dthetaX" result="dthetaX"/>
						<property id="rotate_dthetaY" result="dthetaY"/>
						<property id="rotate_dthetaZ" result="dthetaZ"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="rotate_dthetaX" active="true" friction="0.9"/>
					<property ref="rotate_dthetaY" active="true" friction="0.9"/>
					<property ref="rotate_dthetaZ" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="rotate_dthetaX" active="true" delta_min="0" delta_max="20"/>
					<property ref="rotate_dthetaY" active="true" delta_min="0" delta_max="20"/>
					<property ref="rotate_dthetaZ" active="true" delta_min="0" delta_max="20"/>
				</delta_filter>
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="rotate">
						<property ref="rotate_dthetaX" target="rotationX"/>
						<property ref="rotate_dthetaY" target="rotationY"/>
						<property ref="rotate_dthetaZ" target="rotationZ"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
		
		<Gesture id="4-tag-rotate" type="rotate">
			<match>
				<action>
					<initial>
						<cluster point_number="4" point_number_min="4" point_number_max="4"/>
					</initial>
				</action>
			</match>
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="rotate"/>
					<returns>
						<property id="rotate_dtheta" result="dtheta"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="rotate_dtheta" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="rotate_dtheta" active="true" delta_min="0.01" delta_max="20"/>
				</delta_filter>
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="rotate">
						<property ref="rotate_dtheta" target="rotate"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>
			
		
		<Gesture id="2-tag-scale-3d" type="scale">
			<match>
				<action>
					<initial>
						<cluster point_number="2" point_number_min="2" point_number_max="2"/>
					</initial>
				</action>
			</match>
			<analysis>
				<algorithm class="kinemetric" type="continuous">
					<library module="scale"/>
					<returns>
						<property id="scale_dsx" result="ds"/>
						<property id="scale_dsy" result="ds"/>
						<property id="scale_dsz" result="ds"/>
					</returns>
				</algorithm>
			</analysis>	
			<processing>
				<inertial_filter>
					<property ref="scale_dsx" active="true" friction="0.9"/>
					<property ref="scale_dsy" active="true" friction="0.9"/>
					<property ref="scale_dsz" active="true" friction="0.9"/>
				</inertial_filter>
				<delta_filter>
					<property ref="scale_dsx" active="true" delta_min="0" delta_max="0.5"/>
					<property ref="scale_dsy" active="true" delta_min="0" delta_max="0.5"/>
					<property ref="scale_dsz" active="true" delta_min="0" delta_max="0.5"/>
				</delta_filter>						
			</processing>
			<mapping>
				<update dispatch_type="continuous">
					<gesture_event type="scale">
						<property ref="scale_dsx" target="scaleX"/>
						<property ref="scale_dsy" target="scaleY"/>
						<property ref="scale_dsz" target="scaleZ"/>
					</gesture_event>
				</update>
			</mapping>
		</Gesture>		
		
				
	</Gesture_set>	
			
</GestureMarkupLanguage>
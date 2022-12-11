using UnityEngine;
using UnityEngine.InputSystem;

public class Move : MonoBehaviour
{
    // "Public" fields (in Unity editor)
    [SerializeField, Range(0f, 100f)] private float maxSpeed = 4f;
    [SerializeField, Range(0f, 100f)] private float maxGroundAcceleration = 35f;
    [SerializeField, Range(0f, 100f)] private float maxAirAcceleration = 20f;

    private Rigidbody2D _body; // Character's GameObject physics component
    private GroundCheckGmtk _groundCheck; // Character's reference to the GroundCheck state; helps determine whether character is on the ground
    private float _direction; // Character's current direction
    private Vector2 _desiredVelocity; //
    private Vector2 _actualVelocity; // Character's actual velocity at the end of frame

    private float _maxSpeedChange, _acceleration;

    // Awake is called once at initialization, before Start
    void Awake()
    {
        // assign references to the Character GameObject's components
        _body = GetComponent<Rigidbody2D>();
        _groundCheck = GetComponent<GroundCheckGmtk>();
    }

    public void OnMove(InputValue value)
    {
        Debug.Log("OnMove callback");

        if (true) // (moveCheck.canMove)
        {
            _direction = value.Get<float>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        _desiredVelocity = new Vector2(_direction, 0f) * Mathf.Max(maxSpeed - _groundCheck.Friction, 0f); // velocity is never drops below zero
    }

    // FixedUpdate is called every fixed framerate frame.
    // Whereas Update calls can fluctuate due to lag, FixedUpdate is called at the fixed interval (default 0.02 seconds).
    private void FixedUpdate()
    {
        _actualVelocity = _body.velocity;


        _acceleration = _groundCheck.IsOnGround ? maxGroundAcceleration : maxAirAcceleration; // Choose acceleration based on whether character is on the ground
        _maxSpeedChange = _acceleration * Time.deltaTime; // or Time.fixedDeltaTime?
        _actualVelocity.x = Mathf.MoveTowards(_actualVelocity.x, _desiredVelocity.x, _maxSpeedChange); // MoveTowards: Linearly interpolates between a and b by t, without exceeding t (maxDelta).

        _body.velocity = _actualVelocity; // assign new actualVelocity values to character body 

        // Debug.Log(_body.velocity.x);
        // Debug.Log(_body.velocity.y);
    }
}

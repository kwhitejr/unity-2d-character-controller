using UnityEngine;

public class GroundCheck : MonoBehaviour
{
    public bool IsOnGround { get; private set; }
    public float Friction { get; private set; }

    private Vector2 _normal;
    private PhysicsMaterial2D _material;
    private float noFriction = 0f;

    private void OnCollisionExit2D(Collision2D collision)
    {
        IsOnGround = false;
        Friction = noFriction;
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        EvaluateCollision(collision);
        RetrieveFriction(collision);
    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        EvaluateCollision(collision);
        RetrieveFriction(collision);
    }

    // Set collision with ground
    // Collision is true when normal y-axis is 1
    // TODO: read up on Vector2 + Contact
    private void EvaluateCollision(Collision2D collision)
    {
        for (int i = 0; i < collision.contactCount; i++)
        {
            _normal = collision.GetContact(i).normal;
            IsOnGround |= _normal.y >= 0.9f;
        }
    }

    // Get friction value from attached material
    private void RetrieveFriction(Collision2D collision)
    {
        _material = collision.rigidbody.sharedMaterial;

        Friction = noFriction; // default to no friction

        if (_material != null)
        {
            Friction = _material.friction;
        }
    }
}

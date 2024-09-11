using System;

public interface IActivable
{
    bool IsActive { get; }
    event Action<bool> OnActivationChanged;

    void Activate();
    void Deactivate();
    void Toggle();
    void ActivateForDuration(float duration);
}
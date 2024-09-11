using System.IO;
using UnityEngine;

public static class SaveSystem
{
    private static string filePath => Path.Combine(Application.persistentDataPath, "savegame.json");

    public static void SaveGameData(GameData data)
    {
        string json = JsonUtility.ToJson(data, true);
        File.WriteAllText(filePath, json);
        Debug.Log("Game Saved");
    }

    public static GameData LoadGameData()
    {
        if (File.Exists(filePath))
        {
            string json = File.ReadAllText(filePath);
            GameData data = JsonUtility.FromJson<GameData>(json);
            Debug.Log("Game Loaded");
            return data;
        }
        else
        {
            Debug.Log("No save file found.");
            return new GameData(); // Return default data if no save file exists
        }
    }

    public static void ClearSavedData()
    {
        if (File.Exists(filePath))
        {
            File.Delete(filePath);
            Debug.Log("Save file deleted");
        }
    }

    public static bool SaveFileExists()
    {
        return File.Exists(filePath);
    }
}

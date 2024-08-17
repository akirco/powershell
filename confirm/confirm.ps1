function Confirm-Action {
  param (
    [string]$Message = "Are you sure you want to proceed?",
    [string]$Default = "Yes"
  )

  $prompt = "$Message (Yes/No) [$Default]"
  $confirmation = Read-Host $prompt

  if ([string]::IsNullOrWhiteSpace($confirmation)) {
    $confirmation = $Default
  }
  switch ($confirmation.ToLower()) {
    "yes" {
      return $true
    }
    "no" {
      return $false
    }
    default {
      return  Confirm-Action -Message $Message -Default $Default
    }
  }
}

$res = Confirm-Action -Message "Do you want to continue?"
Write-Host "res: $res"
def normalize_gender(gender: str) -> str:
    if not gender:
        return "belirtilmemiş"

    gender = gender.lower().strip()

 
    female_terms = ["female", "kadın", "kadin", "woman", "bayan", "hanım"]
   
    male_terms = ["male", "erkek", "man", "bay", "adam", "bey"]

    if gender in female_terms:
        return "kadın"
    elif gender in male_terms:
        return "erkek"
    else:
        return "belirtilmemiş"

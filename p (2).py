#####################  Company Table  #####################
import pandas as pd
import nltk
nltk.download('punkt')
nltk.download('stopwords')
from nltk.stem import PorterStemmer
import re

### Tokenize Dataset ###
translation = {}
def tokenize_col(df: pd.DataFrame, col: str) -> pd.DataFrame:
    """
    Preprocess a Dataframe to tokenize selected column.

    Args:
        df (pd.DataFrame): Dataframe to be changed.
        col (str): Name of col to tokenize.

    Returns:
        pd.Dataframe : A Dataframe with tokenized column as a string of tokens.
    """

    stemmer = PorterStemmer()
    for index, row in df.iterrows():
        desc = row[col]

        # Error handling
        if type(desc) is pd.Series:
            desc = desc.to_string()

        if type(desc) is not str:
            desc = ['']
            continue

        # Lowercase the column
        desc = desc.lower()

        # Remove newlines
        desc = desc.replace('\n', ' ').replace('\r', ' ')

        # Remove stopwords
        for word in nltk.corpus.stopwords.words('english'):
            temp = desc.split()
            while word in temp:
                temp.remove(word)
            desc = ' '.join(temp)

        # # Remove digits
        # for digit in [0,1,2,3,4,5,6,7,8,9]:
        #     desc = desc.replace(str(digit), ' ')

        # # Remove punctuation
        # for p in punctuation:
        #     desc = desc.replace(p, ' ')

        # Remove emoji characters
        pattern = re.compile('[^a-z]+')
        
        desc = pattern.sub(r' ', desc)

        # Tokenize
        tokens = nltk.tokenize.word_tokenize(desc)

        # Stem words
        for i in range(len(tokens)):
            st = stemmer.stem(tokens[i])
            if len(st) > 12:
                st = ''
                tokens[i] = st
                continue
            if st in translation:
                translation[st].add(tokens[i])
            else:
                translation[st] = set()
                translation[st].add(tokens[i])
            tokens[i] = st

        desc = ' '.join(tokens)

        df.at[index, col] = desc

    return df

### Companies.CSV ###
#####################

df = pd.read_csv(r'companies.csv')

# removing unwanted Columns
df = df[['company_id', 'name', 'description', 'zip_code']]

# removing rows with empty company_id
df =df[df['company_id'].notna()]

# renaming columns to be as The ER diagram
df.rename(columns={'company_id':'CID','name': 'Name', 'description': 'Description', 'zip_code': 'Zipcode'}, inplace=True)

tokenize_col(df, 'Description')

#exporting 
df.to_csv(r'companies_cleaned.csv', index= False)

## company_industries.CSV ###
#############################

df = pd.read_csv(r"company_industries.csv")
# removing rows with empty company_id or empty industry
df =df[df['company_id'].notna()]
df =df[df['industry'].notna()]

# renaming columns to be as The ER diagram
df.rename(columns={'company_id':'CID'}, inplace=True)

#exporting after finishing
df.to_csv(r'Industries_cleaned.csv', index= False)

### company_specialities.CSV ###
################################

df = pd.read_csv(r"company_specialities.csv")
# removing rows with empty company_id or industry
df =df[df['company_id'].notna()]
df =df[df['speciality'].notna()]

# renaming columns to be as The ER diagram
df.rename(columns={'company_id':'CID'}, inplace=True)

#exporting after finishing
df.to_csv(r'Speciality_cleaned.csv', index= False)

### employee_counts.CSV ###
###########################

df = pd.read_csv(r"employee_counts.csv")
# removing rows without company_id 
df =df[df['company_id'].notna()]

# removing unwanted Columns
df = df[['company_id', 'employee_count', 'follower_count']]

# Ensuring that Counts are INT
df['employee_count'] = df['employee_count'].astype(int)
df['follower_count'] = df['follower_count'].astype(int)

# renaming columns to be as The ER diagram
df.rename(columns={'company_id':'CID'},inplace=True)

#exporting
df.to_csv(r'employee_count_cleaned1.csv', index= False)


####################  Job Table  #####################

### job_posting.CSV ###
df = pd.read_csv(r'job_postings.csv')

# removing unwanted Columns
df = df[['job_id', 'company_id', 'description', 'title', 'skills_desc', 'work_type']]

## removing rows with empty job_id
df =df[df['job_id'].notna()]

# removing rows with empty company_id
df =df[df['company_id'].notna()]

# renaming columns to be as The ER diagram
df.rename(columns={'job_id': 'JID', 'company_id':'CID', 'description': 'Description', 'title':'Title'}, inplace=True)

df['CID'] = df['CID'].astype(int)

tokenize_col(df, 'Description')
tokenize_col(df, 'skills_desc')

#exporting after finishing
df.to_csv(r'job_posting_cleaned.csv', index= False)


#####################  Salary Table  #####################

df = pd.read_csv(r"salaries.csv")

# removing rows without salary_id 
df =df[df['salary_id'].notna()]

# removing unwanted Columns
df = df[['job_id','salary_id', 'max_salary', 'med_salary', 'min_salary', 'pay_period', 'currency']]

# renaming columns to be as The ER diagram
df.rename(columns={'job_id':'JID','salary_id':'SID', 'max_salary': 'Max', 'med_salary': 'Med', 'min_salary': 'Min', 'pay_period': 'Pay_Period', 'currency': 'Currency'},inplace=True)

df['Max'] = pd.to_numeric(df['Max'], errors='coerce').fillna(0).astype(int)
df['Med'] = pd.to_numeric(df['Med'], errors='coerce').fillna(0).astype(int)
df['Min'] = pd.to_numeric(df['Min'], errors='coerce').fillna(0).astype(int)

#exporting 
df.to_csv(r'Salaries_cleaned.csv', index= False)

print(translation)
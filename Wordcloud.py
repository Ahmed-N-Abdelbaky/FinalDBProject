import pandas as pd
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# Load the CSV file
df = pd.read_csv(r'C:\Users\ahmed\Downloads\topterms (3).csv')

# Convert DataFrame to dictionary
word_freq = dict(zip(df['keyword'], df['sum']))

# Generate word cloud
wordcloud = WordCloud(width=800, height=800, background_color='white').generate_from_frequencies(word_freq)

# Plot
plt.figure(figsize=(8, 8), facecolor=None)
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.tight_layout(pad=0)
plt.show()
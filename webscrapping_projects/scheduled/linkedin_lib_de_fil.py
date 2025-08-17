import pandas as pd
import logging
from datetime import datetime
import os

from linkedin_jobs_scraper import LinkedinScraper
from linkedin_jobs_scraper.events import Events, EventData, EventMetrics
from linkedin_jobs_scraper.query import Query, QueryOptions, QueryFilters
from linkedin_jobs_scraper.filters import TimeFilters, TypeFilters

logging.basicConfig(level=logging.INFO)

job_listings = []

def on_data(data: EventData):
    job_listings.append({
        'timestamp': datetime.utcnow().isoformat(),
        'job_id': data.job_id,
        'title': data.title,
        'company': data.company,
        'date': data.date,
        'link': data.link,
        'description': data.description
    })

def on_metrics(metrics: EventMetrics):
    print('[ON_METRICS]', str(metrics))

def on_error(error):
    print('[ON_ERROR]', error)

def on_end():
    print('[ON_END] Scraping complete.')

scraper = LinkedinScraper(
    headless=True,
    max_workers=1,
    slow_mo=2,
    page_load_timeout=300
)

scraper.on(Events.DATA, on_data)
scraper.on(Events.ERROR, on_error)
scraper.on(Events.END, on_end)

queries = [
    Query(
        query='Data Engineer',
        options=QueryOptions(
            locations=['Germany'],
            apply_link=False,
            limit=3000,
            filters=QueryFilters(
                time=TimeFilters.DAY,
                type=[TypeFilters.FULL_TIME],
            )
        )
    ),
]

scraper.run(queries)

# Filter for "visa" or "relocate"
filtered_jobs = []
for job in job_listings:
    if isinstance(job.get('description'), str):
        desc = job['description'].lower()
        if 'relocat' in desc or 'visa' in desc:
            filtered_jobs.append(job)
            
if len(filtered_jobs) > 0:
    df_new = pd.DataFrame(filtered_jobs)
    df_new.drop('description', axis=1, inplace=True)
    
    # Output directory & file
    output_dir = "webscrapping_projects/scheduled/outputs"
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, "jobs_log.tsv")
    
    # Load existing and remove duplicates
    if os.path.exists(output_file):
        df_existing = pd.read_csv(output_file, sep='\t')
        df_combined = pd.concat([df_existing, df_new], ignore_index=True)
        df_combined.sort_values('timestamp', ascending=False, inplace=True)
        df_combined.drop_duplicates(subset='job_id', keep='first', inplace=True)
    else:
        df_combined = df_new
    
    # Save updated file
    df_combined.to_csv(output_file, sep='\t', index=False)
    print(f"✅ Saved {len(df_new)} new jobs. Total entries: {len(df_combined)}")
else:
    print("No new jobs with sponsorship")

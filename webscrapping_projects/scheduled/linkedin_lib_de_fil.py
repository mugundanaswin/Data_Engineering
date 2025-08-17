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
    global job_listings
    job_listings.append({
        'timestamp': datetime.utcnow().isoformat(),
        'title': data.title,
        'company': data.company,
        'company_link': data.company_link,
        'date_text': data.date_text,
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
            skip_promoted_jobs=True,
            page_offset=2,
            limit=3000,
            filters=QueryFilters(
                time=TimeFilters.DAY,
                type=[TypeFilters.FULL_TIME],
            )
        )
    ),
]

scraper.run(queries)

# Filter jobs
filtered_jobs = []
for job in job_listings:
    if isinstance(job.get('description'), str):
        description_lower = job['description'].lower()
        if 'relocat' in description_lower or 'visa' in description_lower:
            filtered_jobs.append(job)

df = pd.DataFrame(filtered_jobs)

# Append to CSV
os.makedirs("outputs", exist_ok=True)
output_file = "outputs/jobs_log.csv"
if os.path.exists(output_file):
    df.to_csv(output_file, mode='a', index=False, header=False)
else:
    df.to_csv(output_file, index=False, header=True)

print(f"✅ Saved {len(df)} filtered jobs to {output_file}")

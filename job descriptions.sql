SELECT
    company."Name",
    company."industry",
	job."title",
	job."description",
	job."skill_desc",
    GREATEST(CASE 
        WHEN salary.Pay_Period ILIKE 'hourly' THEN salary."Max" * 2080 
        WHEN salary.Pay_Period ILIKE 'monthly' THEN salary."Max" * 12 
        ELSE salary."Max" 
    END) AS Max_Yearly_Salary,
    job."description" AS "Description"
FROM company
INNER JOIN job ON company.CID = job.CID
INNER JOIN salary ON job.JID = salary.JID
WHERE Pay_Period NOT ILIKE 'once'
AND company."industry" IN (
    'Online Media',
    'Computer Hardware Manufacturing',
    'Semiconductor Manufacturing',
    'Computer and Network Security',
    'Software Development',
    'Defense and Space Manufacturing',
    'Biotechnology Research',
    'Computer Software',
    'Railroad Manufacture',
    'Industrial Automation',
    'Computer Games',
    'Semiconductors',
    'Technology, Information and Internet',
    'Research',
    'Electrical & Electronic Manufacturing',
    'Biotechnology',
    'Automation Machinery Manufacturing',
    'Computer & Network Security',
    'Broadcast Media Production and Distribution',
    'Pharmaceuticals',
    'Pharmaceutical Manufacturing',
    'Machinery Manufacturing',
    'Defense & Space',
    'Online Audio and Video Media',
    'Medical Equipment Manufacturing',
    'Information Technology & Services',
    'Computer Hardware',
    'Industrial Machinery Manufacturing',
    'Automotive',
    'Telecommunications',
    'Computers and Electronics Manufacturing',
    'Aviation and Aerospace Component Manufacturing',
    'Mechanical Or Industrial Engineering',
    'Appliances, Electrical, and Electronics Manufacturing',
    'Mining & Metals'
)
GROUP BY company."Name", job."description", Max_Yearly_Salary, job."skill_desc", company."industry", job."title"
ORDER BY Max_Yearly_Salary DESC;

-- to Query_Results_3.csv
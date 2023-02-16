From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v3 3/4] mm: hugetlb: change to return bool for
 isolate_hugetlb()
Date: Thu, 16 Feb 2023 10:04:29 +0800
Message-ID: <cca8918f-e8c2-8f2c-cbb9-5797631ab3eb@linux.alibaba.com>
References: <20230215202548.92462-1-sj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230215202548.92462-1-sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/16/2023 4:25 AM, SeongJae Park wrote:
> On Wed, 15 Feb 2023 18:39:36 +0800 Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> 
>> Now the isolate_hugetlb() only returns 0 or -EBUSY, and most users did not
>> care about the negative value, thus we can convert the isolate_hugetlb()
>> to return a boolean value to make code more clear when checking the
>> hugetlb isolation state. Moreover converts 2 users which will consider
>> the negative value returned by isolate_hugetlb().
>>
>> No functional changes intended.
>>
>> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
> [...]
>>   include/linux/hugetlb.h |  6 +++---
>>   mm/hugetlb.c            | 13 ++++++++-----
>>   mm/memory-failure.c     |  2 +-
>>   mm/mempolicy.c          |  2 +-
>>   mm/migrate.c            |  7 +++----
>>   5 files changed, 16 insertions(+), 14 deletions(-)
>>
> [...]
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 3a01a9dbf445..16513cd23d5d 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2925,13 +2925,16 @@ static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
>>   		 */
>>   		goto free_new;
>>   	} else if (folio_ref_count(old_folio)) {
>> +		bool isolated;
>> +
>>   		/*
>>   		 * Someone has grabbed the folio, try to isolate it here.
>>   		 * Fail with -EBUSY if not possible.
>>   		 */
>>   		spin_unlock_irq(&hugetlb_lock);
>> -		ret = isolate_hugetlb(old_folio, list);
>> +		isolated = isolate_hugetlb(old_folio, list);
>>   		spin_lock_irq(&hugetlb_lock);
>> +		ret = isolated ? 0 : -EBUSY;
>>   		goto free_new;
> 
> Nit.  I'd personally prefer to set 'ret' before entering this critical section
> to keep the section short, but this would be just a mean comment that wouldn't
> worth request respin.

Yes, good catch. And I see Andrew has helped to do this (Thanks Andrew).

Thanks for reviewing.

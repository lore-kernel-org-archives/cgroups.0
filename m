From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2 2/4] mm: change to return bool for isolate_lru_page()
Date: Wed, 15 Feb 2023 09:04:04 +0800
Message-ID: <3180bded-7beb-c994-7f13-2d75eeb82516@linux.alibaba.com>
References: <20230214193204.72057-1-sj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230214193204.72057-1-sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/15/2023 3:32 AM, SeongJae Park wrote:
> On Tue, 14 Feb 2023 21:59:30 +0800 Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> 
>> The isolate_lru_page() can only return 0 or -EBUSY, and most users did
>> not care about the negative error of isolate_lru_page(), except one user
>> in add_page_for_migration(). So we can convert the isolate_lru_page() to
>> return a boolean value, which can help to make the code more clear when
>> checking the return value of isolate_lru_page().
>>
>> Also convert all users' logic of checking the isolation state.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> ---
>>   mm/folio-compat.c   | 12 +++---------
>>   mm/internal.h       |  2 +-
>>   mm/khugepaged.c     |  2 +-
>>   mm/memcontrol.c     |  4 ++--
>>   mm/memory-failure.c |  4 ++--
>>   mm/memory_hotplug.c |  2 +-
>>   mm/migrate.c        |  9 ++++++---
>>   mm/migrate_device.c |  2 +-
>>   8 files changed, 17 insertions(+), 20 deletions(-)
>>
> [...]
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a1e8c3e9ab08..17ed80707518 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1668,7 +1668,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>>   		 * LRU and non-lru movable pages.
>>   		 */
>>   		if (PageLRU(page))
>> -			ret = isolate_lru_page(page);
>> +			ret = !isolate_lru_page(page);
> 
> This may change return value of this function.  That is, this function will
> return 1 instead of -EBUSY after this change.  It's not a real issue as no
> caller of this function takes care of the return value, though.

Yes, I've also thought about this. OK, I can keep the original logic 
here by adding a new variable. Thanks.

isolated = isolate_lru_page(page);
ret = isolated ? 0 : -EBUSY;

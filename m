From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Tue, 12 Oct 2021 13:42:41 +0300
Message-ID: <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a@virtuozzo.com>
References: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
 <29155011-f884-b0e5-218e-911039568acb@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=bEbXgNx8UNhTNiQSVrQ+7EoBtCdD7MvBGkcwxGWc4cs=; b=SmT2sdTNW0HEqxE0m
        moILfvR4WUkRN/qJdfdiDnBRMRXGquRZAofXgF5d54Zzkt1ln9tBN8XPALEk1iDBhHy8erFkLJ9Bo
        WnQyYEjYw1xSV/QWTN12zef+4kbJJVBsuatmIdz3aKFLQvIc7iGUuzKemcaf9gjg/k06zn9PtE2KM
        =;
In-Reply-To: <29155011-f884-b0e5-218e-911039568acb@suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel@openvz.org, Mel Gorman <mgorman@techsingularity.net>, Uladzislau Rezki <urezki@gmail.com>

On 08.10.2021 14:47, Vlastimil Babka wrote:
> On 10/8/21 11:24, Vasily Averin wrote:
>> __alloc_pages_bulk can call __count_zid_vm_events and zone_statistics
>> with nr_account = 0.
> 
> But that's not a bug, right? Just an effective no-op that's not commonly
> happening, so is it worth the check?

Why not?

Yes, it's not a bug, it just makes the kernel a bit more efficient in a very unlikely case.
However, it looks strange and makes uninformed code reviewers like me worry about possible
problems inside the affected functions. No one else calls these functions from 0.
 
>> Fixes: 3e23060b2d0b ("mm/page_alloc: batch the accounting updates in the bulk allocator")
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  mm/page_alloc.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 602819a232e5..e67113452ee8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5364,9 +5364,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>>  	}
>>  
>>  	local_unlock_irqrestore(&pagesets.lock, flags);
>> -
>> -	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
>> -	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
>> +	if (nr_account) {
>> +		__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
>> +		zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
>> +	}
>>  	if (objcg)
>>  		memcg_bulk_post_charge_hook(objcg, nr_pre_charge - nr_account);
>>  
>>
> 


From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Fri, 19 Feb 2021 11:28:47 -0800
Message-ID: <1ecd277e-c236-08e1-f068-3dd65ee0e640@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+B2KvJVSgfVDTe@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YC+B2KvJVSgfVDTe@dhcp22.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Ying Huang <ying.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 2/19/21 1:16 AM, Michal Hocko wrote:

>>
>> Something like this?
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8bddee75f5cb..b50cae3b2a1a 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3472,6 +3472,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>>                 if (!mz)
>>                         break;
>>
>> +               /*
>> +                * Soft limit tree is updated based on memcg events sampling.
>> +                * We could have missed some updates on page uncharge and
>> +                * the cgroup is below soft limit.  Skip useless soft reclaim.
>> +                */
>> +               if (!soft_limit_excess(mz->memcg))
>> +                       continue;
>> +
>>                 nr_scanned = 0;
>>                 reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
> 
> Yes I meant something like this but then I have looked more closely and
> this shouldn't be needed afterall. __mem_cgroup_largest_soft_limit_node
> already does all the work
>         if (!soft_limit_excess(mz->memcg) ||
>             !css_tryget(&mz->memcg->css))
>                 goto retry;
> so this shouldn't really happen.
> 

Ah, that's true.  The added check for soft_limit_excess is not needed.

Do you think it is still a good idea to add patch 3 to
restrict the uncharge update in page batch of the same node and cgroup?

I am okay with dropping patch 3 and let the inaccuracies in the ordering
of soft limit tree be cleared out by an occasional soft reclaim.
These inaccuracies will still be there even with patch 3 fix due
to the memcg event sampling.  Patch 3 does help to keep the soft reclaim
tree ordering more up to date.

Thanks.

Tim

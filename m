From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH]
 mm-vmscan-dont-mess-with-pgdat-flags-in-memcg-reclaim-v2-fix
Date: Fri, 6 Apr 2018 18:09:54 +0300
Message-ID: <406e02a5-16d4-7cd3-de01-24bee60eab02@virtuozzo.com>
References: <CALvZod7P7cE38fDrWd=0caA2J6ZOmSzEuLGQH9VSaagCbo5O+A@mail.gmail.com>
 <20180406135215.10057-1-aryabinin@virtuozzo.com>
 <CALvZod7bGjx-fUKZ15oVAkXkeneZjtoRFiUSpKSZ1U0DA_e1BA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=shCXcyxtEV+PObx4FGPw5EtfpPZpaNL00TQ+i+W44i4=;
 b=UFmzkG/VbXwcGvFpIU6dyeKuxPLhBTs+2YlHj8iL7ATD9fPK/7tr72jlRq3NfRDgHH9R7+z4ms+7V2s6WeKU2UIJmsFDkVE1ZT567HTZKfWPe9afPBqj6Vk93qOy0loKBZJ8ymvzf6wAznrGDNy4EqJ2I9DCmu6OcRNkUxOKfvY=
In-Reply-To: <CALvZod7bGjx-fUKZ15oVAkXkeneZjtoRFiUSpKSZ1U0DA_e1BA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>



On 04/06/2018 05:37 PM, Shakeel Butt wrote:

>>
>> @@ -2482,7 +2494,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>>  static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
>>  {
>>         return test_bit(PGDAT_CONGESTED, &pgdat->flags) ||
>> -               (memcg && test_memcg_bit(PGDAT_CONGESTED, memcg));
>> +               (memcg && memcg_congested(pgdat, memcg));
> 
> I am wondering if we should check all ancestors for congestion as
> well. Maybe a parallel memcg reclaimer might have set some ancestor of
> this memcg to congested.
> 

Why? If ancestor is congested but its child (the one we currently reclaim) is not,
it could mean only 2 things:
 - Either child use mostly anon and inactive file lru is small (file_lru >> priority == 0)
   so it's not congested.
 - Or the child was congested recently (at the time when ancestor scanned this group),
   but not anymore. So the information from ancestor is simply outdated.


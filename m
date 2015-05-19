From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Tue, 19 May 2015 17:12:35 +0200
Message-ID: <555B52E3.3010504@suse.cz>
References: <20150519104057.GC2462@suse.de> <20150519141807.GA9788@cmpxchg.org> <20150519145340.GI6203@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519145340.GI6203@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 05/19/2015 04:53 PM, Michal Hocko wrote:
> On Tue 19-05-15 10:18:07, Johannes Weiner wrote:
>> CC'ing Tejun and cgroups for the generic cgroup interface part
>>
>> On Tue, May 19, 2015 at 11:40:57AM +0100, Mel Gorman wrote:
> [...]
>>> /usr/src/linux-4.0-vanilla/mm/memcontrol.c                           6.6441   395842
>>>    mem_cgroup_try_charge                                                        2.950%   175781
>>
>> Ouch.  Do you have a way to get the per-instruction breakdown of this?
>> This function really isn't doing much.  I'll try to reproduce it here
>> too, I haven't seen such high costs with pft in the past.
>>
>>>    try_charge                                                                   0.150%     8928
>>>    get_mem_cgroup_from_mm                                                       0.121%     7184
>
> Indeed! try_charge + get_mem_cgroup_from_mm which I would expect to be
> the biggest consumers here are below 10% of the mem_cgroup_try_charge.

Note that they don't explain 10% of the mem_cgroup_try_charge. They 
*add* their own overhead to the overhead of mem_cgroup_try_charge 
itself. Which might be what you meant but I wasn't sure.

> Other than that the function doesn't do much else than some flags
> queries and css_put...
>
> Do you have the full trace?
> Sorry for a stupid question but do inlines
> from other header files get accounted to memcontrol.c?

Yes, perf doesn't know about them so it's accounted to function where 
the code physically is.

>
> [...]
>

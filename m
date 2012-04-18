From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/7] memcg: move charge to parent only when necessary.
Date: Wed, 18 Apr 2012 16:01:11 +0900
Message-ID: <4F8E66B7.3050602@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BAB0.5030809@jp.fujitsu.com> <20120416222119.GC12421@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120416222119.GC12421-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/17 7:21), Tejun Heo wrote:

> On Thu, Apr 12, 2012 at 08:21:20PM +0900, KAMEZAWA Hiroyuki wrote:
>>
>> When memcg->use_hierarchy==true, the parent res_counter includes
>> the usage in child's usage. So, it's not necessary to call try_charge()
>> in the parent.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>>  mm/memcontrol.c |   39 ++++++++++++++++++++++++++++++++-------
>>  1 files changed, 32 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index fa01106..3215880 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2409,6 +2409,20 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>>  			res_counter_uncharge(&memcg->memsw, bytes);
>>  	}
>>  }
> 
> New line missing here.
> 
>> +/*
>> + * Moving usage between a child to its parent if use_hierarchy==true.
>> + */
> 
> Prolly "from a child to its parent"?
> 

Sure. will fix.

Thanks,
-Kame

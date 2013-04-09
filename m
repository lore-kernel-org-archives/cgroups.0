From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] memcg: convert to use cgroup_from_id()
Date: Tue, 9 Apr 2013 11:00:51 +0800
Message-ID: <51638463.70009@huawei.com>
References: <51627DA9.7020507@huawei.com> <51627E09.5010605@huawei.com> <20130408145333.GL17178@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130408145333.GL17178-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2013/4/8 22:53, Michal Hocko wrote:
> On Mon 08-04-13 16:21:29, Li Zefan wrote:
>> This is a preparation to kill css_id.
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> I would be tempted to stuff this into the same patch which introduces
> cgroup_from_id but this is just a minor thing.
> 

yeah it's not a big deal, just want to separate changes to cgroup and memcg.

> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
>> ---
>>  mm/memcontrol.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 14f1375..3561d0b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2769,15 +2769,15 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
>>   */
>>  static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
>>  {
>> -	struct cgroup_subsys_state *css;
>> +	struct cgroup *cgrp;
>>  
>>  	/* ID 0 is unused ID */
>>  	if (!id)
>>  		return NULL;
>> -	css = css_lookup(&mem_cgroup_subsys, id);
>> -	if (!css)
>> +	cgrp = cgroup_from_id(&mem_cgroup_subsys, id);
>> +	if (!cgrp)
>>  		return NULL;
>> -	return mem_cgroup_from_css(css);
>> +	return mem_cgroup_from_cont(cgrp);
>>  }
>>  
>>  struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
>> -- 
>> 1.8.0.2

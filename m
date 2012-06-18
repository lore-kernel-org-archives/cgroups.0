From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 19/25] memcg: disable kmem code when not in use.
Date: Mon, 18 Jun 2012 16:26:49 +0400
Message-ID: <4FDF1E89.2020007@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-20-git-send-email-glommer@parallels.com> <4FDF1D76.4060406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDF1D76.4060406-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>>
>>    static void drain_all_stock_async(struct mem_cgroup *memcg);
>> @@ -4344,8 +4358,13 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
>>    			 *
>>    			 * But it is not worth the trouble
>>    			 */
>> -			if (!memcg->kmem_accounted&&  val != RESOURCE_MAX)
>> +			mutex_lock(&set_limit_mutex);
>> +			if (!memcg->kmem_accounted&&  val != RESOURCE_MAX
>> +			&&  !memcg->kmem_accounted) {
> 
> I'm sorry why you check the value twice ?
> 

Hi Kame,

For no reason, it should be removed. I never noticed this because 1)
This is the kind of thing testing will never reveal, and 2), this
actually goes away in a later patch (memcg: propagate kmem limiting
information to children)

In any case, I will update my tree here.

Thanks for spotting this

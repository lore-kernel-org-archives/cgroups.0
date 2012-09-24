From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
Date: Mon, 24 Sep 2012 12:12:23 +0400
Message-ID: <506015E7.8030900@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120921181458.GG7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/21/2012 10:14 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Tue, Sep 18, 2012 at 06:11:59PM +0400, Glauber Costa wrote:
>> +void memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *cachep)
>> +{
>> +	int id = -1;
>> +
>> +	if (!memcg)
>> +		id = ida_simple_get(&cache_types, 0, MAX_KMEM_CACHE_TYPES,
>> +				    GFP_KERNEL);
>> +	cachep->memcg_params.id = id;
>> +}
> 
> I'm a bit confused.  Why is id allocated only when memcg is NULL?
> 

I think you figured that out already from your answer in another patch,
right? But I'll add a comment here since it seems to be a a natural
search point for people, explaining the mechanism.

> Also, how would the per-memcg slab/slubs appear in slabinfo?  If they
> appear separately it might be better to give them readable cgroup
> names.
>

The new caches will appear under /proc/slabinfo with the rest, with a
string appended that identifies the group.

> Thanks.
> 

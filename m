From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Fri, 5 Apr 2013 14:28:12 +0400
Message-ID: <515EA73C.8050602@parallels.com>
References: <515BF233.6070308@huawei.com> <515BF275.5080408@huawei.com> <20130403153133.GM16471@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130403153133.GM16471-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 04/03/2013 07:31 PM, Michal Hocko wrote:
> On Wed 03-04-13 17:12:21, Li Zefan wrote:
>> Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 43ca91d..dafacb8 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3191,7 +3191,7 @@ void memcg_release_cache(struct kmem_cache *s)
>>  	list_del(&s->memcg_params->list);
>>  	mutex_unlock(&memcg->slab_caches_mutex);
>>  
>> -	mem_cgroup_put(memcg);
>> +	css_put(&memcg->css);
>>  out:
>>  	kfree(s->memcg_params);
>>  }
>> @@ -3350,16 +3350,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>>  
>>  	mutex_lock(&memcg_cache_mutex);
>>  	new_cachep = cachep->memcg_params->memcg_caches[idx];
>> -	if (new_cachep)
>> +	if (new_cachep) {
>> +		css_put(&memcg->css);
>>  		goto out;
>> +	}
>>  
>>  	new_cachep = kmem_cache_dup(memcg, cachep);
>>  	if (new_cachep == NULL) {
>>  		new_cachep = cachep;
>> +		css_put(&memcg->css);
>>  		goto out;
>>  	}
>>  
>> -	mem_cgroup_get(memcg);
>>  	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
>>  
>>  	cachep->memcg_params->memcg_caches[idx] = new_cachep;
>> @@ -3449,8 +3451,6 @@ static void memcg_create_cache_work_func(struct work_struct *w)
>>  
>>  	cw = container_of(w, struct create_work, work);
>>  	memcg_create_kmem_cache(cw->memcg, cw->cachep);
>> -	/* Drop the reference gotten when we enqueued. */
>> -	css_put(&cw->memcg->css);
>>  	kfree(cw);
>>  }
> 
> You are putting references but I do not see any single css_{try}get
> here. /me puzzled.
> 

There are two things being done in this code:
First, we acquired a css_ref to make sure that the underlying cgroup
would not go away. That is a short lived reference, and it is put as
soon as the cache is created.
At this point, we acquire a long-lived per-cache memcg reference count
to guarantee that the memcg will still be alive.

so it is:

enqueue: css_get
create : memcg_get, css_put
destroy: css_put

If I understand Li's patch correctly, he is not touching the first
css_get, only turning that into the long lived reference (which was not
possible before, since that would prevent rmdir).

Then he only needs to get rid of the memcg_get, change the memcg_put to
css_put, and get rid of the now extra css_put.

He is issuing extra css_puts in memcg_create_kmem_cache, but only in
failure paths. So the code reads as:
* css_get on enqueue (already done, so not shown in patch)
* if it fails, css_put
* if it succeeds, don't do anything. This is already the long-lived
reference count. put it at release time.

The code looks correct, and of course, extremely simpler due to the
use of a single reference.

Li, am I right in my understanding that this is your intention?

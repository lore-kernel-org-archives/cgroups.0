From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Fri, 5 Apr 2013 15:46:35 +0200
Message-ID: <20130405134635.GH31132@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF275.5080408@huawei.com>
 <515E664E.5060005@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <515E664E.5060005@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>

On Fri 05-04-13 14:51:10, KAMEZAWA Hiroyuki wrote:
> (2013/04/03 18:12), Li Zefan wrote:
> > Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > ---
> >   mm/memcontrol.c | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 43ca91d..dafacb8 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3191,7 +3191,7 @@ void memcg_release_cache(struct kmem_cache *s)
> >   	list_del(&s->memcg_params->list);
> >   	mutex_unlock(&memcg->slab_caches_mutex);
> >   
> > -	mem_cgroup_put(memcg);
> > +	css_put(&memcg->css);
> >   out:
> >   	kfree(s->memcg_params);
> >   }
> > @@ -3350,16 +3350,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >   
> >   	mutex_lock(&memcg_cache_mutex);
> >   	new_cachep = cachep->memcg_params->memcg_caches[idx];
> > -	if (new_cachep)
> > +	if (new_cachep) {
> > +		css_put(&memcg->css);
> >   		goto out;
> > +	}
> 
> Where css_get() against this is done ?

As glauber explained in another email in this thread. It was
__memcg_create_cache_enqueue which took the reference.
-- 
Michal Hocko
SUSE Labs

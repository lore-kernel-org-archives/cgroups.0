From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 6/6] memcg, slab: RCU protect memcg_params for root caches
Date: Thu, 19 Dec 2013 10:43:33 +0100
Message-ID: <20131219094333.GB10855@dhcp22.suse.cz>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
 <be8f2fede0fbc45496c06f7bc6cc2272b9b81cc4.1387372122.git.vdavydov@parallels.com>
 <20131219092836.GH9331@dhcp22.suse.cz>
 <52B2BE2A.2080509@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52B2BE2A.2080509-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu 19-12-13 13:36:42, Vladimir Davydov wrote:
> On 12/19/2013 01:28 PM, Michal Hocko wrote:
> > On Wed 18-12-13 17:16:57, Vladimir Davydov wrote:
[...]
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 1d8b53f..53b81a9 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -164,10 +164,16 @@ static inline struct kmem_cache *
> >>  cache_from_memcg_idx(struct kmem_cache *s, int idx)
> >>  {
> >>  	struct kmem_cache *cachep;
> >> +	struct memcg_cache_params *params;
> >>  
> >>  	if (!s->memcg_params)
> >>  		return NULL;
> >> -	cachep = s->memcg_params->memcg_caches[idx];
> >> +
> >> +	rcu_read_lock();
> >> +	params = rcu_dereference(s->memcg_params);
> >> +	cachep = params->memcg_caches[idx];
> >> +	rcu_read_unlock();
> >> +
> > Consumer has to be covered by the same rcu section otherwise
> > memcg_params might be freed right after rcu unlock here.
> 
> No. We protect only accesses to kmem_cache::memcg_params, which can
> potentially be relocated for root caches.

Hmm, ok. So memcg_params might change (a new memcg is accounted) but
pointers at idx will be same, right?

> But as soon as we get the
> pointer to a kmem_cache from this array, we can freely dereference it,
> because the cache cannot be freed when we use it. This is, because we
> access a kmem_cache either under the slab_mutex or
> memcg->slab_caches_mutex, or when we allocate/free from it. While doing
> the latter, the cache can't go away, it would be a bug. IMO.

That expects that cache_from_memcg_idx is always called with slab_mutex
or slab_caches_mutex held, right? Please document it.

> 
> Thanks.

-- 
Michal Hocko
SUSE Labs

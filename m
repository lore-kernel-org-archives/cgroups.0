From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm] slab: use cgroup ino for naming per memcg caches
Date: Wed, 8 Apr 2015 12:54:04 +0300
Message-ID: <20150408095404.GC10286@esperanza>
References: <1428414798-12932-1-git-send-email-vdavydov@parallels.com>
 <20150407133819.993be7a53a3aa16311aba1f5@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150407133819.993be7a53a3aa16311aba1f5-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 07, 2015 at 01:38:19PM -0700, Andrew Morton wrote:
> On Tue, 7 Apr 2015 16:53:18 +0300 Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > The name of a per memcg kmem cache consists of three parts: the global
> > kmem cache name, the cgroup name, and the css id. The latter is used to
> > guarantee cache name uniqueness.
> > 
> > Since css ids are opaque to the userspace, in general it is impossible
> > to find a cache's owner cgroup given its name: there might be several
> > same-named cgroups with different parents so that their caches' names
> > will only differ by css id. Looking up the owner cgroup by a cache name,
> > however, could be useful for debugging. For instance, the cache name is
> > dumped to dmesg on a slab allocation failure. Another example is
> > /sys/kernel/slab, which exports some extra info/tunables for SLUB caches
> 
> /proc/sys/kernel/slab?

No, /sys/kernel/slab/. There is a directory with tunables for each
global cache there (only for SLUB). If CONFIG_MEMCG_KMEM is on, there is
also /sys/kernel/slab/<slab-name>/cgroup/, which contains directories
with tunables for each per memcg cache.

> 
> > referring to them by name.
> > 
> > This patch substitutes the css id with cgroup inode number, which, just
> > like css id, is reserved until css free, so that the cache names are
> > still guaranteed to be unique, but, in contrast to css id, it can be
> > easily obtained from userspace.
> > 
> > ...
> >
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -478,7 +478,7 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >  			     struct kmem_cache *root_cache)
> >  {
> >  	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
> > -	struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
> > +	struct cgroup *cgroup;
> >  	struct memcg_cache_array *arr;
> >  	struct kmem_cache *s = NULL;
> >  	char *cache_name;
> > @@ -508,9 +508,10 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >  	if (arr->entries[idx])
> >  		goto out_unlock;
> >  
> > -	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
> > -	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
> > -			       css->id, memcg_name_buf);
> > +	cgroup = mem_cgroup_css(memcg)->cgroup;
> > +	cgroup_name(cgroup, memcg_name_buf, sizeof(memcg_name_buf));
> > +	cache_name = kasprintf(GFP_KERNEL, "%s(%lu:%s)", root_cache->name,
> > +			(unsigned long)cgroup_ino(cgroup), memcg_name_buf);
> >  	if (!cache_name)
> >  		goto out_unlock;
> 
> Is this interface documented anywhere?
> 

No. Although the /sys/kernel/slab/ tunables are documented in
Documentation/ABI/testing/sysfs-kernel-slab and the /sys/kernel/slab/
directory is mentioned in Documentation/vm/slub.txt, neither of these
files refer to the interface for per memcg caches. I can document it if
necessary.

Come to think of it, was it really a good idea to group per memcg caches
under /sys/kernel/slab/<slab-name>/cgroup/ instead of keeping them all
in /sys/kernel/slab/? I introduced this cgroup/ directory to clean up
/sys/kernel/<slab-name>/ (9a41707bd3a08), which had looked too crowded
when there had been a lot of active memory cgroups. Unfortunately,
nobody commented on that patch at that time. Frankly, today I am not
that sure it was the right thing to do :-(

E.g.

/sys/kernel/slab/<slab-name>/objects (counts allocated objects)

does NOT include

/sys/kernel/slab/<slab-name>/cgroup/*/objects

which looks dubious to me, because this cgroup/ dir implies a
hierarchical structure, while in fact it does not act like that.

Another unpleasant thing about this cgroup/ dir is that it reveals the
internal implementation of memcg/kmem: it shows that each memory cgroup
has its own copy of kmem cache. What if we decide to share the same kmem
cache among all memory cgroups one day? Of course, this will hardly ever
happen, but it is an alternative approach to implementing the same
feature, which makes this cgroup/ dir pointless. If we had all caches
under /sys/kernel/slab, it would not be a problem: the dirs
corresponding to per memcg caches would disappear then, but it would not
break userspace, which would have to treat per memcg caches just like
global ones - e.g. the slabinfo utility would just show less caches,
while if it supported the cgroup/ dir (which it currently does not), it
would require reworking.

Provided that this cgroup/ dir has never been documented and it is only
added if CONFIG_MEMCG_KMEM, which had been marked as UNDER DEVELOPMENT
until recently, is on, can we probably revert it?

Thanks,
Vladimir

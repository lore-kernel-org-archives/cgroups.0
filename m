From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 5/9] memcg: use css_get/put when charging/uncharging kmem
Date: Fri, 24 May 2013 09:54:20 +0200
Message-ID: <20130524075420.GA24813@dhcp22.suse.cz>
References: <5195D5F8.7000609@huawei.com>
 <5195D666.6030408@huawei.com>
 <20130517180822.GC12632@mtj.dyndns.org>
 <519C838B.9060609@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <519C838B.9060609-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Sorry, I have missed this. CCing would help. Anyway putting myself to CC
now :P

On Wed 22-05-13 16:36:27, Li Zefan wrote:
> On 2013/5/18 2:08, Tejun Heo wrote:
> > Hey,
> > 
> > On Fri, May 17, 2013 at 03:04:06PM +0800, Li Zefan wrote:
> >> +	/*
> >> +	 * Releases a reference taken in kmem_cgroup_css_offline in case
> >> +	 * this last uncharge is racing with the offlining code or it is
> >> +	 * outliving the memcg existence.
> >> +	 *
> >> +	 * The memory barrier imposed by test&clear is paired with the
> >> +	 * explicit one in kmem_cgroup_css_offline.
> > 
> > Paired with the wmb to achieve what?

https://lkml.org/lkml/2013/4/4/190
"
! > +	css_get(&memcg->css);
! I think that you need a write memory barrier here because css_get
! nor memcg_kmem_mark_dead implies it. memcg_uncharge_kmem uses
! memcg_kmem_test_and_clear_dead which imply a full memory barrier but it
! should see the elevated reference count. No?
! 
! > +	/*
! > +	 * We need to call css_get() first, because memcg_uncharge_kmem()
! > +	 * will call css_put() if it sees the memcg is dead.
! > +	 */
! >  	memcg_kmem_mark_dead(memcg);
"

Does it make sense to you Tejun?

> > 
> >> +	 */
> >>  	if (memcg_kmem_test_and_clear_dead(memcg))
> >> -		mem_cgroup_put(memcg);
> >> +		css_put(&memcg->css);
> > 
> > The other side is wmb, so there gotta be something which wants to read
> > which were written before wmb here but the only thing after the
> > barrier is css_put() which doesn't need such thing, so I'm lost on
> > what the barrier pair is achieving here.

> > 
> > In general, please be *very* explicit about what's going on whenever
> > something is depending on barrier pairs.  It'll make it easier for
> > both the author and reviewers to actually understand what's going on
> > and why it's necessary.
> > 
> > ...
> >> @@ -5858,23 +5856,39 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
> >>  	return mem_cgroup_sockets_init(memcg, ss);
> >>  }
> >>  
> >> -static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
> >> +static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
> >>  {
> >> -	mem_cgroup_sockets_destroy(memcg);
> >> +	if (!memcg_kmem_is_active(memcg))
> >> +		return;
> >>  
> >> +	/*
> >> +	 * kmem charges can outlive the cgroup. In the case of slab
> >> +	 * pages, for instance, a page contain objects from various
> >> +	 * processes. As we prevent from taking a reference for every
> >> +	 * such allocation we have to be careful when doing uncharge
> >> +	 * (see memcg_uncharge_kmem) and here during offlining.
> >> +	 *
> >> +	 * The idea is that that only the _last_ uncharge which sees
> >> +	 * the dead memcg will drop the last reference. An additional
> >> +	 * reference is taken here before the group is marked dead
> >> +	 * which is then paired with css_put during uncharge resp. here.
> >> +	 *
> >> +	 * Although this might sound strange as this path is called when
> >> +	 * the reference has already dropped down to 0 and shouldn't be
> >> +	 * incremented anymore (css_tryget would fail) we do not have
> > 
> > Hmmm?  offline is called on cgroup destruction regardless of css
> > refcnt.  The above comment seems a bit misleading.
> > 
> 
> The comment is wrong. I'll fix it.

Ohh, right. "Althouth this might sound strange as this path is called from
css_offline when the reference might have dropped down to 0 and shouldn't ..."

Sounds better?
 
> >> +	 * other options because of the kmem allocations lifetime.
> >> +	 */
> >> +	css_get(&memcg->css);
> >> +
> >> +	/* see comment in memcg_uncharge_kmem() */
> >> +	wmb();
> >>  	memcg_kmem_mark_dead(memcg);
> > 
> > Is the wmb() trying to prevent reordering between css_get() and
> > memcg_kmem_mark_dead()?  If so, it isn't necessary - the compiler
> > isn't allowed to reorder two atomic ops (they're all asm volatiles)
> > and the visibility order is guaranteed by the nature of the two
> > operations going on here - both perform modify-and-test on one end of
> > the operations.

As I have copied my comment from the earlier thread above.
css_get does atomic_add which doesn't imply any barrier AFAIK and
memcg_kmem_mark_dead uses a simple set_bit which doesn't imply it
either. What am I missing?

> > 
> 
> Yeah, I think you're right.
> 
> > It could be argued that having memory barriers is better for
> > completeness of mark/test interface but then those barriers should
> > really moved into memcg_kmem_mark_dead() and its clearing counterpart.
> > 
> > While it's all clever and dandy, my recommendation would be just using
> > a lock for synchronization.  It isn't a hot path.  Why be clever?
> > 
> 
> I don't quite like adding a lock not to protect data but just ensure code
> orders.

Agreed.

> Michal, what's your preference? I want to be sure that everyone is happy
> so the next version will hopefully be the last version.

I still do not see why the barrier is not needed and the lock seems too
big hammer.

-- 
Michal Hocko
SUSE Labs

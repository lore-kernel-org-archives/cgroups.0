From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm/memcg: Introduce
 obj_cgroup_uncharge_mod_state()
Date: Thu, 15 Apr 2021 16:19:13 -0400
Message-ID: <YHifwQ+Rjdnghgm7@cmpxchg.org>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-3-longman@redhat.com>
 <YHhqPYcajI9JgXk/@cmpxchg.org>
 <1c85e8f6-e8b9-33e1-e29b-81fbadff959f@redhat.com>
 <YHiBlhUWoCKqQgM7@cmpxchg.org>
 <8a104fd5-64c7-3f41-981c-9cfa977c78a6@redhat.com>
 <YHiWmsQVQPGSm2El@cmpxchg.org>
 <cba964b6-d2b6-9a74-f556-e2733b65dd81@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hD3bQIY2ucYvZVOUSWo6vopC1VOcxVsnFm0zvmFOg+E=;
        b=ncE49eeSu4d9JPAV9lE+/q2xl8LS+vgcjxBrrC1YbpgbOEdDASvGHJSbLbPwFvkpVd
         G3FDAN50vmifSNPyI/+iFoCnMeJuHzWS9JePPFYvKAncH1z/O1/khvTw2ESGPrEVx/EX
         Ml8HScotQVh5QAaoX1NaKvt/TdkCYlK/uKcva06UWtHgDWwstlIDYXclXcrPiUbL9QJ2
         fu7+7zlr+hxzXe6hq6LC5vTCg9H5b/3dHncRSN9i7CBH2gZXaewKzpSS0g3SYZCvvlBh
         uDp0AeuH+jAUDLoCanhLTeoi4x8WzLnDdkSU3xfu41oXZPBPNF+wWndl1QWgWuiaCEeO
         9jAg==
Content-Disposition: inline
In-Reply-To: <cba964b6-d2b6-9a74-f556-e2733b65dd81-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Thu, Apr 15, 2021 at 03:44:56PM -0400, Waiman Long wrote:
> On 4/15/21 3:40 PM, Johannes Weiner wrote:
> > On Thu, Apr 15, 2021 at 02:47:31PM -0400, Waiman Long wrote:
> > > On 4/15/21 2:10 PM, Johannes Weiner wrote:
> > > > On Thu, Apr 15, 2021 at 12:35:45PM -0400, Waiman Long wrote:
> > > > > On 4/15/21 12:30 PM, Johannes Weiner wrote:
> > > > > > On Tue, Apr 13, 2021 at 09:20:24PM -0400, Waiman Long wrote:
> > > > > > > In memcg_slab_free_hook()/pcpu_memcg_free_hook(), obj_cgroup_uncharge()
> > > > > > > is followed by mod_objcg_state()/mod_memcg_state(). Each of these
> > > > > > > function call goes through a separate irq_save/irq_restore cycle. That
> > > > > > > is inefficient.  Introduce a new function obj_cgroup_uncharge_mod_state()
> > > > > > > that combines them with a single irq_save/irq_restore cycle.
> > > > > > > 
> > > > > > > @@ -3292,6 +3296,25 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
> > > > > > >     	refill_obj_stock(objcg, size);
> > > > > > >     }
> > > > > > > +void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
> > > > > > > +				   struct pglist_data *pgdat, int idx)
> > > > > > The optimization makes sense.
> > > > > > 
> > > > > > But please don't combine independent operations like this into a
> > > > > > single function. It makes for an unclear parameter list, it's a pain
> > > > > > in the behind to change the constituent operations later on, and it
> > > > > > has a habit of attracting more random bools over time. E.g. what if
> > > > > > the caller already has irqs disabled? What if it KNOWS that irqs are
> > > > > > enabled and it could use local_irq_disable() instead of save?
> > > > > > 
> > > > > > Just provide an __obj_cgroup_uncharge() that assumes irqs are
> > > > > > disabled, combine with the existing __mod_memcg_lruvec_state(), and
> > > > > > bubble the irq handling up to those callsites which know better.
> > > > > > 
> > > > > That will also work. However, the reason I did that was because of patch 5
> > > > > in the series. I could put the get_obj_stock() and put_obj_stock() code in
> > > > > slab.h and allowed them to be used directly in various places, but hiding in
> > > > > one function is easier.
> > > > Yeah it's more obvious after getting to patch 5.
> > > > 
> > > > But with the irq disabling gone entirely, is there still an incentive
> > > > to combine the atomic section at all? Disabling preemption is pretty
> > > > cheap, so it wouldn't matter to just do it twice.
> > > > 
> > > > I.e. couldn't the final sequence in slab code simply be
> > > > 
> > > > 	objcg_uncharge()
> > > > 	mod_objcg_state()
> > > > 
> > > > again and each function disables preemption (and in the rare case
> > > > irqs) as it sees fit?
> > > > 
> > > > You lose the irqsoff batching in the cold path, but as you say, hit
> > > > rates are pretty good, and it doesn't seem worth complicating the code
> > > > for the cold path.
> > > > 
> > > That does make sense, though a little bit of performance may be lost. I will
> > > try that out to see how it work out performance wise.
> > Thanks.
> > 
> > Even if we still end up doing it, it's great to have that cost
> > isolated, so we know how much extra code complexity corresponds to how
> > much performance gain. It seems the task/irq split could otherwise be
> > a pretty localized change with no API implications.
> > 
> I still want to move mod_objcg_state() function to memcontrol.c though as I
> don't want to put any obj_stock stuff in mm/slab.h.

No objection from me!

That's actually a nice cleanup, IMO. Not sure why it was separated
from the rest of the objcg interface implementation to begin with.

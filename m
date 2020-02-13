From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 08:40:49 +0100
Message-ID: <20200213074049.GA31689@dhcp22.suse.cz>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200212170826.GC180867-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 12-02-20 12:08:26, Johannes Weiner wrote:
> On Tue, Feb 11, 2020 at 05:47:53PM +0100, Michal Hocko wrote:
> > Unless I am missing something then I am afraid it doesn't. Say you have a
> > default systemd cgroup deployment (aka deeper cgroup hierarchy with
> > slices and scopes) and now you want to grant a reclaim protection on a
> > leaf cgroup (or even a whole slice that is not really important). All the
> > hierarchy up the tree has the protection set to 0 by default, right? You
> > simply cannot get that protection. You would need to configure the
> > protection up the hierarchy and that is really cumbersome.
> 
> Okay, I think I know what you mean. Let's say you have a tree like
> this:
> 
>                           A
>                          / \
>                         B1  B2
>                        / \   \
>                       C1 C2   C3
> 
> and there is no actual delegation point - everything belongs to the
> same user / trust domain. C1 sets memory.low to 10G, but its parents
> set nothing. You're saying we should honor the 10G protection during
> global and limit reclaims anywhere in the tree?

No, only in the C1 which sets the limit, because that is the woriking
set we want to protect.

> Now let's consider there is a delegation point at B1: we set up and
> trust B1, but not its children. What effect would the C1 protection
> have then? Would we ignore it during global and A reclaim, but honor
> it when there is B1 limit reclaim?

In the scheme with the inherited protection it would act as the gate
and require an explicit low limit setup defaulting to 0 if none is
specified.

> Doing an explicit downward propagation from the root to C1 *could* be
> tedious, but I can't think of a scenario where it's completely
> impossible. Especially because we allow proportional distribution when
> the limit is overcommitted and you don't have to be 100% accurate.

So let's see how that works in practice, say a multi workload setup
with a complex/deep cgroup hierachies (e.g. your above example). No
delegation point this time.

C1 asks for low=1G while using 500M, C3 low=100M using 80M.  B1 and
B2 are completely independent workloads and the same applies to C2 which
doesn't ask for any protection at all? C2 uses 100M. Now the admin has
to propagate protection upwards so B1 low=1G, B2 low=100M and A low=1G,
right? Let's say we have a global reclaim due to external pressure that
originates from outside of A hierarchy (it is not overcommited on the
protection).

Unless I miss something C2 would get a protection even though nobody
asked for it.

> And the clarity that comes with being explicit is an asset too,
> IMO. Since it has an effect at the reclaim level, it's not a bad thing
> to have that effect *visible* in the settings at that level as well:
> the protected memory doesn't come out of thin air, it's delegated down
> from the top where memory pressure originates.

So how are we going to deal with hierarchies where the actual workload
of interest is a leaf deeper in the hierarchy and the upper levels of
the hierarchy are shared between unrelated workloads?  Look at how
systemd organizes system into cgroups for example (slices vs. scopes)
and say you want to add a protection to a single user or a service.
 
> My patch is different. It allows a configuration that simply isn't
> possible today: protecting C1 and C2 from C3, without having to
> protect C1 and C2 from each other.
> 
> So I don't think requiring an uninterrupted, authorized chain of
> protection from the top is necessarily wrong. In fact, I think it has
> benefits. But requiring the protection chain to go all the way to the
> leaves for it to have any effect, that is a real problem, and it can't
> be worked around.

Yes I do agree that the problem you are dealing with is slightly
different. My main point was that you are already introducing a new
semantic which is not fully backward compatible and I figured we have
more problems in the area and maybe we can introduce a semantic to
handle both above mentioned scenarios while doing that.
-- 
Michal Hocko
SUSE Labs

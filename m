From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 14 Feb 2020 08:59:16 +0100
Message-ID: <20200214075916.GM31689@dhcp22.suse.cz>
References: <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213132317.GA208501@cmpxchg.org>
 <20200213154627.GD31689@dhcp22.suse.cz>
 <20200213174135.GC208501@cmpxchg.org>
 <20200213175813.GA216470@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200213175813.GA216470-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 13-02-20 12:58:13, Johannes Weiner wrote:
> On Thu, Feb 13, 2020 at 12:41:36PM -0500, Johannes Weiner wrote:
> > On Thu, Feb 13, 2020 at 04:46:27PM +0100, Michal Hocko wrote:
> > > On Thu 13-02-20 08:23:17, Johannes Weiner wrote:
> > > > On Thu, Feb 13, 2020 at 08:40:49AM +0100, Michal Hocko wrote:
> > > > > On Wed 12-02-20 12:08:26, Johannes Weiner wrote:
> > > > > > On Tue, Feb 11, 2020 at 05:47:53PM +0100, Michal Hocko wrote:
> > > > > > > Unless I am missing something then I am afraid it doesn't. Say you have a
> > > > > > > default systemd cgroup deployment (aka deeper cgroup hierarchy with
> > > > > > > slices and scopes) and now you want to grant a reclaim protection on a
> > > > > > > leaf cgroup (or even a whole slice that is not really important). All the
> > > > > > > hierarchy up the tree has the protection set to 0 by default, right? You
> > > > > > > simply cannot get that protection. You would need to configure the
> > > > > > > protection up the hierarchy and that is really cumbersome.
> > > > > > 
> > > > > > Okay, I think I know what you mean. Let's say you have a tree like
> > > > > > this:
> > > > > > 
> > > > > >                           A
> > > > > >                          / \
> > > > > >                         B1  B2
> > > > > >                        / \   \
> > > > > >                       C1 C2   C3
> 
> > > > > So let's see how that works in practice, say a multi workload setup
> > > > > with a complex/deep cgroup hierachies (e.g. your above example). No
> > > > > delegation point this time.
> > > > > 
> > > > > C1 asks for low=1G while using 500M, C3 low=100M using 80M.  B1 and
> > > > > B2 are completely independent workloads and the same applies to C2 which
> > > > > doesn't ask for any protection at all? C2 uses 100M. Now the admin has
> > > > > to propagate protection upwards so B1 low=1G, B2 low=100M and A low=1G,
> > > > > right? Let's say we have a global reclaim due to external pressure that
> > > > > originates from outside of A hierarchy (it is not overcommited on the
> > > > > protection).
> > > > > 
> > > > > Unless I miss something C2 would get a protection even though nobody
> > > > > asked for it.
> > > > 
> > > > Good observation, but I think you spotted an unintentional side effect
> > > > of how I implemented the "floating protection" calculation rather than
> > > > a design problem.
> > > > 
> > > > My patch still allows explicit downward propagation. So if B1 sets up
> > > > 1G, and C1 explicitly claims those 1G (low>=1G, usage>=1G), C2 does
> > > > NOT get any protection. There is no "floating" protection left in B1
> > > > that could get to C2.
> > > 
> > > Yeah, the saturated protection works reasonably AFAICS.
> > 
> > Hm, Tejun raises a good point though: even if you could direct memory
> > protection down to one targeted leaf, you can't do the same with IO or
> > CPU. Those follow non-conserving weight distribution, and whatever you
> 
>                     "work-conserving", obviously.
> 
> > allocate to a certain level is available at that level - if one child
> > doesn't consume it, the other children can.

Right, but isn't this pretty much a definition of weight based resource
distribution? Memory knobs operate in absolute numbers (limits) and that
means that children might both over/under commit what parent assigns to
them. Or have I misunderstood you here?

> > And we know that controlling memory without controlling IO doesn't
> > really work in practice. The sibling with less memory allowance will
> > just page more.
> > 
> > So the question becomes: is this even a legit usecase? If every other
> > resource is distributed on a level-by-level method already, does it
> > buy us anything to make memory work differently?

Aren't you mixing weights and limits here? I am quite confused TBH.

Let me give you an example. Say you have a DB workload which is the
primary thing running on your system and which you want to protect from
an unrelated activity (backups, frontends, etc). Running it inside a
cgroup with memory.low while other components in other cgroups without
any protection achieves that. If those cgroups are top level then this
is simple and straightforward configuration.

Things would get much more tricky if you want run the same workload
deeper down the hierarchy - e.g. run it in a container. Now your
"root" has to use an explicit low protection as well and all other
potential cgroups that are in the same sub-hierarchy (read in the same
container) need to opt-out from the protection because they are not
meant to be protected.

In short we simply have to live with usecases where the cgroup hierarchy
follows the "logical" workload organization at the higher level more
than resource control. This is the case for systemd as well btw.
Workloads are organized into slices and scopes without any direct
relation to resources in mind.

Does this make it more clear what I am thinking about? Does it sound
like a legit usecase?
-- 
Michal Hocko
SUSE Labs

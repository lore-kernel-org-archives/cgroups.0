From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Wed, 29 Apr 2020 10:27:07 -0400
Message-ID: <20200429142707.GC5054@cmpxchg.org>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
 <20200429140330.GA5054@cmpxchg.org>
 <CALOAHbCC-oT+CwzyokNfomEMf0GdzpipBeZJjnnE8RrPPZ_Maw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aWtaTTSNTzK+8VtJHmNxXi4ve7kZo3n6KV5SYDQbS9I=;
        b=ndIkV6QfmD4PZV4Z0gk7BymE8uvcokLZlAam1EshLYJTdQtA2p0eUPC+Hmx9hBfXvN
         hZ50Ak/UHf9Fra322cv86xXt0zYopr1qPtueLJGLTrAmwLgQLEDW2tpuZp9xuCg3UYeb
         1pRV5GpAbKffqyU5Nb7kexzabW+dXiIZIOaSixhmNuh/LuudbFkn4dDzWbloJuphK4SW
         K7NazNpTDV5jO+391IEE/olFqy3szjBdunZlILubAuzJjMyEnYkCf6SjhVa48kEaHLCy
         CZeLpzlFOuGPaybdZhd0YNmq43ykaEt7GiZJbsLKyAVQpCusw266ZIQntmf9f7oBI4a0
         dg1w==
Content-Disposition: inline
In-Reply-To: <CALOAHbCC-oT+CwzyokNfomEMf0GdzpipBeZJjnnE8RrPPZ_Maw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Apr 29, 2020 at 10:17:21PM +0800, Yafang Shao wrote:
> On Wed, Apr 29, 2020 at 10:03 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Apr 29, 2020 at 12:15:10PM +0200, Michal Hocko wrote:
> > > On Tue 28-04-20 19:26:47, Chris Down wrote:
> > > > From: Yafang Shao <laoar.shao@gmail.com>
> > > >
> > > > A cgroup can have both memory protection and a memory limit to isolate
> > > > it from its siblings in both directions - for example, to prevent it
> > > > from being shrunk below 2G under high pressure from outside, but also
> > > > from growing beyond 4G under low pressure.
> > > >
> > > > Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > > implemented proportional scan pressure so that multiple siblings in
> > > > excess of their protection settings don't get reclaimed equally but
> > > > instead in accordance to their unprotected portion.
> > > >
> > > > During limit reclaim, this proportionality shouldn't apply of course:
> > > > there is no competition, all pressure is from within the cgroup and
> > > > should be applied as such. Reclaim should operate at full efficiency.
> > > >
> > > > However, mem_cgroup_protected() never expected anybody to look at the
> > > > effective protection values when it indicated that the cgroup is above
> > > > its protection. As a result, a query during limit reclaim may return
> > > > stale protection values that were calculated by a previous reclaim cycle
> > > > in which the cgroup did have siblings.
> > > >
> > > > When this happens, reclaim is unnecessarily hesitant and potentially
> > > > slow to meet the desired limit. In theory this could lead to premature
> > > > OOM kills, although it's not obvious this has occurred in practice.
> > >
> > > Thanks this describes the underlying problem. I would be also explicit
> > > that the issue should be visible only on tail memcgs which have both
> > > max/high and protection configured and the effect depends on the
> > > difference between the two (the smaller it is the largrger the effect).
> > >
> > > There is no mention about the fix. The patch resets effective values for
> > > the reclaim root and I've had some concerns about that
> > > http://lkml.kernel.org/r/20200424162103.GK11591@dhcp22.suse.cz.
> > > Johannes has argued that other races are possible and I didn't get to
> > > think about it thoroughly. But this patch is introducing a new
> > > possibility of breaking protection. If we want to have a quick and
> > > simple fix that would be easier to backport to older kernels then I
> > > would feel much better if we simply workedaround the problem as
> > > suggested earlier http://lkml.kernel.org/r/20200423061629.24185-1-laoar.shao@gmail.com
> > > We can rework the effective values calculation to be more robust against
> > > races on top of that because this is likely a more tricky thing to do.
> >
> > Well, can you please *do* think more thoroughly about what I wrote,
> > instead of pushing for an alternative patch on gut feeling alone?
> >
> > Especially when you imply that this should be a stable patch.
> >
> > Not only does your alternative patch not protect against the race you
> > are worried about, the race itself doesn't matter. Racing reclaimers
> > will write their competing views of the world into the shared state on
> > all other levels anyway.
> >
> > And that's okay. If the configuration and memory usage is such that
> > there is at least one reclaimer that scans without any protection
> > (like a limit reclaimer), it's not a problem when a second reclaimer
> > that meant to do protected global reclaim will also do one iteration
> > without protection. It's no different than if a second thread had
> > entered limit reclaim through another internal allocation.
> >
> > There is no semantical violation with the race in your patch or the
> > race in this patch. Any effective protection that becomes visible is
> > 1) permitted by the configuration, but 2) also triggered *right now*
> > by an acute need to reclaim memory with these parameters.
> >
> > The *right now* part is important. That's what's broken before either
> > patch, and that's what we're fixing: to see really, really *old* stale
> > that might not be representative of the config semantics anymore.
> >
> > Since you haven't linked to my email, here is my counter argument to
> > the alternative patch "fixing" this race somehow.
> >
> > A reclaim:
> >
> >   root
> >      `- A (low=2G, max=3G -> elow=0)
> >         `- A1 (low=0G -> elow=0)
> >
> > Global reclaim:
> >
> >   root
> >      `- A (low=2G, max=3G -> elow=2G)
> >         `- A1 (low=0G -> elow=2G)
> >
> > During global reclaim, A1 is supposed to have 2G effective low
> > protection. If A limit reclaim races, it can set A1's elow to
> > 0.
> 
> Before the commit  8a931f801340c2be ("mm: memcontrol: recursive
> memory.low protection"), the A1's elow should be 0, while after this
> commit A1's elow is 2G.
> That is a behavior change.

Yes, that was an intentional change around the inheritance rules.

And your alternative patch doesn't fix the race you are (wrongly)
worried about under these rules.

What's your point, exactly?

> Then this case gives us another example why accessing emin and elow in
> the very deap reclaiming code (get_scan_count) is the root of ALL
> EVIL.

You must be confusing this software engineering list with a witch
doctor conference.

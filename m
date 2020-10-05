From: Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [PATCH RFC v2] Opportunistic memory reclaim
Date: Mon, 5 Oct 2020 17:39:48 +0200
Message-ID: <20201005153948.GC783944@xps-13-7390>
References: <20201005081313.732745-1-andrea.righi@canonical.com>
 <20201005112555.GA108347@chrisdown.name>
 <20201005135130.GA850459@xps-13-7390>
 <20201005144612.GB108347@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20201005144612.GB108347@chrisdown.name>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Luigi Semenzato <semenzato@google.com>, "Rafael J . Wysocki" <rafael@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org

On Mon, Oct 05, 2020 at 03:46:12PM +0100, Chris Down wrote:
> Andrea Righi writes:
> > senpai is focused at estimating the ideal memory requirements without
> > affecting performance. And this covers the use case about reducing
> > memory footprint.
> > 
> > In my specific use-case (hibernation) I would let the system use as much
> > memory as possible if it's doing any activity (reclaiming memory only
> > when the kernel decides that it needs to reclaim memory) and apply a
> > more aggressive memory reclaiming policy when the system is mostly idle.
> 
> From this description, I don't see any reason why it needs to be implemented
> in kernel space. All of that information is available to userspace, and all
> of the knobs are there.
> 
> As it is I'm afraid of the "only when the system is mostly idle" comment,
> because it's usually after such periods that applications need to do large
> retrievals, and now they're going to be in slowpath (eg. periodic jobs).

True, but with memory.high there's the risk to trash some applications
badly if I'm not reacting fast at increasing memory.high.

However, something that I could definitely want to try is to move all
the memory hogs to a cgroup, set memory.high to a very small value and
then immediately set it back to 'max'. The effect should be pretty much
the same as calling shrink_all_memory(), that is what I'm doing with my
memory.swap.reclaim.

> 
> Such tradeoffs for a specific situation might be fine in userspace as a
> distribution maintainer, but codifying them in the kernel seems premature to
> me, especially for a knob which we will have to maintain forever onwards.
> 
> > I could probably implement this behavior adjusting memory.high
> > dynamically, like senpai, but I'm worried about potential sudden large
> > allocations that may require to respond faster at increasing
> > memory.high. I think the user-space triggered memory reclaim approach is
> > a safer solution from this perspective.
> 
> Have you seen Shakeel's recent "per-memcg reclaim interface" patches? I
> suspect they may help you there.

Yes, Michal pointed out to me his work, it's basically the same approach
that I'm using.

I started this work with a patch that was hibernation specific
(https://lore.kernel.org/lkml/20200601160636.148346-1-andrea.righi@canonical.com/);
this v2 was the natural evolution of my previous work and I didn't
notice that something similar has been posted in the meantime.

Anyway, I already contacted Shakeel, so we won't duplicate the efforts
in the future. :)

Thanks for your feedback!
-Andrea

From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Wed, 29 Apr 2020 18:53:03 +0800
Message-ID: <CALOAHbAosoU=+iPgD+TeU_iDXTV7W_WcFdKCi2fdwwyvutG2zQ@mail.gmail.com>
References: <cover.1588092152.git.chris@chrisdown.name> <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O+RxET0x+5VztvWmaNq+4wuYITGQNc1qhSl70TM00l4=;
        b=dOc7FDNQvz5BsTcW0cOnufOwvSjbv61MVv9RSAGMws+vx8KCvc8/vpeiHrKOJdcHde
         TYpJT0Ag+yxX6IFD9nEwVCTI8R4bmztJX4yGtfp7gdVtw6OoB5REcVRi9kRUBp6h3veK
         Yt/kDMGzLq06ib6OsCIik3S3dED/SLRyF+/ALZlFF48V9f2hjVZZ2FtS7+3WjCrOWY8c
         VL9Kwx/Os8TBQAAuwEhW39IhBLm36dijb1ZJmqy0FqWVFSjOUSnB0RE/y8YGwG4hZ0iR
         Q+IwZQKlrgRWGXr5fK8XiBhbUV/M+2UFShTT7PuigRTl0DFjGmts/G3fjRUPkznuXEH8
         R5vQ==
In-Reply-To: <20200429101510.GA28637@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Apr 29, 2020 at 6:15 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 28-04-20 19:26:47, Chris Down wrote:
> > From: Yafang Shao <laoar.shao@gmail.com>
> >
> > A cgroup can have both memory protection and a memory limit to isolate
> > it from its siblings in both directions - for example, to prevent it
> > from being shrunk below 2G under high pressure from outside, but also
> > from growing beyond 4G under low pressure.
> >
> > Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > implemented proportional scan pressure so that multiple siblings in
> > excess of their protection settings don't get reclaimed equally but
> > instead in accordance to their unprotected portion.
> >
> > During limit reclaim, this proportionality shouldn't apply of course:
> > there is no competition, all pressure is from within the cgroup and
> > should be applied as such. Reclaim should operate at full efficiency.
> >
> > However, mem_cgroup_protected() never expected anybody to look at the
> > effective protection values when it indicated that the cgroup is above
> > its protection. As a result, a query during limit reclaim may return
> > stale protection values that were calculated by a previous reclaim cycle
> > in which the cgroup did have siblings.
> >
> > When this happens, reclaim is unnecessarily hesitant and potentially
> > slow to meet the desired limit. In theory this could lead to premature
> > OOM kills, although it's not obvious this has occurred in practice.
>
> Thanks this describes the underlying problem. I would be also explicit
> that the issue should be visible only on tail memcgs which have both
> max/high and protection configured and the effect depends on the
> difference between the two (the smaller it is the largrger the effect).
>
> There is no mention about the fix. The patch resets effective values for
> the reclaim root and I've had some concerns about that
> http://lkml.kernel.org/r/20200424162103.GK11591@dhcp22.suse.cz.
> Johannes has argued that other races are possible and I didn't get to
> think about it thoroughly. But this patch is introducing a new
> possibility of breaking protection.

Agreed with Michal that more writes will cause more bugs.
We should operate the volatile emin and elow as less as possible.

>  If we want to have a quick and
> simple fix that would be easier to backport to older kernels then I
> would feel much better if we simply workedaround the problem as
> suggested earlier http://lkml.kernel.org/r/20200423061629.24185-1-laoar.shao@gmail.com

+1

This should be the right workaround to fix the current issue and it is
worth to be backported to the stable kernel.

> We can rework the effective values calculation to be more robust against
> races on top of that because this is likely a more tricky thing to do.
>
> > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Signed-off-by: Chris Down <chris@chrisdown.name>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Roman Gushchin <guro@fb.com>
> >
> > [hannes@cmpxchg.org: rework code comment]
> > [hannes@cmpxchg.org: changelog]
> > [chris@chrisdown.name: fix store tear]
> > [chris@chrisdown.name: retitle]
> > ---
> >  mm/memcontrol.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0be00826b832..b0374be44e9e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6392,8 +6392,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> >
> >       if (!root)
> >               root = root_mem_cgroup;
> > -     if (memcg == root)
> > +     if (memcg == root) {
> > +             /*
> > +              * The cgroup is the reclaim root in this reclaim
> > +              * cycle, and therefore not protected. But it may have
> > +              * stale effective protection values from previous
> > +              * cycles in which it was not the reclaim root - for
> > +              * example, global reclaim followed by limit reclaim.
> > +              * Reset these values for mem_cgroup_protection().
> > +              */
> > +             WRITE_ONCE(memcg->memory.emin, 0);
> > +             WRITE_ONCE(memcg->memory.elow, 0);
> >               return MEMCG_PROT_NONE;
> > +     }
> >
> >       usage = page_counter_read(&memcg->memory);
> >       if (!usage)
> > --
> > 2.26.2
>
> --
> Michal Hocko
> SUSE Labs



-- 
Thanks
Yafang

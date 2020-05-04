From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 15:26:52 +0800
Message-ID: <CALOAHbCJBaa26m2cUkE0evwDnSFvUPrdBg9=WMjC7Yt_33-BJQ@mail.gmail.com>
References: <20200430182712.237526-1-shakeelb@google.com> <CALOAHbC4WY00yQ46b8CFqVQ3S=JSJxE2HR00TtMqXOWLRPRZ8w@mail.gmail.com>
 <20200504070301.GC22838@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eMJTVwSpQyn/xhp6u+6GN4IMzd//JO41IoEamQ3Zdks=;
        b=csXHDouWQKCAwTYKTsY1cASrw5qLOU/SQ44aHH4e81YyhyyL+8s1fWSxJpJ5ffI8KV
         d+KwWvWpX5ERgqxViOJh805MGZR8BCZnslt3tne6AIXodMd4WEsBUwG/M0VOBAwFNoq/
         oU3xk4oQzjzT+CaztpFeZHTqXMnSHlilEoXJMCxGQyN7vyPZXKZWhmzlAVnb3WwAJnb5
         NLeog00FIK2RkmW7v4PBWkntAt2GFu5annHvVtE74Z0EiDD/M+632aOqt9WkfcJ4gf9m
         N0OKc0cld4iN3Iu3cQzZ979BtN1/FrwwapSxzY+BmT1CEdehAZkHwqcOs6OzMas34b+0
         CZDQ==
In-Reply-To: <20200504070301.GC22838-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 4, 2020 at 3:03 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri 01-05-20 09:39:24, Yafang Shao wrote:
> > On Fri, May 1, 2020 at 2:27 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > > succeed. However if oom-killer does not find a process for killing, it
> > > dumps a lot of warnings.
> > >
> >
> > I have been confused by this behavior for several months and I think
> > it will confuse more memcg users.
>
> Could you be more specific what has caused the confusion?
>

No task is different from no eligible task.
No eligible task means there are some candidates but no one is eligible.
Whille no task means there is no candidate.

> > We should keep the memcg oom behavior consistent with system oom - no
> > oom kill if no process.
>
> This is not the global mmemcg behavior. We do complain loud on no
> eligible tasks and actually panic the system. Memcg cannot simply
> do the same by default for obvious reasons.
>

As explianed above, no eligible task is different from no task.
If there are some candidates but no one is eligible, the system will panic.
While if there's no task, it is definitely no OOM, because that's an
improssible thing for the system.

> > What about bellow change ?
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e28098e13f1c..25fbc37a747f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6086,6 +6086,9 @@ static ssize_t memory_max_write(struct
> > kernfs_open_file *of,
> >                         continue;
> >                 }
> >
> > +               if (!cgroup_is_populated(memcg->css.cgroup))
> > +                       break;
> > +
> >                 memcg_memory_event(memcg, MEMCG_OOM);
> >                 if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
> >                         break;
>
> I am not a great fan to be honest. The warning might be useful for other
> usecases when it is not clear that the memcg is empty.
>

The other usecase can still get the oom status fomr the MEMCG_OOM
event, see bellow,

                 memcg_memory_event(memcg, MEMCG_OOM);
+               if (!cgroup_is_populated(memcg->css.cgroup))
+                       break;

See also https://lore.kernel.org/linux-mm/20200504042621.10334-3-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/T/#u


-- 
Thanks
Yafang

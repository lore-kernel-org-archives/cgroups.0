From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 15:40:18 +0800
Message-ID: <CALOAHbDd8hjURSi9jAdjQTbSLDvu9vkOkjS1hZNn04G8Yj7WdQ@mail.gmail.com>
References: <20200430182712.237526-1-shakeelb@google.com> <CALOAHbC4WY00yQ46b8CFqVQ3S=JSJxE2HR00TtMqXOWLRPRZ8w@mail.gmail.com>
 <20200504070301.GC22838@dhcp22.suse.cz> <CALOAHbCJBaa26m2cUkE0evwDnSFvUPrdBg9=WMjC7Yt_33-BJQ@mail.gmail.com>
 <20200504073549.GE22838@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+OO9udw59FljC0Juy5HE0xNXWZK83D2kTv8ScoSvNNE=;
        b=RXefm4KBKTPlPnFlni95cg+CtOH9b765c48sU8nUlEhEB6EumsSO7LjzkJt8NUn65G
         vOOWU6bFdm2gvvMx6RlE8PrzCR8Ew8KJhXvf4za6A6ZT1DYzSx3ikRwQ2Yi2Bwhbvg1W
         HM5RxZ0vvltitG3kmuTKlIFvOfHLWsXcJak3TyNHBAJrQmnVbqbEnWRFYl/w61Gh6hb+
         8kwdkbqDZR1AW9HYi0FGI4Ck2gp1rw8FmIobCNYj1gmwoqD3rqkxaC/Wu/8y+/B4L7Sq
         40pV1onyrHfUiU7qiqBrE1gN3DCUKq+l7gVCJRJKNNAshlTKbKzkc4NC7j9wSM52zncH
         7PJQ==
In-Reply-To: <20200504073549.GE22838-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 4, 2020 at 3:35 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon 04-05-20 15:26:52, Yafang Shao wrote:
> > On Mon, May 4, 2020 at 3:03 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Fri 01-05-20 09:39:24, Yafang Shao wrote:
> > > > On Fri, May 1, 2020 at 2:27 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > >
> > > > > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > > > > succeed. However if oom-killer does not find a process for killing, it
> > > > > dumps a lot of warnings.
> > > > >
> > > >
> > > > I have been confused by this behavior for several months and I think
> > > > it will confuse more memcg users.
> > >
> > > Could you be more specific what has caused the confusion?
> > >
> >
> > No task is different from no eligible task.
> > No eligible task means there are some candidates but no one is eligible.
> > Whille no task means there is no candidate.
>
> I really fail to see a difference. It is clear the one is subset of the
> other but in practical life tasks might come and go at any time and if
> you try to reduce the hard limit and there are no tasks that could be
> reclaimed then I believe we should complain whether it is only oom
> disabled tasks or no tasks at all. It is certainly unexpected situation
> in some cases because there are resources which are bound to the memcg
> without any task we can act on.
>
> > > > We should keep the memcg oom behavior consistent with system oom - no
> > > > oom kill if no process.
> > >
> > > This is not the global mmemcg behavior. We do complain loud on no
> > > eligible tasks and actually panic the system. Memcg cannot simply
> > > do the same by default for obvious reasons.
> > >
> >
> > As explianed above, no eligible task is different from no task.
> > If there are some candidates but no one is eligible, the system will panic.
> > While if there's no task, it is definitely no OOM, because that's an
> > improssible thing for the system.
>
> This is very much possible situation when all eligible tasks have been
> already killed but they didn't really help to resolve the oom situation
> - e.g. in kernel memory leak or unbounded shmem consumption etc...
>

That's still an impossible thing, because many tasks are invisible to
the oom killer.
See oom_unkillable_task().



-- 
Thanks
Yafang

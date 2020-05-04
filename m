From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 23:39:24 +0800
Message-ID: <CALOAHbCK4dBmL059Lodr-Z-WDnw_f0YtqD8YmaJ0ajGdHYrqhA@mail.gmail.com>
References: <20200430182712.237526-1-shakeelb@google.com> <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz> <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
 <20200504150052.GT22838@dhcp22.suse.cz> <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSh55CCbMhlQ6Ehk5ylQlYonoWrHiCRrR3CxkJ5viUw=;
        b=TMVmOxzBKI7LellWJ7F60mt/JpgFh9iwcKncHCdLGVXpAg3hKnj/oHvXTGDDBRBzd1
         wULU6BtCjnNoxLOyvLQNRqdmUdcIBxlQ4fWOA2mQLZhjRGcFHtnDq1vk56r0qqVlG/8a
         zJSV31XxaCFB1B6FlzYpxlvVlD4uzeCrg1R/IEoeZlOXGMHnRUZfjvq+UHzjb7wd9A3a
         i5hnBEKsw03lfNr9KXKkvmZ73tdCHjs0hxcFnzGFl/MeFVfzbtfP/aR+wbujiGhWv4Fi
         6UDReaAPsD5LzC3wPGT7pC2DdnLauFJ9WwZP73mdyBNLLZ5D1uNx9UnBxQJ8m/QDV+EV
         838g==
In-Reply-To: <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 4, 2020 at 11:36 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, May 4, 2020 at 8:00 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon 04-05-20 07:53:01, Shakeel Butt wrote:
> > > On Mon, May 4, 2020 at 7:11 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > >
> > > > On Mon 04-05-20 06:54:40, Shakeel Butt wrote:
> > > > > On Sun, May 3, 2020 at 11:56 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > > >
> > > > > > On Thu 30-04-20 11:27:12, Shakeel Butt wrote:
> > > > > > > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > > > > > > succeed. However if oom-killer does not find a process for killing, it
> > > > > > > dumps a lot of warnings.
> > > > > >
> > > > > > It shouldn't dump much more than the regular OOM report AFAICS. Sure
> > > > > > there is "Out of memory and no killable processes..." message printed as
> > > > > > well but is that a real problem?
> > > > > >
> > > > > > > Deleting a memcg does not reclaim memory from it and the memory can
> > > > > > > linger till there is a memory pressure. One normal way to proactively
> > > > > > > reclaim such memory is to set memory.max to 0 just before deleting the
> > > > > > > memcg. However if some of the memcg's memory is pinned by others, this
> > > > > > > operation can trigger an oom-kill without any process and thus can log a
> > > > > > > lot un-needed warnings. So, ignore all such warnings from memory.max.
> > > > > >
> > > > > > OK, I can see why you might want to use memory.max for that purpose but
> > > > > > I do not really understand why the oom report is a problem here.
> > > > >
> > > > > It may not be a problem for an individual or small scale deployment
> > > > > but when "sweep before tear down" is the part of the workflow for
> > > > > thousands of machines cycling through hundreds of thousands of cgroups
> > > > > then we can potentially flood the logs with not useful dumps and may
> > > > > hide (or overflow) any useful information in the logs.
> > > >
> > > > If you are doing this in a large scale and the oom report is really a
> > > > problem then you shouldn't be resetting hard limit to 0 in the first
> > > > place.
> > > >
> > >
> > > I think I have pretty clearly described why we want to reset the hard
> > > limit to 0, so, unless there is an alternative I don't see why we
> > > should not be doing this.
> >
> > I am not saying you shouldn't be doing that. I am just saying that if
> > you do then you have to live with oom reports.
> >
> > > > > > memory.max can trigger the oom kill and user should be expecting the oom
> > > > > > report under that condition. Why is "no eligible task" so special? Is it
> > > > > > because you know that there won't be any tasks for your particular case?
> > > > > > What about other use cases where memory.max is not used as a "sweep
> > > > > > before tear down"?
> > > > >
> > > > > What other such use-cases would be? The only use-case I can envision
> > > > > of adjusting limits dynamically of a live cgroup are resource
> > > > > managers. However for cgroup v2, memory.high is the recommended way to
> > > > > limit the usage, so, why would resource managers be changing
> > > > > memory.max instead of memory.high? I am not sure. What do you think?
> > > >
> > > > There are different reasons to use the hard limit. Mostly to contain
> > > > potential runaways. While high limit might be a sufficient measure to
> > > > achieve that as well the hard limit is the last resort. And it clearly
> > > > has the oom killer semantic so I am not really sure why you are
> > > > comparing the two.
> > > >
> > >
> > > I am trying to see if "no eligible task" is really an issue and should
> > > be warned for the "other use cases". The only real use-case I can
> > > think of are resource managers adjusting the limit dynamically. I
> > > don't see "no eligible task" a concerning reason for such use-case.
> >
> > It is very much a concerning reason to notify about like any other OOM
> > situation due to hard limit breach. In this case it is worse in some
> > sense because the limit cannot be trimmed down because there is no
> > directly reclaimable memory at all. Such an oom situation is
> > effectivelly conserved.
> > --
>
> Let me make a more precise statement and tell me if you agree. The "no
> eligible task" is concerning for the charging path but not for the
> writer of memory.max. The writer can read the usage and
> cgroup.[procs|events] to figure out the situation if needed.

Agreed.
cgroup.[procs|events] can give all the admin want in this situation.
The oom report is a redundant infomation, really.

> Usually
> such writers (i.e. resource managers) use memory.high in addition to
> memory.max. First set memory.high and once the usage is below the high
> then set max to not induce the oom-kills.
>



-- 
Thanks
Yafang

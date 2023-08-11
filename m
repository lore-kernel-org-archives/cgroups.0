From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 13:39:24 -0700
Message-ID: <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz> <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz> <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691786401; x=1692391201;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cclQRiJrdAJJ3U9Z+VU5L9YVSiq+e/M7Uw6SXPSKxE4=;
        b=d1WOKri1V0cTECraZJebIF7uPjJ/cWptkll4toOVmEou35hcRaCIpI4nsi1FBz0bDt
         H1OpR6GZp3dHH0M8NOiecO4Mb+PrP1GxQgY85QJrdznaUGNBzKM6xEMAaBzJPwa2Hn1+
         kct6YTFt2DFXdM2WFTU6AkAI5vlvIgW2ee/inEomprJSOrSMNwrqnRw2kETkarbf7ymA
         DFGoP+5Czy9/SpVvrnSY7zSVKVOBSNy7F8kMRpp1jXroskhpWwValEs9ZSldfCrwKo0/
         sE0sWwfPNybS1RJOeEdW8MSxg/Obxb7cWaUPVxNk786GCfjgRPMzTSVPm/PTgKYrVKgI
         sKXQ==
In-Reply-To: <ZNaLGVUtPu7Ua/jL-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

<snip>
> > > > > I hate to repeat myself but please be more specific. This all sounds
> > > > > just too wavy to me.
> > > >
> > > > Sorry I didn't have the full story in mind, I had to do my homework.
> > > > One example is userspace OOM killing. Our userspace OOM killer makes
> > > > decisions based on some stats from memory.stat, and stale stats (a few
> > > > seconds in this case) can result in an unrightful OOM kill, which can
> > > > easily cascade.
> > >
> > > OK, but how is this any different from having outdated data because you
> > > have to wait for memory.stat to read (being blocked inside the rstat
> > > code)? Either your oom killer is reading the stats directly and then you
> > > depend on that flushing which is something that could be really harmful
> > > itself or you rely on another thread doing the blocking and you do not
> > > have up-to-date numbers anyway. So how does blocking actually help?
> >
> > I am not sure I understand.
> >
> > The problem is that when you skip when someone else is flushing, there
> > is a chance that the stats we care about haven't been flushed since
> > the last time the periodic flusher ran. Which is supposed to be ~2
> > seconds ago, but maybe more depending on how busy the workqueue is.
>
> Yes, this is clear. You simply get _some_ snapshot of the past.
>
> > When you block until the flusher finishes, the stats are being
> > refreshed as you wait. So the stats are not getting more outdated as
> > you wait in the general case (unless your cgroup was flushed first and
> > you're waiting for others to be flushed).
> > [Let's call this approach A]
>
> Yes, but the amount of waiting is also undeterministic and even after
> you waited your stats might be outdated already depending on how quickly
> somebody allocates. That was my point.

Right, we are just trying to minimize the staleness window.

>
> > Furthermore, with the implementation you suggested using a mutex, we
> > will wait until the ongoing flush is completed, then we will grab the
> > mutex and do a flush ourselves.
>
> Flushing would be mostly unnecessary as somebody has just flushed
> everything. The only point of mutex is to remove the super ugly busy
> wait for sleepable context construct.

Right, but it also has the (arguably) nice double flush effect, also
minimizes the staleness window.

>
> [...]
> > When running a test that is proactively reclaiming some memory and
> > expecting to see the memory swapped, without this patch, we see
> > significant inaccuracy. In some failure instances we expect ~2000
> > pages to be swapped but we only find ~1200.
>
> That difference is 3MB of memory. What is the precision you are
> operating on?

I am not concerned with MBs, I am concerned with ratio. On a large
system with hundreds of cpus there are larger chances of missing
updates on a bunch of cpus, which might be a lot.

>
> > This is observed on
> > machines with hundreds of cpus, where the problem is most noticeable.
> > This is a huge difference. Keep in mind that the inaccuracy would
> > probably be even worse in a production environment if the system is
> > under enough pressure (e.g. the periodic flusher is late).
> >
> > For both approach A (wait until flusher finishes and exit, i.e this
> > patch) and approach B (wait until flusher finishes then flush, i.e the
> > mutex approach), I stop seeing this failure in the proactive reclaim
> > test and the stats are accurate.
> >
> > I have v2 ready that implements approach B with the mutex ready to
> > fire, just say the word :)
> >
> > >
> > > In any case I do get the argument about consistency within a subtree
> > > (children data largely not matching parents'). Examples like that would
> > > be really helpful as well. If that is indeed the case then I would
> > > consider it much more serious than accuracy which is always problematic
> > > (100ms of an actively allocating context can ruin your just read numbers
> > > and there is no way around that wihtout stopping the world).
> >
> > 100% agreed. It's more difficult to get testing results for this, but
> > that can easily be the case when we have no idea how much is flushed
> > when we return from mem_cgroup_flush_stats().
> >
> > >
> > > Last note, for /proc/vmstat we have /proc/sys/vm/stat_refresh to trigger
> > > an explicit refresh. For those users who really need more accurate
> > > numbers we might consider interface like that. Or allow to write to stat
> > > file and do that in the write handler.
> >
> > This wouldn't be my first option, but if that's the only way to get
> > accurate stats I'll take it.
>
> To be honest, this would be my preferable option because of 2 reasons.
> a) we do not want to guarantee to much on the precision front because
> that would just makes maintainability much more harder with different
> people having a different opinion of how much precision is enough and b)
> it makes the more rare (need precise) case the special case rather than
> the default.

How about we go with the proposed approach in this patch (or the mutex
approach as it's much cleaner), and if someone complains about slow
reads we revert the change and introduce the refresh API? We might
just get away with making all reads accurate and avoid the hassle of
updating some userspace readers to do write-then-read. We don't know
for sure that something will regress.

What do you think?

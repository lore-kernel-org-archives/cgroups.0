From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Fri, 3 Jul 2020 09:27:19 -0700
Message-ID: <CALvZod5Z4=1CijJp0QRnx+pdH=Me6sYPXASCxVATnshU0RW-Qw@mail.gmail.com>
References: <20200702152222.2630760-1-shakeelb@google.com> <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com> <20200703155021.GB114903@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcSwCD8ehLU/B3QNKmMXqmLG2nfUoa8CRrvpDaEqynw=;
        b=aA3CxAPywsEECYk7HA55y/TnZvUHyMJa+H7L7zkuPqWu+SFym0bgvdxpKDd6b5IFKo
         lsiajzdRGT0ACjkznuQLwoDoHR/1dPiP5VltP4vTuxOUJ21D2bXNmG5QWs8GW0jw2Omx
         Tzi39QUCzgkVoA+HKdzc4bozQi7kKP8tEl99FFwHKOBcZscgh2d5GxAi4UWLOu9xu4W8
         CujI1ALU/QEdHaMY7GTwT4v3eVcYy0xRr+ugX8rAiZTTdiCBdz30ay/hr6Xiz8NucxNb
         cYmHkQvMmjHajlRViCjJK1B9fMQnj2Br/meo/+mtVi4Fbqwp+l5mpBdzx4jArAYe5q1c
         QDCA==
In-Reply-To: <20200703155021.GB114903-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 3, 2020 at 8:50 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Jul 03, 2020 at 07:23:14AM -0700, Shakeel Butt wrote:
> > On Thu, Jul 2, 2020 at 11:35 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
> > > [...]
> > > > Interface options:
> > > > ------------------
> > > >
> > > > 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> > > >
> > > > + simple
> > > > + can be extended to target specific type of memory (anon, file, kmem).
> > > > - most probably restricted to cgroup v2.
> > > >
> > > > 2) fadvise(PAGEOUT) on cgroup_dir_fd
> > > >
> > > > + more general and applicable to other FSes (actually we are using
> > > > something similar for tmpfs).
> > > > + can be extended in future to just age the LRUs instead of reclaim or
> > > > some new use cases.
> > >
> > > Could you explain why memory.high as an interface to trigger pro-active
> > > memory reclaim is not sufficient. Also memory.low limit to protect
> > > latency sensitve workloads?
>
> I initially liked the proposal, but after some thoughts I've realized
> that I don't know a good use case where memory.high is less useful.
> Shakeel, what's the typical use case you thinking of?
> Who and how will use the new interface?
>
> >
> > Yes, we can use memory.high to trigger [proactive] reclaim in a memcg
> > but note that it can also introduce stalls in the application running
> > in that memcg. Let's suppose the memory.current of a memcg is 100MiB
> > and we want to reclaim 20MiB from it, we can set the memory.high to
> > 80MiB but any allocation attempt from the application running in that
> > memcg can get stalled/throttled. I want the functionality of the
> > reclaim without potential stalls.
>
> But reclaiming some pagecache/swapping out anon pages can always
> generate some stalls caused by pagefaults, no?
>

Thanks for looking into the proposal. Let me answer both of your
questions together. I have added the two use-cases but let me explain
the proactive reclaim a bit more as we actually use that in our
production.

We have defined tolerable refault rates for the applications based on
their type (latency sensitive or not). Proactive reclaim is triggered
in the application based on their current refault rates and usage. If
the current refault rate exceeds the tolerable refault rate then
stop/slowdown the proactive reclaim.

For the second question, yes, each individual refault can induce the
stall as well but we have more control on that stall as compared to
stalls due to reclaim. For us almost all the reclaimable memory is
anon and we use compression based swap, so, the cost of each refault
is fixed and a couple of microseconds.

I think the next question is what about the refaults from disk or
source with highly variable cost. Usually the latency sensitive
applications remove such uncertainty by mlocking the pages backed by
such backends (e.g. mlocking the executable) or at least that is the
case for us.

Thanks,
Shakeel

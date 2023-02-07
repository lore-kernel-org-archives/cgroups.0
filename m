From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Tue, 7 Feb 2023 14:09:25 -0500
Message-ID: <Y+Kh5atM0TQmkR+R@cmpxchg.org>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
 <CAJD7tkaCpD0LpzdA+NsZj2WK=iQCLn7RS9qc7K53Qonxhp4TgA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHT39fVUOFivmWp0T2APCxSGcvkCC5wF/f/HBMo6Tws=;
        b=Vp05VAn6WPp0SmeMs6zBO1/zMqsCjxnlRpMUhGA4RfkU/2QVMx/BYcetk634lgBMzN
         vGz6qsKafYu7zUfeujZ3CIqZTXkTP6o0ij0PMX/IvndsILFd6gCgqw18boVzyjeQv16a
         IHK+fG9BfR2TVN78eQehT1uheb7Wt0mSJ52hL2fG9GJzUlDQmqlbJjAJC0F5RzcniEYa
         XEjJ2WA3Cv/0vvaPoyFCqgaA9JCIC5flfTf5cwM89obqinQOXV9beq/i14349me5r0UG
         uLnU8sc6RhBSHcQLRDB+EwLxUZqzOrcHe82azdOEo1M7P34MMzZybD8rV3arSC7NkQ2k
         nxfw==
Content-Disposition: inline
In-Reply-To: <CAJD7tkaCpD0LpzdA+NsZj2WK=iQCLn7RS9qc7K53Qonxhp4TgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Feb 02, 2023 at 10:30:40AM -0800, Yosry Ahmed wrote:
> On Thu, Feb 2, 2023 at 7:56 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > Christian reports the following situation in a cgroup that doesn't
> > have memory.swap.max configured:
> >
> >   $ cat memory.swap.events
> >   high 0
> >   max 0
> >   fail 6218
> >
> > Upon closer examination, this is an ARM64 machine that doesn't support
> > swapping out THPs. In that case, the first get_swap_page() fails, and
> > the kernel falls back to splitting the THP and swapping the 4k
> > constituents one by one. /proc/vmstat confirms this with a high rate
> > of thp_swpout_fallback events.
> >
> > While the behavior can ultimately be explained, it's unexpected and
> > confusing. I see three choices how to address this:
> >
> > a) Specifically exlude THP fallbacks from being counted, as the
> >    failure is transient and the memory is ultimately swapped.
> >
> >    Arguably, though, the user would like to know if their cgroup's
> >    swap limit is causing high rates of THP splitting during swapout.
> 
> We have the option to add THP_SWPOUT_FALLBACK (and THP_SWPOUT for
> completeness) to memcg events for this if/when a use case arises,
> right?

Yes, we can add that to memory.stat.

> > b) Only count cgroup swap events when they are actually due to a
> >    cgroup's own limit. Exclude failures that are due to physical swap
> >    shortage or other system-level conditions (like !THP_SWAP). Also
> >    count them at the level where the limit is configured, which may be
> >    above the local cgroup that holds the page-to-be-swapped.
> >
> >    This is in line with how memory.swap.high, memory.high and
> >    memory.max events are counted.
> >
> >    However, it's a change in documented behavior.
> 
> This option makes sense to me, but I can't speak to the change of
> documented behavior. However, looking at the code, it seems like if we do this
> the "max" & "fail" counters become effectively the same. "fail" would
> not provide much value then.

Right.

> I wonder if it makes sense to have both, and clarify that "fail" -
> "max" would be non-limit based failures (e.g. ran out of swap space),
> or would this cause confusion as to whether those non-limit failures
> were transient (THP fallback) or eventual?

If we add the fallback events, the user can calculate it. I wouldn't
split the fail counter itself. There are too many reasons why swap can
fail, half of them implementation-defined (as in the ARM example).

So I think I'll send patches either way to:

1. Fix the hierarchical accounting of the events to make it consistent
   with other counters.

2. Add THP swap/fallback counts to memory.stat

We could consider excluding THP fallbacks from the fail count. But it
seems really wrong for the cgroup controller to start classifying
individual types of failures in the swap layer and make decisions on
how to report them to the user. Cgroups really shouldn't be in the
business of making up its own MM events. I should provide per-cgroup
accounting of native MM events. And nobody has felt the need to add
native swap failure counts yet.

So I'd argue we should either remove the swap fail count altogether
for all the reasons mentioned, or just leave it as is and as a
documented interface that is unfortunately out the door.

Thoughts?

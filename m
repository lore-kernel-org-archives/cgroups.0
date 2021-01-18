From: liming wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tg: add cpu's wait_count of a task group
Date: Mon, 18 Jan 2021 11:07:47 +0800
Message-ID: <CAPnMXWWmfzWh9J_G4OPT=eCFySaD2NAFE0_OiWFQKL-1R0uOkA@mail.gmail.com>
References: <20210115143005.7071-1-wu860403@gmail.com> <YAH4w5T3/oCTGJny@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PlQe4ElMPvugk6/KnMDsBpLgn9qSpVd0RRGjY15TtBQ=;
        b=jEOTuxeeQdSsqnGagWGslg43TXvsjT1GjS43nG6bpxn/Q7TiDnkuEnWBWopiiNc2Si
         o6RVR1YEam7YDczQFb6qnMaGUL3WvdVZBWy3Yak+6iDUPxkF8iyYGfncJxipvOv4+QYB
         bsEd7l/iJIF0C43x8UeAjysvewqGoQWGedgYEO5PDxAFuO6Ssmb+PtUd13Ar2FbCmnAK
         /Hp58BiE1RKUXDzd1UFZatihz1VFurXjXVFZIJihoPXLXU5VTvGitPZd0+6u8QYmjCZ4
         G39JY3u1pOzCoiuluklb/G8chXju9jw2T2mb8a6ba2rJ59IC8DsFhxy9HiRaXKwKjreB
         oUxw==
In-Reply-To: <YAH4w5T3/oCTGJny-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 398776277 <398776277-9uewiaClKEY@public.gmane.org>

Hello tejun:
On Sat, Jan 16, 2021 at 4:20 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Jan 15, 2021 at 10:30:05PM +0800, wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > -     seq_printf(sf, "throttled_time %llu\n", cfs_b->throttled_time);
> ...
> > +     seq_printf(sf, "nr_periods %d\n"
> > +                "nr_throttled %d\n"
> > +                "throttled_usec %llu\n",
> > +                cfs_b->nr_periods, cfs_b->nr_throttled,
> > +                throttled_usec);
>
> This is interface breaking change. I don't think we can do this at this
> point.
Thanks for your reply, agree with it.
> > @@ -8255,6 +8265,19 @@ static int cpu_extra_stat_show(struct seq_file *sf,
> >                          "throttled_usec %llu\n",
> >                          cfs_b->nr_periods, cfs_b->nr_throttled,
> >                          throttled_usec);
> > +             if (schedstat_enabled() && tg != &root_task_group) {
> > +                     u64 ws = 0;
> > +                     u64 wc = 0;
> > +                     int i;
> > +
> > +                     for_each_possible_cpu(i) {
> > +                             ws += schedstat_val(tg->se[i]->statistics.wait_sum);
> > +                             wc += schedstat_val(tg->se[i]->statistics.wait_count);
> > +                     }
> > +
> > +                     seq_printf(sf, "wait_sum %llu\n"
> > +                             "wait_count %llu\n", ws, wc);
> > +             }
>
> What does sum/count tell?
It can tell the task group average latency of every context switch
wait_sum is equivalent to sched_info->run_delay (the second parameter
of /proc/$pid/schedstat)
wait_count is equivalent to sched_info->pcount(the third parameter of
/proc/$pid/schedstat)

Thanks

Liming

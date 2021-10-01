From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flush stats only if updated
Date: Fri, 1 Oct 2021 07:41:43 -0700
Message-ID: <CALvZod7TENAMsmf6swD40RxGFFKOSUtSg9SvgaqE6pdRHy8nrA@mail.gmail.com>
References: <20210930044711.2892660-1-shakeelb@google.com> <YVca+jJnjDn5RLsq@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s0qXtkCtWUxN7VB9S0jNEMSWx7lvs4OCRR8Io1oFKYA=;
        b=URDjUNh9j4DDqU2Z3tr9x4ltkoZ9INlGbBwu71DV8OO7AAhYkjG3TUqZnOyRddg9PP
         zPtfVJw7uvlSUZgsvswISTf0N16HXjYU+xwI1sFNebNN9S6smOjxzHhU/7MGfpFra1OL
         USdlDMgtqYUBvDatB2FWFtOjgwiSWwjv6DtPbS0MFEKLyUoqvDnqn1tl+qLZvsjCSUUZ
         mQUMLDenlLUvnYM7lidTbFlEUB0ETZKwLjt7if0p/oK6919aVezLO6ADFcFHiMmEMfMO
         86Rsjc7d1NE9rsWTcEixzX8JdBYrh4nVIfDLiHESs6X6Z39sp83Kbkq2X2Bx/vvFOJt4
         RdJg==
In-Reply-To: <YVca+jJnjDn5RLsq-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Oct 1, 2021 at 7:26 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Sep 29, 2021 at 09:47:10PM -0700, Shakeel Butt wrote:
> > At the moment, the kernel flushes the memcg stats on every refault and
> > also on every reclaim iteration. Although rstat maintains per-cpu update
> > tree but on the flush the kernel still has to go through all the cpu
> > rstat update tree to check if there is anything to flush. This patch
> > adds the tracking on the stats update side to make flush side more
> > clever by skipping the flush if there is no update.
> >
> > The stats update codepath is very sensitive performance wise for many
> > workloads and benchmarks. So, we can not follow what the commit
> > aa48e47e3906 ("memcg: infrastructure to flush memcg stats") did which
> > was triggering async flush through queue_work() and caused a lot
> > performance regression reports. That got reverted by the commit
> > 1f828223b799 ("memcg: flush lruvec stats in the refault").
> >
> > In this patch we kept the stats update codepath very minimal and let the
> > stats reader side to flush the stats only when the updates are over a
> > specific threshold. For now the threshold is (nr_cpus * CHARGE_BATCH).
> >
> > To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
> > a system with swap-on-zram and the file was pushed to swap through
> > memory.force_empty interface. On reading the whole file, the memcg stat
> > flush in the refault code path is triggered. With this patch, we
> > bserved 63% reduction in the read time of 8 GiB file.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> This is a great idea.
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks.

>
> One minor nit:
>
[...]
>
> Because of the way the updates and the flush interact through these
> variables now, it might be better to move these up and together.
>
> It'd also be good to have a small explanation of the optimization in
> the code as well - that we accept (limited) percpu fuzz in lieu of not
> having to check all percpus for every flush.

I will move the code and add the comment on the optimization in the
next version.

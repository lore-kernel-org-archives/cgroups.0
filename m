From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5] sched/fair: Correctly insert cfs_rq's to list on
 unthrottle
Date: Mon, 14 Jun 2021 15:10:21 +0200
Message-ID: <YMdVPVMByhGjCUdl@hirez.programming.kicks-ass.net>
References: <20210612112815.61678-1-odin@uged.al>
 <CAKfTPtCMqZZnbwfhw0gz1Bne4j7PcG-Ma02a=gmcGbjY1bHk=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yYnDg3XToeuw/icgLCU3YUeHSV1eO6Orp2u9I1YQxLs=; b=L7QQyEqUDnpT2CTnWsfdUKnPOb
        UMJRkNXbgGIfiJcsKyywlJBymn+sxZ3HEfKWmlCuDltILhkt+ClJyX7MThKpn7+gCfubqLnKuqf47
        FER5eFzqEN8SiDqXpTGZuq/fAjtJHKwkOmcySBz0gaAXWXbZYuzknI+seEnPFh2G/gFzNKoOOCwx/
        TjH/a3dhLJ48zCIwadnjBcaEspyHnf5wNNQcVzJGuK39FBDeZe5D/BoWD6Svmx+aJbMdy6pvv+c2Q
        W9ro17JNLHq7fJM3TuVq+t8o4+k8jFti4sd7002OXI0JUZnLOl+wQmT3O2goZFZUJj2cjnGbcAAZj
        5JDQgg+A==;
Content-Disposition: inline
In-Reply-To: <CAKfTPtCMqZZnbwfhw0gz1Bne4j7PcG-Ma02a=gmcGbjY1bHk=g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 14, 2021 at 02:01:55PM +0200, Vincent Guittot wrote:
> On Sat, 12 Jun 2021 at 13:31, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
> >
> > This fixes an issue where fairness is decreased since cfs_rq's can
> > end up not being decayed properly. For two sibling control groups with
> > the same priority, this can often lead to a load ratio of 99/1 (!!).
> >
> > This happen because when a cfs_rq is throttled, all the descendant cfs_rq's
> 
> s/happen/happens/
> 
> > will be removed from the leaf list. When they initial cfs_rq is
> > unthrottled, it will currently only re add descendant cfs_rq's if they
> > have one or more entities enqueued. This is not a perfect heuristic.
> >
> > Instead, we insert all cfs_rq's that contain one or more enqueued
> > entities, or it its load is not completely decayed.
> >
> > Can often lead to situations like this for equally weighted control
> > groups:
> >
> > $ ps u -C stress
> > USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> > root       10009 88.8  0.0   3676   100 pts/1    R+   11:04   0:13 stress --cpu 1
> > root       10023  3.0  0.0   3676   104 pts/1    R+   11:04   0:00 stress --cpu 1
> >
> > Fixes: 31bc6aeaab1d ("sched/fair: Optimize update_blocked_averages()")
> > Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> 
> minor typo in the commit message otherwise
> 
> Reviewed-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks!

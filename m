From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority
 at wakeup
Date: Tue, 21 Feb 2023 15:15:30 +0100
Message-ID: <Y/TSAivRWwm2LaPh@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org>
 <Y/S+qrschy+N+QCQ@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/ezhrO5zcxPw5+cqyTN5jzGAr1WfOqENe6I0B5fgvAc=; b=k6n0f41dHDTj1LNeXWdqDPTQKM
        9V7x8Dfz8aRSyJ5mOfngmFuzoLP4aAURHW5SbpIrwkzJYHKm378+p3nbJMa7nJsGAJcUDH0XSMZde
        eralntXxL7EhtJPgYMK7ybkIQUUZ3QKWdLcklvnnjwdrzPUc1UxzEt/fiqcdYLJsIKMAEgJ278s4e
        yMS+XVWoGVrE86BOyZR0dN9aDMEPUSk4E6idknPpwO6f6jRnWkFLB/xXorMFlPwhyG8N/4jql0MGQ
        j4+eQM0+G8+oFl6fgtMp89EM4r2bsWVj0WCFynSY6mrBT5WIqOxcG6NBp6tJGXBJszUl0uA5/wCjW
        /MskH9KQ==;
Content-Disposition: inline
In-Reply-To: <Y/S+qrschy+N+QCQ-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, Feb 21, 2023 at 01:52:58PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 13, 2023 at 03:12:30PM +0100, Vincent Guittot wrote:
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 6c61bde49152..38decae3e156 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -568,6 +568,8 @@ struct sched_entity {
> >  	/* cached value of my_q->h_nr_running */
> >  	unsigned long			runnable_weight;
> >  #endif
> > +	/* preemption offset in ns */
> > +	long				latency_offset;
> 
> I wonder about the type here; does it make sense to have it depend on
> the bitness; that is if s32 is big enough on 32bit then surely it is so
> too on 64bit, and if not, then it should be unconditionally s64.
> 

The cgroup patch has this as 'int'. I'm thinking we ought to be
consistent :-)

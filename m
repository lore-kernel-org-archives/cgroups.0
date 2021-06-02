From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Date: Wed, 2 Jun 2021 10:06:58 -0400 (EDT)
Message-ID: <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
References: <20210602131225.336600299@infradead.org> <20210602133040.587042016@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 79BFA302868
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642818;
        bh=GwH0GdcKUFmXjwdSc5PC6qayNfPYEbeSfo7iFd8LGlc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=IzY7rj9bG67qO5MhQCvNkTZ6NmKLl+j7CGAPSRZx3M3VXN4GE9cW/xiqKbb0lMrag
         set1cTsKpmrC3scRLhvadBwRFL0ucET03FgN+RYhAetywU7SMjz4Jzot43Al7b42/w
         wRf/j9ODOuM7qSvP03brlcfNA9m+dmMrwW5plmJFJwkQAs2hFyj/Dx0kstoADKFw0s
         PShGdCuiX9KikFibuSZcET8LNklvf4YN8WFNh0QHjOaoJ5JxioNYTizyl5WrJqstOz
         gIo6cZK3qsMar7jMzCrxaFOM5us8879gVttQyPgo4y+VuhrGp7sB3x4o9l+rwPGYzG
         yQHn8ljzHTpmw==
In-Reply-To: <20210602133040.587042016-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, bristot <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj@kernel.>

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
[...]
> 
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c

[...]
> @@ -1559,7 +1560,8 @@ static int fill_psinfo(struct elf_prpsin
> 	psinfo->pr_pgrp = task_pgrp_vnr(p);
> 	psinfo->pr_sid = task_session_vnr(p);
> 
> -	i = p->state ? ffz(~p->state) + 1 : 0;
> +	state = READ_ONCE(p->__state);
> +	i = state ? ffz(~state) + 1 : 0;
> 	psinfo->pr_state = i;
> 	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
> 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';

[...]

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -113,13 +113,13 @@ struct task_group;
> 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
> 					 TASK_PARKED)
> 
> -#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
> +#define task_is_running(task)		(READ_ONCE((task)->__state) == TASK_RUNNING)
> 
> -#define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
> +#define task_is_traced(task)		((READ_ONCE(task->__state) & __TASK_TRACED) != 0)
> 
> -#define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
> +#define task_is_stopped(task)		((READ_ONCE(task->__state) & __TASK_STOPPED) !=
> 0)
> 
> -#define task_is_stopped_or_traced(task)	((task->state & (__TASK_STOPPED |
> __TASK_TRACED)) != 0)
> +#define task_is_stopped_or_traced(task)	((READ_ONCE(task->__state) &
> (__TASK_STOPPED | __TASK_TRACED)) != 0)
> 
> #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 
> @@ -134,14 +134,14 @@ struct task_group;
> 	do {							\
> 		WARN_ON_ONCE(is_special_task_state(state_value));\
> 		current->task_state_change = _THIS_IP_;		\
> -		current->state = (state_value);			\
> +		WRITE_ONCE(current->__state, (state_value));	\
> 	} while (0)

Why not introduce set_task_state(p) and get_task_state(p) rather than sprinkle
READ_ONCE() and WRITE_ONCE() all over the kernel ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

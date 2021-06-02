From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 2 Jun 2021 10:15:16 -0400 (EDT)
Message-ID: <1524365960.5868.1622643316351.JavaMail.zimbra@efficios.com>
References: <20210602131225.336600299@infradead.org> <20210602133040.398289363@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9F3AF302B63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622643316;
        bh=wTS/crR/26N4BDTiNFNNZoqsETfUenagK9Jc/umukAM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=HjuuxeCx/W0ucWdgkdPe4Ltmueov6LEz9QoWVQ9n275sUH5V2BfBx2uLemee8nOgV
         iEPOUdYsPm3Mmmkxyd2M/xe2NzuiK0lte25kNJqF/D6aBdMudEsd6+/AvYnVI3XvQB
         I3eKlxdMnA/4sIrtiEyziYHBHFsURA8x1tU1usHbZhQ+Nqw4zpB4HKNzuSQ6QLswXS
         8VevSWMXfGVlYdJrwg5WBPwEe4w0fAdx0pE768+FRtKKL3etA75RfRjkypdxFoVZY5
         KUm3EJy+oFxv1WaIjL0MV00CLSuspl8VcSBxV1CpXr+Or5zRpRWJvt+/OT6gN/Sqjt
         hvtczOpS4cKPQ==
In-Reply-To: <20210602133040.398289363-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, bristot <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <liz>

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
[...]
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> 		},
> 	};
> 
> -	if (!sched_in && task->state == TASK_RUNNING)
> +	if (!sched_in && current->on_rq) {
> 		switch_event.event_id.header.misc |=
> 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
> +	}
> 
> -	perf_iterate_sb(perf_event_switch_output,
> -		       &switch_event,
> -		       NULL);
> +	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
> }

There is a lot of code cleanup going on here which does not seem to belong
to a "Fix" patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
Date: Wed, 2 Jun 2021 10:01:29 -0400 (EDT)
Message-ID: <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
References: <20210602131225.336600299@infradead.org> <20210602133040.461908001@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 78F88302B31
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642489;
        bh=ildkMTk0vYSZK39yeI6C0NluRoGntZ1yA5EuqMA4g8k=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=L/w8o2fJN3kmP73a2vMCtFWwO5YPeIOe9ZmTydEyFWmyEaOlcyFybIdRWoe8hmy34
         bHqWF5FDpTTdDr9jNR/6ossgQUg8/lo1uSvmOEMQI+8PvcMWXQjFHlESOaJErckXTB
         oIuIBEBiJQ9FvKa8qYSLXZLHpWnciBfTelSzOSmbORnUr52zBvJXfWQpx94UqNlbmY
         Y6yF4/4xX5ToklNVtEYeJ+rmH/TXxAzWx0JJ6vQD3FMua0nJmkIgpXS7yGiTDiDM65
         T6y687zdG38LDyLZ4Slpb06ysgcGN+OXRe4bfPmRBCeqmhnbNwAWPu5258Lpn1Ta7C
         10t9Cfwl8X+bQ==
In-Reply-To: <20210602133040.461908001-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, bristot <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj@kernel.>

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> Remove yet another few p->state accesses.

[...]

> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -212,6 +212,8 @@ struct task_group;
> 
> #endif
> 
> +#define get_current_state()	READ_ONCE(current->state)

Why use a macro rather than a static inline here ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

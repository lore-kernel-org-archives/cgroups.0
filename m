From: cruzzhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched/core: Forced idle accounting per-cpu
Date: Fri, 14 Jan 2022 23:04:11 +0800
Message-ID: <86fbc313-e179-0cbd-8f5b-66e7b5964b14@linux.alibaba.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-3-git-send-email-CruzZhao@linux.alibaba.com>
 <CABk29NtonxXS53J-+3w_GTLTVurf8HS4v35T9evoGyERB0uDqA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <CABk29NtonxXS53J-+3w_GTLTVurf8HS4v35T9evoGyERB0uDqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



在 2022/1/12 上午9:59, Josh Don 写道:
> On Tue, Jan 11, 2022 at 1:56 AM Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>>
>> Accounting for "forced idle" time per cpu, which is the time a cpu is
>> forced to idle by its SMT sibling.
>>
>> As it's not accurate to measure the capacity loss only by cookie'd forced
>> idle time, and it's hard to trace the forced idle time caused by all the
>> uncookie'd tasks, we account the forced idle time from the perspective of
>> the cpu.
>>
>> Forced idle time per cpu is displayed via /proc/schedstat, we can get the
>> forced idle time of cpu x from the 10th column of the row for cpu x. The
>> unit is ns. It also requires that schedstats is enabled.
>>
>> Signed-off-by: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> ---
> 
> Two quick followup questions:
> 
> 1) From your v1, I still wasn't quite sure if the per-cpu time was
> useful or not for you versus a single overall sum (ie. I think other
> metrics could be more useful for analyzing steal_cookie if that's what
> you're specifically interested in). Do you definitely want the per-cpu
> totals?
> 
IMO, the per-cpu forced idle time can help us get to know whether the
forced idle time is uniform among the core, or among all the cpus. IMO,
it's a kind of balance.

> 2) If your cgroup accounting patch is merged, do you still want this
> patch? You can grab the global values from the root cgroup (assuming
> you have cgroups enabled). The only potential gap is if you need
> per-cpu totals, though I'm working to add percpu stats to cgroup-v2:
> https://lkml.kernel.org/r/%3C20220107234138.1765668-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org%3E

If cgroup accounting patch is merged, this patch is still needed.

Consider the following scenario:
Task p of cgroup A is running on cpu x, and it forces cpu y into idle
for t ns. The forceidle time of cgroup A on cpu x increases t ns, and
the forcedidle time of cpu y increases t ns.

That is, the force idle time of cgroup is defined as the forced idle
time it caused, and the force idle time of cpu is defined as the time
the cpu is forced into idle, which have different meanings from each other.

And for SMT > 2, we cannot caculate the forced idle time of cpu x from
the cgroup interface.

Best,
Cruz Zhao

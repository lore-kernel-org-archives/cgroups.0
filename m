From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched/core: Forced idle accounting per-cpu
Date: Fri, 14 Jan 2022 15:40:43 -0800
Message-ID: <CABk29Nu0iCs83VjuipEohL63mdUg_4L-=dKPS0yzE=SfYXtcxw@mail.gmail.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-3-git-send-email-CruzZhao@linux.alibaba.com>
 <CABk29NtonxXS53J-+3w_GTLTVurf8HS4v35T9evoGyERB0uDqA@mail.gmail.com> <86fbc313-e179-0cbd-8f5b-66e7b5964b14@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QiwAHNhKS7wc00xP0NkWpMqOI7Wv0fb83E9HIPmzpeQ=;
        b=f5K79nKirjMw1uZAqB8jvKCYF2VSIM89RFH6n+QkXCfokaesvVBgMlOYEtAdSqZTRe
         lU4Y83UqCN+A3ynzeu7Cc4A9Lze0vLHbfv4p82QUhm8UmXcH325CogYt9rgsMlhnr/tV
         o/BT2s/rIgeLPW2C8NyBCiWzOGTujj3UUp4uH+JcE5JScDKqp4VIzxf9QwQRJWX1NqZv
         uQQzr+LiOIxKC3vnSuq3o93vk3tOnscteB93o+ySjio9QbMGwlI+RR5LEeUp/pMtTbcB
         ioyvpduZTWaApn0ya56DywySKvdjIltTLxfYxnBRWUb55S3b6RHYaE9yhxwshTIoSXdi
         4agw==
In-Reply-To: <86fbc313-e179-0cbd-8f5b-66e7b5964b14-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cruzzhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> > 1) From your v1, I still wasn't quite sure if the per-cpu time was
> > useful or not for you versus a single overall sum (ie. I think other
> > metrics could be more useful for analyzing steal_cookie if that's what
> > you're specifically interested in). Do you definitely want the per-cpu
> > totals?
> >
> IMO, the per-cpu forced idle time can help us get to know whether the
> forced idle time is uniform among the core, or among all the cpus. IMO,
> it's a kind of balance.

Sure, I'm not opposed to it.

> > 2) If your cgroup accounting patch is merged, do you still want this
> > patch? You can grab the global values from the root cgroup (assuming
> > you have cgroups enabled). The only potential gap is if you need
> > per-cpu totals, though I'm working to add percpu stats to cgroup-v2:
> > https://lkml.kernel.org/r/%3C20220107234138.1765668-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org%3E
>
> If cgroup accounting patch is merged, this patch is still needed.
>
> Consider the following scenario:
> Task p of cgroup A is running on cpu x, and it forces cpu y into idle
> for t ns. The forceidle time of cgroup A on cpu x increases t ns, and
> the forcedidle time of cpu y increases t ns.
>
> That is, the force idle time of cgroup is defined as the forced idle
> time it caused, and the force idle time of cpu is defined as the time
> the cpu is forced into idle, which have different meanings from each other.
>
> And for SMT > 2, we cannot caculate the forced idle time of cpu x from
> the cgroup interface.

Ack. Note that the patch I linked above for per-cpu stats for
cgroup-v2 has been nack'd, so it is unlikely we'll have kernel exports
for cgroup-v2 per-cpu stats (but perhaps some export via BPF). In v2,
we could at least export the cgroup sum force idle time in cpu.stat,
if you feel it would be useful and want to add the accounting to
rstat. If you really just want the per-cpu root stats then I'm fine
with skipping cgroup for now.

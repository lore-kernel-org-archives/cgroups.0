From: Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Wed, 14 Apr 2021 15:00:55 -0700
Message-ID: <CAGXk5yp5sETNM=b4vw8xiCF=YYRhAqSpzHe-0W2Zm-VMnZsnTw@mail.gmail.com>
References: <1617714261-18111-1-git-send-email-pkondeti@codeaurora.org>
 <YGxjwKbec68sCcqo@slm.duckdns.org> <20210406152715.GB21941@codeaurora.org>
 <YGyJHAlLKqng2WeS@slm.duckdns.org> <20210407013856.GC21941@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=UH9r0bLwqpvfnNk2Tt3rk+LCXIhN1P9yRfnJnHjQ3r0=;
        b=cg12crFQou1yuZGklg3lvMl/mxvNSOoWRHuZwMSshge9hHeV1OLwzSrHN51bDEc6JZ
         k/iB0Y11pHw9ykAzvJNMw2ZkAgCXMxaEPE/03Z8r3M90okfBUCq+Trp6OOHocfMQ5DF9
         +L1gQYqaaJNKLSb45ahZgtnf2ryriGm+KP91CMPoXQ3kkd2jWrvDyc44fatGb/B4bE6F
         fZrFEF3Qaj9LjKLH72J8C9pukSvhyq2YBlV4WXTbrm+KNXuEY6oh2hOm4UAIUFNorzQU
         fcxxW/ddKBev3nlRXzp156Wd8lGoZWAamKo3ZP2a3tdsI7BdXbwdUuqokrqxNcm/j4me
         Ibgg==
In-Reply-To: <20210407013856.GC21941-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 6, 2021 at 6:39 PM Pavan Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>
> On Tue, Apr 06, 2021 at 12:15:24PM -0400, Tejun Heo wrote:
> > Hello,
> >
> > On Tue, Apr 06, 2021 at 08:57:15PM +0530, Pavan Kondeti wrote:
> > > Yeah. The workqueue attrs comes in handy to reduce the nice/prio of a
> > > background workqueue if we identify that it is cpu intensive. However, this
> > > needs case by case analysis, tweaking etc. If there is no other alternative,
> > > we might end up chasing the background workers and reduce their nice value.
> >
> > There shouldn't be that many workqueues that consume a lot of cpu cycles.
> > The usual culprit is kswapd, IO related stuff (writeback, encryption), so it
> > shouldn't be a long list and we want them identified anyway.
> >
> Sure. I have not done a complete study on which workers in our system can
> compete with important tasks in other cgroups. We will have to do that to
> adjust the workqueue priority so that the impact can be minimized.
>

kswapd0 is actually migratable to subgroup.

But echo what Pavan said, the real world is not ideal and the
problematice drivers are inactive when the use case is not activated
in Android, e.g. connectivity, camera, etc. It is tricky sometimes to
track all of those.

> > > The problem at our hand (which you might be knowing already) is that, lets say
> > > we have 2 cgroups in our setup and we want to prioritize UX over background.
> > > IOW, reduce the cpu.shares of background cgroup. This helps in prioritizing
> > > Task-A and Task-B over Task-X and Task-Y. However, each individual kworker
> > > can potentially have CPU share equal to the entire UX cgroup.
> > >
> > > -kworker/0:0
> > > -kworker/1:0
> > > - UX
> > > ----Task-A
> > > ----Task-B
> > > - background
> > > ----Task-X
> > > ----Task-Y
> > > Hence we want to move all kernel threads to another cgroup so that this cgroup
> > > will have CPU share equal to UX.
> > >
> > > The patch presented here allows us to create the above setup. Any other
> > > alternative approaches to achieve the same without impacting any future
> > > designs/requirements?
> >
> > Not quite the same but we already have
> > /sys/devices/virtual/workqueue/cpumask which affects all unbound workqueues,
> > so maybe a global default priority knob would help here?
> >
>
> yeah, not exactly what we are looking for. It gives us the abiility to restrict
> the priority of all unbound workqueues at the expense of not being able to
> prioritize one workqueue over another workqueue.
>

Same here, Android used to have its cgroup setup like this, where the
BG group can be starved too long potentially (and sometimes PI is not
inevitable of course,  that's the reason why I removed BG cgroup in
Android (https://android-review.googlesource.com/q/topic:remove_bg_cgroup)).

-Task-A
-Task-B
-kworker/0:0
- background
----Task-X
----Task-Y

So having things left in root will post the same risk,

> Thanks,
> Pavan
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
>

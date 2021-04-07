From: Pavan Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Wed, 7 Apr 2021 07:08:56 +0530
Message-ID: <20210407013856.GC21941@codeaurora.org>
References: <1617714261-18111-1-git-send-email-pkondeti@codeaurora.org>
 <YGxjwKbec68sCcqo@slm.duckdns.org>
 <20210406152715.GB21941@codeaurora.org>
 <YGyJHAlLKqng2WeS@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617759561; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=SMzPWIhKVgVyt+OXV36wrD1CBWot3oCL7BANrZGmW5s=; b=cO9zL63saxu6n6wm4Cfy6jPx2QwV5tCamd+cAm6fP6v4OBUtsrZJVP49MoTaxtPs5HES9Bp5
 Jpkhri3pF66Ac5e0Z3hOQobvYypnAn4t541c7ZUSVvUXd0Bn+6EGmr730ysAnou6BB2+kTMu
 I1xaK+tWC/shWBlm/G16JLA7YEA=
Sender: pkondeti=codeaurora.org-qLvOmUbifpzLzYW4gMljz9i2O/JbrIOy@public.gmane.org
Content-Disposition: inline
In-Reply-To: <YGyJHAlLKqng2WeS-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 06, 2021 at 12:15:24PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 06, 2021 at 08:57:15PM +0530, Pavan Kondeti wrote:
> > Yeah. The workqueue attrs comes in handy to reduce the nice/prio of a
> > background workqueue if we identify that it is cpu intensive. However, this
> > needs case by case analysis, tweaking etc. If there is no other alternative,
> > we might end up chasing the background workers and reduce their nice value.
> 
> There shouldn't be that many workqueues that consume a lot of cpu cycles.
> The usual culprit is kswapd, IO related stuff (writeback, encryption), so it
> shouldn't be a long list and we want them identified anyway.
> 
Sure. I have not done a complete study on which workers in our system can
compete with important tasks in other cgroups. We will have to do that to
adjust the workqueue priority so that the impact can be minimized.

> > The problem at our hand (which you might be knowing already) is that, lets say
> > we have 2 cgroups in our setup and we want to prioritize UX over background.
> > IOW, reduce the cpu.shares of background cgroup. This helps in prioritizing
> > Task-A and Task-B over Task-X and Task-Y. However, each individual kworker
> > can potentially have CPU share equal to the entire UX cgroup.
> > 
> > -kworker/0:0
> > -kworker/1:0
> > - UX
> > ----Task-A
> > ----Task-B
> > - background
> > ----Task-X
> > ----Task-Y
> > Hence we want to move all kernel threads to another cgroup so that this cgroup
> > will have CPU share equal to UX.
> > 
> > The patch presented here allows us to create the above setup. Any other
> > alternative approaches to achieve the same without impacting any future
> > designs/requirements?
> 
> Not quite the same but we already have
> /sys/devices/virtual/workqueue/cpumask which affects all unbound workqueues,
> so maybe a global default priority knob would help here?
> 

yeah, not exactly what we are looking for. It gives us the abiility to restrict
the priority of all unbound workqueues at the expense of not being able to
prioritize one workqueue over another workqueue.

Thanks,
Pavan
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


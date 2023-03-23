From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 09:17:33 -0700
Message-ID: <CAJD7tkbGCgk9VkGdec0=AdHErds4XQs1LzJMhqVryXdjY5PVAg@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
 <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
 <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
 <CAJD7tkYWo_aB7a4SHXNQDHwcaTELonOk_Vd8q0=x8vwGy2VkYg@mail.gmail.com>
 <CALvZod7f9Rejb_WrZ+Ajegz-NsQ7iPQegRDMdk5Ya0a0w=40kg@mail.gmail.com> <CALvZod7-6F84POkNetA2XJB-24wms=5q_s495NEthO8b63rL4A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679588290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxwPj9zc4wVERdaRm3UD6tbyjSI8uDBIlR3KTexXHNg=;
        b=XhO6nZVp3cJ6GYNnQ2ZPBd/bevteGrZU/HIt7rhk+LHiYXbwkTEIAA/Gm2lDHIMikg
         gfoYKiDCpNo8lnfMBlGGsI0PLQz5CrW36qepgWsG7uExChYhRpji3UqRtZum7cH/vdbZ
         nMqTsTLwMkfU7eqB6QIAZhzjzcr6MfIBsV9+Mh7lY8ajGfGMxL7VuLMDYbs0rNlH1Lgf
         iV6mh1620CTOr/soDFy1jiw2Cv+8sGb2vRKHlFpQOFPw708c41xBPfnbqLdjoqoACMXl
         o1UnaPMAjjFpYJ904SCgAI0gxQMgUnTxaQY+oMY7qneZ4HxyRULhAJKXlDXAWNrPcPJl
         8/jQ==
In-Reply-To: <CALvZod7-6F84POkNetA2XJB-24wms=5q_s495NEthO8b63rL4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 9:10=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Thu, Mar 23, 2023 at 8:46=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> >
> > On Thu, Mar 23, 2023 at 8:43=E2=80=AFAM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > >
> > > On Thu, Mar 23, 2023 at 8:40=E2=80=AFAM Shakeel Butt <shakeelb@google=
.com> wrote:
> > > >
> > > > On Thu, Mar 23, 2023 at 6:36=E2=80=AFAM Yosry Ahmed <yosryahmed@goo=
gle.com> wrote:
> > > > >
> > > > [...]
> > > > > > >
> > > > > > > > 2. Are we really calling rstat flush in irq context?
> > > > > > >
> > > > > > > I think it is possible through the charge/uncharge path:
> > > > > > > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usag=
e(). I
> > > > > > > added the protection against flushing in an interrupt context=
 for
> > > > > > > future callers as well, as it may cause a deadlock if we don'=
t disable
> > > > > > > interrupts when acquiring cgroup_rstat_lock.
> > > > > > >
> > > > > > > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() =
is only
> > > > > > > > done for root memcg. Why is mem_cgroup_threshold() interest=
ed in root
> > > > > > > > memcg usage? Why not ignore root memcg in mem_cgroup_thresh=
old() ?
> > > > > > >
> > > > > > > I am not sure, but the code looks like event notifications ma=
y be set
> > > > > > > up on root memcg, which is why we need to check thresholds.
> > > > > >
> > > > > > This is something we should deprecate as root memcg's usage is =
ill defined.
> > > > >
> > > > > Right, but I think this would be orthogonal to this patch series.
> > > > >
> > > >
> > > > I don't think we can make cgroup_rstat_lock a non-irq-disabling loc=
k
> > > > without either breaking a link between mem_cgroup_threshold and
> > > > cgroup_rstat_lock or make mem_cgroup_threshold work without disabli=
ng
> > > > irqs.
> > > >
> > > > So, this patch can not be applied before either of those two tasks =
are
> > > > done (and we may find more such scenarios).
> > >
> > >
> > > Could you elaborate why?
> > >
> > > My understanding is that with an in_task() check to make sure we only
> > > acquire cgroup_rstat_lock from non-irq context it should be fine to
> > > acquire cgroup_rstat_lock without disabling interrupts.
> >
> > From mem_cgroup_threshold() code path, cgroup_rstat_lock will be taken
> > with irq disabled while other code paths will take cgroup_rstat_lock
> > with irq enabled. This is a potential deadlock hazard unless
> > cgroup_rstat_lock is always taken with irq disabled.
>
> Oh you are making sure it is not taken in the irq context through
> should_skip_flush(). Hmm seems like a hack. Normally it is recommended
> to actually remove all such users instead of silently
> ignoring/bypassing the functionality.

It is a workaround, we simply accept to read stale stats in irq
context instead of the expensive flush operation.

>
> So, how about removing mem_cgroup_flush_stats() from
> mem_cgroup_usage(). It will break the known chain which is taking
> cgroup_rstat_lock with irq disabled and you can add
> WARN_ON_ONCE(!in_task()).

This changes the behavior in a more obvious way because:
1. The memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage()
path is also exercised in a lot of paths outside irq context, this
will change the behavior for any event thresholds on the root memcg.
With proposed skipped flushing in irq context we only change the
behavior in a small subset of cases.

I think we can skip flushing in irq context for now, and separately
deprecate threshold events for the root memcg. When that is done we
can come back and remove should_skip_flush() and add a VM_BUG_ON or
WARN_ON_ONCE instead. WDYT?

2. mem_cgroup_usage() is also used when reading usage from userspace.
This should be an easy workaround though.

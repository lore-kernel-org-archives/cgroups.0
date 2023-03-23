From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 09:29:36 -0700
Message-ID: <CALvZod7saq910u4JxnuY4C7EwiK5vgNF=-Bv+236RprUOQdkjw@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
 <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
 <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
 <CAJD7tkYWo_aB7a4SHXNQDHwcaTELonOk_Vd8q0=x8vwGy2VkYg@mail.gmail.com>
 <CALvZod7f9Rejb_WrZ+Ajegz-NsQ7iPQegRDMdk5Ya0a0w=40kg@mail.gmail.com>
 <CALvZod7-6F84POkNetA2XJB-24wms=5q_s495NEthO8b63rL4A@mail.gmail.com> <CAJD7tkbGCgk9VkGdec0=AdHErds4XQs1LzJMhqVryXdjY5PVAg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679588988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Re7Ul0ocDttfAu2MIei1cNhSsXPUW8eyd1Dmg4NOWNY=;
        b=ta8VBHiRyoygVRQCyQdLSUWlxj/b6S8E/YOXEjvQvBe+KnMbrmIzc8Q5T/2Db4c1fC
         POV8HV4H5T1K63dxkgXi76qwKMFVbmhC3hacNk/nBSEksUMJvjMclFKx/lyBuATImAeN
         t0jIOpB7aVfUPX9uuC+89PXHxfqs9Rlh6eGrUGdRduuyJM2hunicNCOFkMsNdRNsIeBX
         kUBCxLSaYyc/lkmVfJQ2KnM/BZn4rW5AYN+5TWngULmqNlS57bA2WWMwgy45bh9ZMLDJ
         bs/OzYmIvgTWjQbeZrl2GwvvIHs4BJaPX3DoANTZtPPHl/zJZxVOARVxA1wMMpj6hcm0
         EzaQ==
In-Reply-To: <CAJD7tkbGCgk9VkGdec0=AdHErds4XQs1LzJMhqVryXdjY5PVAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 9:18=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Thu, Mar 23, 2023 at 9:10=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> >
> > On Thu, Mar 23, 2023 at 8:46=E2=80=AFAM Shakeel Butt <shakeelb@google.c=
om> wrote:
> > >
> > > On Thu, Mar 23, 2023 at 8:43=E2=80=AFAM Yosry Ahmed <yosryahmed@googl=
e.com> wrote:
> > > >
> > > > On Thu, Mar 23, 2023 at 8:40=E2=80=AFAM Shakeel Butt <shakeelb@goog=
le.com> wrote:
> > > > >
> > > > > On Thu, Mar 23, 2023 at 6:36=E2=80=AFAM Yosry Ahmed <yosryahmed@g=
oogle.com> wrote:
> > > > > >
> > > > > [...]
> > > > > > > >
> > > > > > > > > 2. Are we really calling rstat flush in irq context?
> > > > > > > >
> > > > > > > > I think it is possible through the charge/uncharge path:
> > > > > > > > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_us=
age(). I
> > > > > > > > added the protection against flushing in an interrupt conte=
xt for
> > > > > > > > future callers as well, as it may cause a deadlock if we do=
n't disable
> > > > > > > > interrupts when acquiring cgroup_rstat_lock.
> > > > > > > >
> > > > > > > > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage(=
) is only
> > > > > > > > > done for root memcg. Why is mem_cgroup_threshold() intere=
sted in root
> > > > > > > > > memcg usage? Why not ignore root memcg in mem_cgroup_thre=
shold() ?
> > > > > > > >
> > > > > > > > I am not sure, but the code looks like event notifications =
may be set
> > > > > > > > up on root memcg, which is why we need to check thresholds.
> > > > > > >
> > > > > > > This is something we should deprecate as root memcg's usage i=
s ill defined.
> > > > > >
> > > > > > Right, but I think this would be orthogonal to this patch serie=
s.
> > > > > >
> > > > >
> > > > > I don't think we can make cgroup_rstat_lock a non-irq-disabling l=
ock
> > > > > without either breaking a link between mem_cgroup_threshold and
> > > > > cgroup_rstat_lock or make mem_cgroup_threshold work without disab=
ling
> > > > > irqs.
> > > > >
> > > > > So, this patch can not be applied before either of those two task=
s are
> > > > > done (and we may find more such scenarios).
> > > >
> > > >
> > > > Could you elaborate why?
> > > >
> > > > My understanding is that with an in_task() check to make sure we on=
ly
> > > > acquire cgroup_rstat_lock from non-irq context it should be fine to
> > > > acquire cgroup_rstat_lock without disabling interrupts.
> > >
> > > From mem_cgroup_threshold() code path, cgroup_rstat_lock will be take=
n
> > > with irq disabled while other code paths will take cgroup_rstat_lock
> > > with irq enabled. This is a potential deadlock hazard unless
> > > cgroup_rstat_lock is always taken with irq disabled.
> >
> > Oh you are making sure it is not taken in the irq context through
> > should_skip_flush(). Hmm seems like a hack. Normally it is recommended
> > to actually remove all such users instead of silently
> > ignoring/bypassing the functionality.
>
> It is a workaround, we simply accept to read stale stats in irq
> context instead of the expensive flush operation.
>
> >
> > So, how about removing mem_cgroup_flush_stats() from
> > mem_cgroup_usage(). It will break the known chain which is taking
> > cgroup_rstat_lock with irq disabled and you can add
> > WARN_ON_ONCE(!in_task()).
>
> This changes the behavior in a more obvious way because:
> 1. The memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage()
> path is also exercised in a lot of paths outside irq context, this
> will change the behavior for any event thresholds on the root memcg.
> With proposed skipped flushing in irq context we only change the
> behavior in a small subset of cases.
>
> I think we can skip flushing in irq context for now, and separately
> deprecate threshold events for the root memcg. When that is done we
> can come back and remove should_skip_flush() and add a VM_BUG_ON or
> WARN_ON_ONCE instead. WDYT?
>
> 2. mem_cgroup_usage() is also used when reading usage from userspace.
> This should be an easy workaround though.

This is a cgroup v1 behavior and to me it is totally reasonable to get
the 2 second stale root's usage. Even if you want to skip flushing in
irq, do that in the memcg code and keep VM_BUG_ON/WARN_ON_ONCE in the
rstat core code. This way we will know if other subsystems are doing
the same or not.

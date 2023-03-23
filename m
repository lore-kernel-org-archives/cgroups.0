From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 09:09:49 -0700
Message-ID: <CALvZod7-6F84POkNetA2XJB-24wms=5q_s495NEthO8b63rL4A@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
 <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
 <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
 <CAJD7tkYWo_aB7a4SHXNQDHwcaTELonOk_Vd8q0=x8vwGy2VkYg@mail.gmail.com> <CALvZod7f9Rejb_WrZ+Ajegz-NsQ7iPQegRDMdk5Ya0a0w=40kg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679587801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgZMEf1PHFMinoIbPEomXcwtNzt8eUFNPvTXJsCn0P8=;
        b=k5dpDN1DHcGjTlwbOvMKLMRzGlnzZn29V1PdhQ9swzOTalJXOVLnQWZ41YtSQ6iUrk
         3tYVVzf3TXbBDU3Fht0rRrJX5GujygwDq4CznsLvQvc3iwlzWZ7RjrlJRpn6zm+LX6Is
         wg3xRL0pVLcK4/WUOQciLucr4KsYng/0RiN3fJUrGmHZTbbYLdyI+Mxa6fi3ob6cRFNq
         8SpTkAvVF4xMY6kgvEFxHg+HMcX5zbBQrAgc5RP417XZQXgpltBfUeyhzDW4y/NM+4Qd
         L5xz9jZ+0DhO8BpAwodd5of1IQ/G/KeTFSQm8YwjDJLsC/QfhlZPdbgvRtQ21H8E1ZYK
         ce/w==
In-Reply-To: <CALvZod7f9Rejb_WrZ+Ajegz-NsQ7iPQegRDMdk5Ya0a0w=40kg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 8:46=E2=80=AFAM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Thu, Mar 23, 2023 at 8:43=E2=80=AFAM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> > On Thu, Mar 23, 2023 at 8:40=E2=80=AFAM Shakeel Butt <shakeelb@google.c=
om> wrote:
> > >
> > > On Thu, Mar 23, 2023 at 6:36=E2=80=AFAM Yosry Ahmed <yosryahmed@googl=
e.com> wrote:
> > > >
> > > [...]
> > > > > >
> > > > > > > 2. Are we really calling rstat flush in irq context?
> > > > > >
> > > > > > I think it is possible through the charge/uncharge path:
> > > > > > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(=
). I
> > > > > > added the protection against flushing in an interrupt context f=
or
> > > > > > future callers as well, as it may cause a deadlock if we don't =
disable
> > > > > > interrupts when acquiring cgroup_rstat_lock.
> > > > > >
> > > > > > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is=
 only
> > > > > > > done for root memcg. Why is mem_cgroup_threshold() interested=
 in root
> > > > > > > memcg usage? Why not ignore root memcg in mem_cgroup_threshol=
d() ?
> > > > > >
> > > > > > I am not sure, but the code looks like event notifications may =
be set
> > > > > > up on root memcg, which is why we need to check thresholds.
> > > > >
> > > > > This is something we should deprecate as root memcg's usage is il=
l defined.
> > > >
> > > > Right, but I think this would be orthogonal to this patch series.
> > > >
> > >
> > > I don't think we can make cgroup_rstat_lock a non-irq-disabling lock
> > > without either breaking a link between mem_cgroup_threshold and
> > > cgroup_rstat_lock or make mem_cgroup_threshold work without disabling
> > > irqs.
> > >
> > > So, this patch can not be applied before either of those two tasks ar=
e
> > > done (and we may find more such scenarios).
> >
> >
> > Could you elaborate why?
> >
> > My understanding is that with an in_task() check to make sure we only
> > acquire cgroup_rstat_lock from non-irq context it should be fine to
> > acquire cgroup_rstat_lock without disabling interrupts.
>
> From mem_cgroup_threshold() code path, cgroup_rstat_lock will be taken
> with irq disabled while other code paths will take cgroup_rstat_lock
> with irq enabled. This is a potential deadlock hazard unless
> cgroup_rstat_lock is always taken with irq disabled.

Oh you are making sure it is not taken in the irq context through
should_skip_flush(). Hmm seems like a hack. Normally it is recommended
to actually remove all such users instead of silently
ignoring/bypassing the functionality.

So, how about removing mem_cgroup_flush_stats() from
mem_cgroup_usage(). It will break the known chain which is taking
cgroup_rstat_lock with irq disabled and you can add
WARN_ON_ONCE(!in_task()).

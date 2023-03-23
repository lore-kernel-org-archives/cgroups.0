From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 08:42:50 -0700
Message-ID: <CAJD7tkYWo_aB7a4SHXNQDHwcaTELonOk_Vd8q0=x8vwGy2VkYg@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
 <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com> <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679586206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JR2t4YEAW/CeRYBS44zjBzatYGFGxBDqwLzXBK2rHQc=;
        b=mjV7iSriIwiO4+OfpDMCFGcMkE5baHrwNE3TxMhHuupoe7OY5sfpUjIAy9jfp0juHN
         /pXhTYEnznjOfzDEqepJdt682v9BCC3QD5/z3V3o+1LaxE4L8waApaTX8wJ0DLHuCpII
         k9D7Z/AW+t2hRm1js+bKTn9Ps7eJZKjX3oZRYHwev3rdVkR+l/zjwObTS8Hu7LHCLXXt
         GK1DiCG0DGQFtztUSWl6VpgCJRN8gYfMtzlsiBiMTdiYgtbvmU5ZLr0VxZ5SUC/Zd1av
         Ui902c+TDYhTFVkYsIXT6QTpRsMe43dC5CgPmaZMI7h/Y7guI1At2tAXKjXucHeU3gy3
         g39Q==
In-Reply-To: <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 8:40=E2=80=AFAM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Thu, Mar 23, 2023 at 6:36=E2=80=AFAM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> [...]
> > > >
> > > > > 2. Are we really calling rstat flush in irq context?
> > > >
> > > > I think it is possible through the charge/uncharge path:
> > > > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(). I
> > > > added the protection against flushing in an interrupt context for
> > > > future callers as well, as it may cause a deadlock if we don't disa=
ble
> > > > interrupts when acquiring cgroup_rstat_lock.
> > > >
> > > > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is onl=
y
> > > > > done for root memcg. Why is mem_cgroup_threshold() interested in =
root
> > > > > memcg usage? Why not ignore root memcg in mem_cgroup_threshold() =
?
> > > >
> > > > I am not sure, but the code looks like event notifications may be s=
et
> > > > up on root memcg, which is why we need to check thresholds.
> > >
> > > This is something we should deprecate as root memcg's usage is ill de=
fined.
> >
> > Right, but I think this would be orthogonal to this patch series.
> >
>
> I don't think we can make cgroup_rstat_lock a non-irq-disabling lock
> without either breaking a link between mem_cgroup_threshold and
> cgroup_rstat_lock or make mem_cgroup_threshold work without disabling
> irqs.
>
> So, this patch can not be applied before either of those two tasks are
> done (and we may find more such scenarios).


Could you elaborate why?

My understanding is that with an in_task() check to make sure we only
acquire cgroup_rstat_lock from non-irq context it should be fine to
acquire cgroup_rstat_lock without disabling interrupts.

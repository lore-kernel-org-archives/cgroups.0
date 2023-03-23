From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 22 Mar 2023 23:33:46 -0700
Message-ID: <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679553238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4npRT0ZBm4ONH6zdpwhBbu8AXu0dsqmRu8iUAcRhwn4=;
        b=Jz1+PRu0n2E15Vf/qVjLQyMAiMh0wcsZxyHdXjjLSylh8kOTYeud4m+r7TyiYDDIwY
         AxsoBwLqHysKwhK8ZhCrxd++CTHeifnZx2H/a7f6897A8184FcTnA8nkSly0zpDgPi8l
         TKdXhZ2aJZmAatpzBOs+lBb7LUlbNYb+axNHN1pnyDXlerc97Ur9a03S8UXOF+Zd74k4
         gqkj6iLTsEnSJQbd2l4qo+JewrHaebREOudXM1ZFKVj+/O7sw5rZ7K4qyVJ/GRsIz6X7
         YYb2KoWhc8MlSNAC5BHhIQEHo2dus1NCcP6Sq5RMpw3G+MhaBbrd5GDjSKW2etMYFYuA
         FiEw==
In-Reply-To: <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 22, 2023 at 10:15=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>
[...]
> > Couple of questions:
> >
> > 1. What exactly is cgroup_rstat_lock protecting? Can we just remove it
> > altogether?
>
> I believe it protects the global state variables that we flush into.
> For example, for memcg, it protects mem_cgroup->vmstats.
>
> I tried removing the lock and allowing concurrent flushing on
> different cpus, by changing mem_cgroup->vmstats to use atomics
> instead, but that turned out to be a little expensive. Also,
> cgroup_rstat_lock is already contended by different flushers
> (mitigated by stats_flush_lock on the memcg side). If we remove it,
> concurrent flushers contend on every single percpu lock instead, which
> also seems to be expensive.

We should add a comment on what it is protecting. I think block rstat
are fine but memcg and bpf would need this.

>
> > 2. Are we really calling rstat flush in irq context?
>
> I think it is possible through the charge/uncharge path:
> memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(). I
> added the protection against flushing in an interrupt context for
> future callers as well, as it may cause a deadlock if we don't disable
> interrupts when acquiring cgroup_rstat_lock.
>
> > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is only
> > done for root memcg. Why is mem_cgroup_threshold() interested in root
> > memcg usage? Why not ignore root memcg in mem_cgroup_threshold() ?
>
> I am not sure, but the code looks like event notifications may be set
> up on root memcg, which is why we need to check thresholds.

This is something we should deprecate as root memcg's usage is ill defined.

>
> Even if mem_cgroup_threshold() does not flush memcg stats, the purpose
> of this patch is to make sure the rstat flushing code itself is not
> disabling interrupts; which it currently does for any unsleepable
> context, even if it is interruptible.

Basically I am saying we should aim for VM_BUG_ON(!in_task()) in the
flush function rather than adding should_skip_flush() which does not
stop potential new irq flushers.

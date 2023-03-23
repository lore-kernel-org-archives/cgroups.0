From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 08:40:29 -0700
Message-ID: <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com> <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679586041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXqZ3IJA77cnf/fukJT6xyyWj+RxTe/4tMZOB+1mbkQ=;
        b=pZto6I+vvxaphKg4Ca9NDWCYEUNhj7BJYmHfaAG8M51g5rBMERT2pTxw32czJVRwqf
         EXpqwyXIM77qAJ204++TM8DrNrSWXsJyryfpkiZaymGsJv+mhNCo+v4QMcuWklOwQ1zb
         14XunBWOhtBzzFTiU3Gj8RFDbfEQ4MSASypSDfsLzNrh14XAxfBwpnKQD7EnPJaTeklc
         QpjEu0BIrsjS593Tol8303VAwfsZeO1qSu7wHKzhAJW4G9NFMuqTCi3YV8xqFEcXgHrN
         7FMdZFQg1MqDPNCzODUn974BlGYh8gXmdMD2HE3tXqWplxkq95RhThaIWYkoMKBBBJ0Y
         EGwA==
In-Reply-To: <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 6:36=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
[...]
> > >
> > > > 2. Are we really calling rstat flush in irq context?
> > >
> > > I think it is possible through the charge/uncharge path:
> > > memcg_check_events()->mem_cgroup_threshold()->mem_cgroup_usage(). I
> > > added the protection against flushing in an interrupt context for
> > > future callers as well, as it may cause a deadlock if we don't disabl=
e
> > > interrupts when acquiring cgroup_rstat_lock.
> > >
> > > > 3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is only
> > > > done for root memcg. Why is mem_cgroup_threshold() interested in ro=
ot
> > > > memcg usage? Why not ignore root memcg in mem_cgroup_threshold() ?
> > >
> > > I am not sure, but the code looks like event notifications may be set
> > > up on root memcg, which is why we need to check thresholds.
> >
> > This is something we should deprecate as root memcg's usage is ill defi=
ned.
>
> Right, but I think this would be orthogonal to this patch series.
>

I don't think we can make cgroup_rstat_lock a non-irq-disabling lock
without either breaking a link between mem_cgroup_threshold and
cgroup_rstat_lock or make mem_cgroup_threshold work without disabling
irqs.

So, this patch can not be applied before either of those two tasks are
done (and we may find more such scenarios).

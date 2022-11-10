From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in memory.reclaim
Date: Thu, 10 Nov 2022 11:45:19 -0800
Message-ID: <CAJD7tkY227nVROVAntzkxsddrfRQ_yqVC3oQydsux-OUrM840A@mail.gmail.com>
References: <20221110065316.67204-1-lujialin4@huawei.com> <20221110144243.GA10562@blackbody.suse.cz>
 <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGo0fE0YRyisie71iUpJssOr+2esv7uUzO4ILEWpRC4=;
        b=DDzS8KVhTiFwp8F/65P3SFU6UQ0Vr4CjeM6CQTVvw2FR6lUG0/FmOg93rI/PSO0eVq
         //x6kbPsLQYYC6/JjzTRuKM/Fhiw6505rlZ3NpGBas4V/8HBtm9iJc5iPUgJHt5MBwMf
         fLO3IqmyjP7Ix6skaJN/R3rjizAok3aZpaZlmGd7qlAlgKOsPeldbQPeFdK8VzQi/kYk
         8vx1jfZlgorCGpGXb6tEhNjcIknlDUsmesQGNYgKwCbFH+cmFsH/mXvWZddJXI3/8zk2
         hJ0Wj6Bc064xI85aiNAeBJImABplCU0CjDQUKn5bUc5y/BKQJt7uLXNglc7JPnPeSXWa
         BVAA==
In-Reply-To: <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Nov 10, 2022 at 11:35 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Nov 10, 2022 at 6:42 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wro=
te:
> >
> > Hello Jialin.
> >
> > On Thu, Nov 10, 2022 at 02:53:16PM +0800, Lu Jialin <lujialin4@huawei.c=
om> wrote:
> > > When user use memory.reclaim to reclaim memory, after drain percpu lr=
u
> > > caches, drain percpu charge caches for given memcg stock in the hope
> > > of introducing more evictable pages.
> >
> > Do you have any data on materialization of this hope?
> >
> > IIUC, the stock is useful for batched accounting to page_counter but it
> > doesn't represent real pages. I.e. your change may reduce the
> > page_counter value but it would not release any pages. Or have I missed
> > a way how it helps with the reclaim?
>
> +1
>
> It looks like we just overcharge the memcg if the number of allocated
> pages are less than the charging batch size, so that upcoming
> allocations can go through a fast accounting path and consume from the
> precharged stock. I don't understand how draining this charge may help
> reclaim.
>
> OTOH, it will reduce the page counters, so if userspace is relying on
> memory.current to gauge how much reclaim they want to do, it will make
> it "appear" like the usage dropped. If userspace is using other
> signals (refaults, PSI, etc), then we would be more-or-less tricking
> it into thinking we reclaimed pages when we actually didn't. In that
> case we didn't really reclaim anything, we just dropped memory.current
> slightly, which wouldn't matter to the user in this case, as other
> signals won't change.

In fact, we wouldn't be tricking anyone because this will have no
effect on the return value of memory.reclaim. We would just be causing
a side effect of very slightly reducing memory.current. Not sure if
this really helps.

>
> The difference in perceived usage coming from draining the stock IIUC
> has an upper bound of 63 * PAGE_SIZE (< 256 KB with 4KB pages), I
> wonder if this is really significant anyway.
>
> >
> > Thanks,
> > Michal

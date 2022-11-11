From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in memory.reclaim
Date: Fri, 11 Nov 2022 10:24:02 -0800
Message-ID: <CAJD7tkYWvR+2o==-R38hDBEM=k=2bta9kKRND3wxDLF1pWbp6A@mail.gmail.com>
References: <20221110065316.67204-1-lujialin4@huawei.com> <20221110144243.GA10562@blackbody.suse.cz>
 <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g@mail.gmail.com> <20221111100843.GG20455@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFgOYEQ6NOhR14F+o1liXDfDhEK9cBQJ7rg815eUQn8=;
        b=N6wKqF8yyEt+Eo6I+YHl1q4P0AiwetFsOZQGEI+Xq9xFJz0aQPV1YS8smiPR5fq8tw
         8HGxIaRNTcgdsULpAgSBfAUzKw8X+BuKmgrdfJVjEZQA+daVSKvyPziVjoG3BnbNalFi
         KI0TIyRwmMMher+y15JVLg9Z8qiY8H+LIcipf2u8ithG+kYyKO9EdAXW06OY0nd5SzgF
         UlIuOHYW0oFo0Bc3iS6P5+JiFMwHDodZekYcXrSE8DGpNm3CHtc4jK7j1WlV1VJRrUYG
         77YuD/S6xG4OWiHiPDMxXwbDs/+4RHBwiRn22XPv7C7r5aBO6sac4kB+aRprIyoHee8Z
         isaA==
In-Reply-To: <20221111100843.GG20455-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Nov 11, 2022 at 2:08 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Thu, Nov 10, 2022 at 11:35:34AM -0800, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > OTOH, it will reduce the page counters, so if userspace is relying on
> > memory.current to gauge how much reclaim they want to do, it will make
> > it "appear" like the usage dropped.
>
> Assuming memory.current is used to drive the proactive reclaim, then
> this patch makes some sense (and is slightly better than draining upon
> every memory.current read(2)).

I am not sure honestly. This assumes memory.reclaim is used in
response to just memory.current, which is not true in the cases I know
about at least.

If you are using memory.reclaim merely based on memory.current, to
keep the usage below a specified number, then memory.high might be a
better fit? Unless this goal usage is a moving target maybe and you
don't want to keep changing the limits but I don't know if there are
practical use cases for this.

For us at Google, we don't really look at the current usage, but
rather on how much of the current usage we consider "cold" based on
page access bit harvesting. I suspect Meta is doing something similar
using different mechanics (PSI). I am not sure if memory.current is a
factor in either of those use cases, but maybe I am missing something
obvious.

>
> I just think the commit message should explain the real mechanics of
> this.
>
> > The difference in perceived usage coming from draining the stock IIUC
> > has an upper bound of 63 * PAGE_SIZE (< 256 KB with 4KB pages), I
> > wonder if this is really significant anyway.
>
> times nr_cpus (if memcg had stocks all over the place).

Right. In my mind I assumed the memcg would only be stocked on one cpu
for some reason.

>
> Michal

From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 08:41:34 +0100
Message-ID: <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674718895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mncfe4kJe4t7mpaj+aaMpUVysMSI3MXidyK6ywAzmc0=;
        b=UL/28di24psjPcStaP7/ABTZSBwBaZupgJJ4DSVAM8SvNGREBi1UxcQo4kxQu5V3ZGxb/7
        Ei7mT7wBbYdb4meO0r0bNG1opKAjusHwBxdas9X+gGIjnoIzyVR2Nh0wuaSJ0rT4jArO/G
        MqUFVoKMoss3rxA7mQ4/uxLXF8J05DM=
Content-Disposition: inline
In-Reply-To: <Y9G36AiqPPFDlax3-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > Disclaimer:
> > > > > a - The cover letter got bigger than expected, so I had to split =
it in
> > > > >     sections to better organize myself. I am not very confortable=
 with it.
> > > > > b - Performance numbers below did not include patch 5/5 (Remove f=
lags
> > > > >     from memcg_stock_pcp), which could further improve performanc=
e for
> > > > >     drain_all_stock(), but I could only notice the optimization a=
t the
> > > > >     last minute.
> > > > >=20
> > > > >=20
> > > > > 0 - Motivation:
> > > > > On current codebase, when drain_all_stock() is ran, it will sched=
ule a
> > > > > drain_local_stock() for each cpu that has a percpu stock associat=
ed with a
> > > > > descendant of a given root_memcg.
>=20
> Do you know what caused those drain_all_stock() calls? I wonder if we sho=
uld look
> into why we have many of them and whether we really need them?
>=20
> It's either some user's actions (e.g. reducing memory.max), either some m=
emcg
> is entering pre-oom conditions. In the latter case a lot of drain calls c=
an be
> scheduled without a good reason (assuming the cgroup contain multiple tas=
ks running
> on multiple cpus).

I believe I've never got a specific answer to that. We
have discussed that in the previous version submission
(20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org an=
d specifically
Y2TQLavnLVd4qHMT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org). Leonardo has men=
tioned a mix of RT and
isolcpus. I was wondering about using memcgs in RT workloads because
that just sounds weird but let's say this is the case indeed. Then an RT
task or whatever task that is running on an isolated cpu can have pcp
charges.

> Essentially each cpu will try to grab the remains of the memory quota
> and move it locally. I wonder in such circumstances if we need to disable=
 the pcp-caching
> on per-cgroup basis.

I think it would be more than sufficient to disable pcp charging on an
isolated cpu. This is not a per memcg property. I can imagine that
different tasks running in the same memcg can run on a mix of CPUs (e.g.
only part of it on isolated CPUs). It is a recipe for all sorts of
priority inversions but well, memcg and RT is there already.

> Generally speaking, draining of pcpu stocks is useful only if an idle cpu=
 is holding some
> charges/memcg references (it might be not completely idle, but running so=
me very special
> workload which is not doing any kernel allocations or a process belonging=
 to the root memcg).
> In all other cases pcpu stock will be either drained naturally by an allo=
cation from another
> memcg or an allocation from the same memcg will "restore" it, making drai=
ning useless.
>=20
> We also can into drain_all_pages() opportunistically, without waiting for=
 the result.
> On a busy system it's most likely useless, we might oom before scheduled =
works will be executed.

I think the primary objective is that no userspace unintended execution
happens on isolated cpus.
=20
> I admit I planned to do some work around and even started, but then never=
 had enough time to
> finish it.
>=20
> Overall I'm somewhat resistant to an idea of making generic allocation & =
free paths slower
> for an improvement of stock draining. It's not a strong objection, but IM=
O we should avoid
> doing this without a really strong reason.

Are you OK with a simple opt out on isolated CPUs? That would make
charges slightly slower (atomic on the hierarchy counters vs. a single
pcp adjustment) but it would guarantee that the isolated workload is
predictable which is the primary objective AFAICS.
--=20
Michal Hocko
SUSE Labs

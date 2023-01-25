From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 25 Jan 2023 15:14:48 -0800
Message-ID: <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674688503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQas9hJPH93Zr57s1dcc7T+g336s2ZkXNkxopiNZy5Y=;
        b=L++sVVFKgB2QgSfUln8N4pW6K99/uC71K7MHO0eTNd2gOjxQp1AktmI+V60pLnLZKq6KFC
        hACk9uz3DsoIitBsOXZt7BIu60/uMI/JLjE4PEEUb0PdbUDFsVn25UofpY3G6aCVyuS6ma
        52wkIVgDt+qNHn0YlWdzI9qQ/UE4CgA=
Content-Disposition: inline
In-Reply-To: <Y9FzSBw10MGXm2TK@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > Disclaimer:
> > > > a - The cover letter got bigger than expected, so I had to split it=
 in
> > > >     sections to better organize myself. I am not very confortable w=
ith it.
> > > > b - Performance numbers below did not include patch 5/5 (Remove fla=
gs
> > > >     from memcg_stock_pcp), which could further improve performance =
for
> > > >     drain_all_stock(), but I could only notice the optimization at =
the
> > > >     last minute.
> > > >=20
> > > >=20
> > > > 0 - Motivation:
> > > > On current codebase, when drain_all_stock() is ran, it will schedul=
e a
> > > > drain_local_stock() for each cpu that has a percpu stock associated=
 with a
> > > > descendant of a given root_memcg.

Do you know what caused those drain_all_stock() calls? I wonder if we shoul=
d look
into why we have many of them and whether we really need them?

It's either some user's actions (e.g. reducing memory.max), either some mem=
cg
is entering pre-oom conditions. In the latter case a lot of drain calls can=
 be
scheduled without a good reason (assuming the cgroup contain multiple tasks=
 running
on multiple cpus). Essentially each cpu will try to grab the remains of the=
 memory quota
and move it locally. I wonder in such circumstances if we need to disable t=
he pcp-caching
on per-cgroup basis.

Generally speaking, draining of pcpu stocks is useful only if an idle cpu i=
s holding some
charges/memcg references (it might be not completely idle, but running some=
 very special
workload which is not doing any kernel allocations or a process belonging t=
o the root memcg).
In all other cases pcpu stock will be either drained naturally by an alloca=
tion from another
memcg or an allocation from the same memcg will "restore" it, making draini=
ng useless.

We also can into drain_all_pages() opportunistically, without waiting for t=
he result.
On a busy system it's most likely useless, we might oom before scheduled wo=
rks will be executed.

I admit I planned to do some work around and even started, but then never h=
ad enough time to
finish it.

Overall I'm somewhat resistant to an idea of making generic allocation & fr=
ee paths slower
for an improvement of stock draining. It's not a strong objection, but IMO =
we should avoid
doing this without a really strong reason.

Thanks!

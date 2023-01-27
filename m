From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 07:58:32 +0100
Message-ID: <Y9N2GC9Vk2k68Svs@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9LAf4pRyClZ1vfx@tpad>
 <Y9LSjnNEEUiF/70R@dhcp22.suse.cz>
 <Y9MbkuBDI+08AtgN@tpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674802714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+E5xBJ3UOLpBqu7Q/7w5cQuQLqZh3v0sZZi4etorHM=;
        b=YGGNoTNQSsBG2crAEEf577da9ZlMzCQfCzd1kLQO55iHcOKNihErXr7ZcEAiMcI3Nhh4OP
        Po3w6eO0WJ6HNVdNfx5oWkuZax3loRjgY6iHwTSCaqhEVGvHYBknYbOSpV4VkJ4h2CvyAp
        V4rM4uxPXKoxjeLA7/drrCxbfEz8Wb4=
Content-Disposition: inline
In-Reply-To: <Y9MbkuBDI+08AtgN@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 26-01-23 21:32:18, Marcelo Tosatti wrote:
> On Thu, Jan 26, 2023 at 08:20:46PM +0100, Michal Hocko wrote:
> > On Thu 26-01-23 15:03:43, Marcelo Tosatti wrote:
> > > On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> > > > On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > > > > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > > > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > > > > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > > > > Disclaimer:
> > > > > > > > > a - The cover letter got bigger than expected, so I had t=
o split it in
> > > > > > > > >     sections to better organize myself. I am not very con=
fortable with it.
> > > > > > > > > b - Performance numbers below did not include patch 5/5 (=
Remove flags
> > > > > > > > >     from memcg_stock_pcp), which could further improve pe=
rformance for
> > > > > > > > >     drain_all_stock(), but I could only notice the optimi=
zation at the
> > > > > > > > >     last minute.
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > 0 - Motivation:
> > > > > > > > > On current codebase, when drain_all_stock() is ran, it wi=
ll schedule a
> > > > > > > > > drain_local_stock() for each cpu that has a percpu stock =
associated with a
> > > > > > > > > descendant of a given root_memcg.
> > > > >=20
> > > > > Do you know what caused those drain_all_stock() calls? I wonder i=
f we should look
> > > > > into why we have many of them and whether we really need them?
> > > > >=20
> > > > > It's either some user's actions (e.g. reducing memory.max), eithe=
r some memcg
> > > > > is entering pre-oom conditions. In the latter case a lot of drain=
 calls can be
> > > > > scheduled without a good reason (assuming the cgroup contain mult=
iple tasks running
> > > > > on multiple cpus).
> > > >=20
> > > > I believe I've never got a specific answer to that. We
> > > > have discussed that in the previous version submission
> > > > (20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gman=
e.org and specifically
> > > > Y2TQLavnLVd4qHMT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org). Leonardo=
 has mentioned a mix of RT and
> > > > isolcpus. I was wondering about using memcgs in RT workloads because
> > > > that just sounds weird but let's say this is the case indeed.=20
> > >=20
> > > This could be the case. You can consider an "edge device" where it is
> > > necessary to run a RT workload. It might also be useful to run=20
> > > non realtime applications on the same system.
> > >=20
> > > > Then an RT task or whatever task that is running on an isolated
> > > > cpu can have pcp charges.
> > >=20
> > > Usually the RT task (or more specifically the realtime sensitive loop
> > > of the application) runs entirely on userspace. But i suppose there
> > > could be charges on application startup.
> >=20
> > What is the role of memcg then? If the memory limit is in place and the
> > workload doesn't fit in then it will get reclaimed during start up and
> > memory would need to be refaulted if not mlocked. If it is mlocked then
> > the limit cannot be enforced and the start up would likely fail as a
> > result of the memcg oom killer.
>=20
> 1) Application which is not time sensitive executes on isolated CPU,
> with memcg control enabled. Per-CPU stock is created.
>=20
> 2) App with memcg control enabled exits, per-CPU stock is not drained.
>=20
> 3) Latency sensitive application starts, isolated per-CPU has stock to
> be drained, and:
>=20
> /*
>  * Drains all per-CPU charge caches for given root_memcg resp. subtree
>  * of the hierarchy under it.
>  */
> static void drain_all_stock(struct mem_cgroup *root_memcg)

No, this is not really answering my question. See
Y9LQ615H13RmG7wL-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org which already expl=
ains how the draining
would be triggered. This is not really happening on any operation.

I am really asking for specific workloads which are running multiple
processes on a mix of isolated and non-isolated cpus yet they share
memcg so that they can interfere. The consequences of the common memcg
are described above.
--=20
Michal Hocko
SUSE Labs

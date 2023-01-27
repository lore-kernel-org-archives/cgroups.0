From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 02:40:28 -0300
Message-ID: <9ec001ba093e21a5ac2cafa1c61810b035daf13d.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
         <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
         <Y9FzSBw10MGXm2TK@tpad> <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
         <Y9LEQfX5dkEyBOkT@tpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674798037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/nlRzFE8uEH2KN6NvFa3jRsSiNKHTj9vX5XMb/Z35s=;
        b=ILXIu9UM7b2eDQzZS7j2WgAidEvgP1FAecA2fF7pSG/gA4M3lesvYdgeaUt+6qmbJPB98H
        m9zgrpr4cqg/OkN/3tGKVO6jtQ6PLnmENCP7laJMUyRcTkAvVzxwpGKDYLxoN3PG4Bfx+w
        AdUU8CtQ2y53+I/1jX/VW2G6Ld/+J+A=
In-Reply-To: <Y9LEQfX5dkEyBOkT@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2023-01-26 at 15:19 -0300, Marcelo Tosatti wrote:
> On Wed, Jan 25, 2023 at 03:14:48PM -0800, Roman Gushchin wrote:
> > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=C3=A1s wrote:
> > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > Disclaimer:
> > > > > > a - The cover letter got bigger than expected, so I had to spli=
t it in
> > > > > >     sections to better organize myself. I am not very confortab=
le with it.
> > > > > > b - Performance numbers below did not include patch 5/5 (Remove=
 flags
> > > > > >     from memcg_stock_pcp), which could further improve performa=
nce for
> > > > > >     drain_all_stock(), but I could only notice the optimization=
 at the
> > > > > >     last minute.
> > > > > >=20
> > > > > >=20
> > > > > > 0 - Motivation:
> > > > > > On current codebase, when drain_all_stock() is ran, it will sch=
edule a
> > > > > > drain_local_stock() for each cpu that has a percpu stock associ=
ated with a
> > > > > > descendant of a given root_memcg.
> >=20
> > Do you know what caused those drain_all_stock() calls? I wonder if we s=
hould look
> > into why we have many of them and whether we really need them?
> >=20
> > It's either some user's actions (e.g. reducing memory.max), either some=
 memcg
> > is entering pre-oom conditions. In the latter case a lot of drain calls=
 can be
> > scheduled without a good reason (assuming the cgroup contain multiple t=
asks running
> > on multiple cpus). Essentially each cpu will try to grab the remains of=
 the memory quota
> > and move it locally. I wonder in such circumstances if we need to disab=
le the pcp-caching
> > on per-cgroup basis.
> >=20
> > Generally speaking, draining of pcpu stocks is useful only if an idle c=
pu is holding some
> > charges/memcg references (it might be not completely idle, but running =
some very special
> > workload which is not doing any kernel allocations or a process belongi=
ng to the root memcg).
> > In all other cases pcpu stock will be either drained naturally by an al=
location from another
> > memcg or an allocation from the same memcg will "restore" it, making dr=
aining useless.
> >=20
> > We also can into drain_all_pages() opportunistically, without waiting f=
or the result.
> > On a busy system it's most likely useless, we might oom before schedule=
d works will be executed.
> >=20
> > I admit I planned to do some work around and even started, but then nev=
er had enough time to
> > finish it.
> >=20
> > Overall I'm somewhat resistant to an idea of making generic allocation =
& free paths slower
> > for an improvement of stock draining. It's not a strong objection, but =
IMO we should avoid
> > doing this without a really strong reason.
>=20
> The expectation would be that cache locking should not cause slowdown of
> the allocation and free paths:
>=20
> https://manualsbrain.com/en/manuals/1246877/?page=3D313
>=20
> For the P6 and more recent processor families, if the area of memory bein=
g locked=20
> during a LOCK operation is cached in the processor that is performing the=
 LOCK oper-
> ation as write-back memory and is completely contained in a cache line, t=
he=20
> processor may not assert the LOCK# signal on the bus. Instead, it will mo=
dify the=20
> memory location internally and allow it=E2=80=99s cache coherency mechani=
sm to insure that=20
> the operation is carried out atomically. This operation is called =E2=80=
=9Ccache locking.=E2=80=9D The=20
> cache coherency mechanism automatically prevents two or more processors t=
hat ...
>=20
>=20

Just to keep the info easily available: the protected structure (struct
memcg_stock_pcp) fits in 48 Bytes, which is less than the usual 64B cacheli=
ne.=20

struct memcg_stock_pcp {
	spinlock_t                 stock_lock;           /*     0     4 */
	unsigned int               nr_pages;             /*     4     4 */
	struct mem_cgroup *        cached;               /*     8     8 */
	struct obj_cgroup *        cached_objcg;         /*    16     8 */
	struct pglist_data *       cached_pgdat;         /*    24     8 */
	unsigned int               nr_bytes;             /*    32     4 */
	int                        nr_slab_reclaimable_b; /*    36     4 */
	int                        nr_slab_unreclaimable_b; /*    40     4 */

	/* size: 48, cachelines: 1, members: 8 */
	/* padding: 4 */
	/* last cacheline: 48 bytes */
};

(It got smaller after patches 3/5, 4/5 and 5/5, which remove holes, work_st=
ruct
and flags respectively.)

On top of that, patch 1/5 makes sure the percpu allocation is aligned to
cacheline size.


From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 15:12:35 -0800
Message-ID: <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674774772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n7M1bfJLC4Rcsy/Y/usaqBvuQAjlpdOFXty5eUdj7PU=;
        b=paF0N/iKfvlcN9yEEM/b2TNNUDXisDdGcz0WAIRf6cjejS0WzLPSni7TNGvbneMeKyzDyj
        Lebr5WBZ2hHo/G7w6N+e4AuL7TZD6obbBxM+8Sp8zk0464GNq3oxk2qH50NdUF/jGCuI0o
        X0rTkDGfQwBBfQ8Dxmnb/f/xbQMWc8E=
Content-Disposition: inline
In-Reply-To: <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
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
> > on multiple cpus).
>=20
> I believe I've never got a specific answer to that. We
> have discussed that in the previous version submission
> (20221102020243.522358-1-leobras@redhat.com and specifically
> Y2TQLavnLVd4qHMT@dhcp22.suse.cz). Leonardo has mentioned a mix of RT and
> isolcpus. I was wondering about using memcgs in RT workloads because
> that just sounds weird but let's say this is the case indeed. Then an RT
> task or whatever task that is running on an isolated cpu can have pcp
> charges.
>=20
> > Essentially each cpu will try to grab the remains of the memory quota
> > and move it locally. I wonder in such circumstances if we need to disab=
le the pcp-caching
> > on per-cgroup basis.
>=20
> I think it would be more than sufficient to disable pcp charging on an
> isolated cpu.

It might have significant performance consequences.

I'd rather opt out of stock draining for isolated cpus: it might slightly r=
educe
the accuracy of memory limits and slightly increase the memory footprint (a=
ll
those dying memcgs...), but the impact will be limited. Actually it is limi=
ted
by the number of cpus.

> This is not a per memcg property.

Sure, my point was that in pre-oom condition several cpus might try to cons=
olidate
the remains of the memory quota, actually working against each other. Separ=
ate issue,
which might be a reason why there are many flush attempts in the case we di=
scuss.

Thanks!

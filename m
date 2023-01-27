From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 04:14:19 -0300
Message-ID: <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
         <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
         <Y9FzSBw10MGXm2TK@tpad> <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
         <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
         <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674803667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3zXC7BLShJSQz17R47PyiKfOUcoTGd7uBIuLuInT94=;
        b=Exdep1Wa2Ck3OmA0XXSGuwxFkYTUEcpptbmHLDUSxhaaL/ZNTggQ6vcjBGnJ0M44++kgV6
        mbiwdl8r45B057Y6fUESCUAB6DieF6r0OBoHCsoozsJQ1C9m9WPmjpMTtRAFOsOHLz+Z8l
        7YcjpyUVr8Fh8OAk7xtIXC9EaMWqAT4=
In-Reply-To: <Y9MI42NSLooyVZNu-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2023-01-26 at 15:12 -0800, Roman Gushchin wrote:
> On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> > On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=C3=A1s wrote:
> > > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > > Disclaimer:
> > > > > > > a - The cover letter got bigger than expected, so I had to sp=
lit it in
> > > > > > >     sections to better organize myself. I am not very confort=
able with it.
> > > > > > > b - Performance numbers below did not include patch 5/5 (Remo=
ve flags
> > > > > > >     from memcg_stock_pcp), which could further improve perfor=
mance for
> > > > > > >     drain_all_stock(), but I could only notice the optimizati=
on at the
> > > > > > >     last minute.
> > > > > > >=20
> > > > > > >=20
> > > > > > > 0 - Motivation:
> > > > > > > On current codebase, when drain_all_stock() is ran, it will s=
chedule a
> > > > > > > drain_local_stock() for each cpu that has a percpu stock asso=
ciated with a
> > > > > > > descendant of a given root_memcg.
> > >=20
> > > Do you know what caused those drain_all_stock() calls? I wonder if we=
 should look
> > > into why we have many of them and whether we really need them?
> > >=20
> > > It's either some user's actions (e.g. reducing memory.max), either so=
me memcg
> > > is entering pre-oom conditions. In the latter case a lot of drain cal=
ls can be
> > > scheduled without a good reason (assuming the cgroup contain multiple=
 tasks running
> > > on multiple cpus).
> >=20
> > I believe I've never got a specific answer to that. We
> > have discussed that in the previous version submission
> > (20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org and specifically
> > Y2TQLavnLVd4qHMT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org). Leonardo has mentioned a mix of RT an=
d
> > isolcpus. I was wondering about using memcgs in RT workloads because
> > that just sounds weird but let's say this is the case indeed. Then an R=
T
> > task or whatever task that is running on an isolated cpu can have pcp
> > charges.
> >=20
> > > Essentially each cpu will try to grab the remains of the memory quota
> > > and move it locally. I wonder in such circumstances if we need to dis=
able the pcp-caching
> > > on per-cgroup basis.
> >=20
> > I think it would be more than sufficient to disable pcp charging on an
> > isolated cpu.
>=20
> It might have significant performance consequences.
>=20
> I'd rather opt out of stock draining for isolated cpus: it might slightly=
 reduce
> the accuracy of memory limits and slightly increase the memory footprint =
(all
> those dying memcgs...), but the impact will be limited. Actually it is li=
mited
> by the number of cpus.

I was discussing this same idea with Marcelo yesterday morning.

The questions had in the topic were:
a - About how many pages the pcp cache will hold before draining them itsel=
f?=C2=A0
b - Would it cache any kind of bigger page, or huge page in this same aspec=
t?

Please let me know if I got anything wrong, but IIUC from a previous debug =
(a)'s
answer is 4 pages. Meaning even on bigger-page archs such as powerpc, with =
64k
pages, the max pcp cache 'wasted' on each processor would be 256k (very sma=
ll on
today's standard).

Please let me know if you have any info on (b), or any correcting on (a).

The thing is: having this drain_local_stock() waiver only for isolated cpus
would not bring the same benefits for non-isolated cpus in high memory pres=
sure
as I understand this patchset is bringing. =C2=A0

OTOH not running drain_local_stock() at all for every cpu may introduce
performance gains (no remote CPU access) but can be a problem if I got the
'wasted pages' could on (a) wrong. I mean, drain_local_stock() was introduc=
ed
for a reason.

>=20
> > This is not a per memcg property.
>=20
> Sure, my point was that in pre-oom condition several cpus might try to co=
nsolidate
> the remains of the memory quota, actually working against each other. Sep=
arate issue,
> which might be a reason why there are many flush attempts in the case we =
discuss.
>=20
> Thanks!
>=20

Thank you for reviewing!

Leo


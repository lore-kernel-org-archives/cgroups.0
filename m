From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 0/4] mm: memcontrol: memory.stat cost & correctness
Date: Fri, 12 Apr 2019 22:04:02 +0000
Message-ID: <20190412220357.GA18999@tower.DHCP.thefacebook.com>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cqL+pJ71EKbv/SUv97RjkmOLlG58/qsHRdVt9C9X53w=;
 b=ohPxwfuhNzun4WRdiBIgrledoQNF8uFSklb+JHWUPDLIfWrrrHeQyy51eOKQw0rzfNPq
 Uv3UAFvisDKjQ0Ucltollc2ipfSk+weZC0j7UDPlmkn+JF5isO862jQRXjKvadyIYi0e
 CoPVZ0HLnDhGFnc/37UDKnfY5Wenl6e8JZs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqL+pJ71EKbv/SUv97RjkmOLlG58/qsHRdVt9C9X53w=;
 b=H2YMOi9C5K3HKrHcYUVEsTNQncAmKIKe9qv6C2wcbnmVa0Qm4GHBQbE73WZEyNGEUTuW8skgVx4GLsYEsm9Jx2zDv+wkxET7Wkpr9nmeHRpwm31fsKixfqHYoyG57DrSykHOknNdeXFY3OPh94PQ8e7WlNqk0rT9USySdFQsiRg=
In-Reply-To: <20190412151507.2769-1-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <25150709FC40BE4791F4051712207847@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Apr 12, 2019 at 11:15:03AM -0400, Johannes Weiner wrote:
> The cgroup memory.stat file holds recursive statistics for the entire
> subtree. The current implementation does this tree walk on-demand
> whenever the file is read. This is giving us problems in production.
>=20
> 1. The cost of aggregating the statistics on-demand is high. A lot of
> system service cgroups are mostly idle and their stats don't change
> between reads, yet we always have to check them. There are also always
> some lazily-dying cgroups sitting around that are pinned by a handful
> of remaining page cache; the same applies to them.
>=20
> In an application that periodically monitors memory.stat in our fleet,
> we have seen the aggregation consume up to 5% CPU time.
>=20
> 2. When cgroups die and disappear from the cgroup tree, so do their
> accumulated vm events. The result is that the event counters at
> higher-level cgroups can go backwards and confuse some of our
> automation, let alone people looking at the graphs over time.
>=20
> To address both issues, this patch series changes the stat
> implementation to spill counts upwards when the counters change.
>=20
> The upward spilling is batched using the existing per-cpu cache. In a
> sparse file stress test with 5 level cgroup nesting, the additional
> cost of the flushing was negligible (a little under 1% of CPU at 100%
> CPU utilization, compared to the 5% of reading memory.stat during
> regular operation).
>=20
>  include/linux/memcontrol.h |  96 +++++++-------
>  mm/memcontrol.c            | 290 +++++++++++++++++++++++++++------------=
----
>  mm/vmscan.c                |   4 +-
>  mm/workingset.c            |   7 +-
>  4 files changed, 234 insertions(+), 163 deletions(-)
>=20
>=20

For the series:
Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!

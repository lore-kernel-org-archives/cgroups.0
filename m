From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: vmscan: do not share cgroup iteration between
 reclaimers
Date: Mon, 12 Aug 2019 21:07:27 +0000
Message-ID: <20190812210723.GA9423@tower.dhcp.thefacebook.com>
References: <20190812192316.13615-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UQpM2DVd4KdWt+/TmUpgV8F/tE9aHCVCkVKeMEToXDY=;
 b=QpIullFToN6RVQl2OOoYDtRgu7DDVCcA2klcgBKmNuCKppznt+ZisETwVeAy0shgnJno
 uZaI9vCoZIcSmPOoDxOXQNa62yS9c6RQPUO8DjKG+A686kgmNBUz3Sb7IGB9J+7rpGt7
 rbW2bQpsNm7Usf7wsYLBTBsDR4MyMBdIga0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQpM2DVd4KdWt+/TmUpgV8F/tE9aHCVCkVKeMEToXDY=;
 b=ae0nL76yu/Z8gP9C/ycoWYjckNEqCrHNNH4scvbAkvxMAteACBWI7T2q1r1qyIQASD93+mGoaifs7iCuxYMTGTljo7VaXAu8UdrTnE0Fiy0bAUhtwmO2y8T0VDejFSsBhwuADyPAeBFKUzOwuzz03S6Si1+ZQ/e0U5GAT1qEFMc=
In-Reply-To: <20190812192316.13615-1-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <479A78A55F73BE4F993CA3F36F15FFD8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Aug 12, 2019 at 03:23:16PM -0400, Johannes Weiner wrote:
> One of our services observed a high rate of cgroup OOM kills in the
> presence of large amounts of clean cache. Debugging showed that the
> culprit is the shared cgroup iteration in page reclaim.
>=20
> Under high allocation concurrency, multiple threads enter reclaim at
> the same time. Fearing overreclaim when we first switched from the
> single global LRU to cgrouped LRU lists, we introduced a shared
> iteration state for reclaim invocations - whether 1 or 20 reclaimers
> are active concurrently, we only walk the cgroup tree once: the 1st
> reclaimer reclaims the first cgroup, the second the second one etc.
> With more reclaimers than cgroups, we start another walk from the top.
>=20
> This sounded reasonable at the time, but the problem is that reclaim
> concurrency doesn't scale with allocation concurrency. As reclaim
> concurrency increases, the amount of memory individual reclaimers get
> to scan gets smaller and smaller. Individual reclaimers may only see
> one cgroup per cycle, and that may not have much reclaimable
> memory. We see individual reclaimers declare OOM when there is plenty
> of reclaimable memory available in cgroups they didn't visit.

Nice catch!


>=20
> This patch does away with the shared iterator, and every reclaimer is
> allowed to scan the full cgroup tree and see all of reclaimable
> memory, just like it would on a non-cgrouped system. This way, when
> OOM is declared, we know that the reclaimer actually had a chance.
>=20
> To still maintain fairness in reclaim pressure, disallow cgroup
> reclaim from bailing out of the tree walk early. Kswapd and regular
> direct reclaim already don't bail, so it's not clear why limit reclaim
> would have to, especially since it only walks subtrees to begin with.
>=20
> This change completely eliminates the OOM kills on our service, while
> showing no signs of overreclaim - no increased scan rates, %sys time,
> or abrupt free memory spikes. I tested across 100 machines that have
> 64G of RAM and host about 300 cgroups each.
>=20
> [ It's possible overreclaim never was a *practical* issue to begin
>   with - it was simply a concern we had on the mailing lists at the
>   time, with no real data to back it up. But we have also added more
>   bail-out conditions deeper inside reclaim (e.g. the proportional
>   exit in shrink_node_memcg) since. Regardless, now we have data that
>   suggests full walks are more reliable and scale just fine. ]
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 22 ++--------------------
>  1 file changed, 2 insertions(+), 20 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index dbdc46a84f63..b2f10fa49c88 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2667,10 +2667,6 @@ static bool shrink_node(pg_data_t *pgdat, struct s=
can_control *sc)
> =20
>  	do {
>  		struct mem_cgroup *root =3D sc->target_mem_cgroup;
> -		struct mem_cgroup_reclaim_cookie reclaim =3D {
> -			.pgdat =3D pgdat,
> -			.priority =3D sc->priority,
> -		};
>  		unsigned long node_lru_pages =3D 0;
>  		struct mem_cgroup *memcg;
> =20
> @@ -2679,7 +2675,7 @@ static bool shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
>  		nr_reclaimed =3D sc->nr_reclaimed;
>  		nr_scanned =3D sc->nr_scanned;
> =20
> -		memcg =3D mem_cgroup_iter(root, NULL, &reclaim);
> +		memcg =3D mem_cgroup_iter(root, NULL, NULL);

I wonder if we can remove the shared memcg tree walking at all? It seems th=
at
the only use case left is the soft limit, and the same logic can be applied
to it. The we potentially can remove a lot of code in mem_cgroup_iter().
Just an idea...

>  		do {
>  			unsigned long lru_pages;
>  			unsigned long reclaimed;
> @@ -2724,21 +2720,7 @@ static bool shrink_node(pg_data_t *pgdat, struct s=
can_control *sc)
>  				   sc->nr_scanned - scanned,
>  				   sc->nr_reclaimed - reclaimed);
> =20
> -			/*
> -			 * Kswapd have to scan all memory cgroups to fulfill
> -			 * the overall scan target for the node.
> -			 *
> -			 * Limit reclaim, on the other hand, only cares about
> -			 * nr_to_reclaim pages to be reclaimed and it will
> -			 * retry with decreasing priority if one round over the
> -			 * whole hierarchy is not sufficient.
> -			 */
> -			if (!current_is_kswapd() &&
> -					sc->nr_reclaimed >=3D sc->nr_to_reclaim) {
> -				mem_cgroup_iter_break(root, memcg);
> -				break;
> -			}
> -		} while ((memcg =3D mem_cgroup_iter(root, memcg, &reclaim)));
> +		} while ((memcg =3D mem_cgroup_iter(root, memcg, NULL)));
> =20
>  		if (reclaim_state) {
>  			sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> --=20
> 2.22.0
>

Otherwise looks good to me!

Reviewed-by: Roman Gushchin <guro@fb.com>

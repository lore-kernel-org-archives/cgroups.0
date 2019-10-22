From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 5/8] mm: vmscan: replace shrink_node() loop with a retry
 jump
Date: Tue, 22 Oct 2019 19:56:33 +0000
Message-ID: <20191022195629.GA24142@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7ZloJzY3ufLgBoF7TowPMneSzI88EJC36MsIyufKxOU=;
 b=bz8lw1xWzqNtx8YT+OWnmssICIYy7x6ImuvI54zP4Ah1BIXGYKfex0/K1LWsNcT7gno8
 f16xsyx3OBCWSSLyac3+zPMOCYMnF58yJdPZX/v6EGPpVwqQvK6Kg3FIQv11GNDnHWdl
 mpM+uWZg51gLhLgGfjDRLXXO3UPKC/RZIdo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZloJzY3ufLgBoF7TowPMneSzI88EJC36MsIyufKxOU=;
 b=URH/zAs9L95fbl96Uxr5LN8gzik9XdNHCltPjsQZZroxZUVmC2yhgVs+W4l+c2+jYqwzSjp9mF+hCRBGAp+79cWmQLeqEawzS43JQssJ8mFNwabmvw+viHlVi0qmP27hq08ZptqTif4w7UCiWl0AVCLlL3Oe8zZeGMN3rF1Ynew=
In-Reply-To: <20191022144803.302233-6-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <87657937D7258B45A5F352CB2FFE9325@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:48:00AM -0400, Johannes Weiner wrote:
> Most of the function body is inside a loop, which imposes an
> additional indentation and scoping level that makes the code a bit
> hard to follow and modify.
>=20
> The looping only happens in case of reclaim-compaction, which isn't
> the common case. So rather than adding yet another function level to
> the reclaim path and have every reclaim invocation go through a level
> that only exists for one specific cornercase, use a retry goto.
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 231 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 115 insertions(+), 116 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 302dad112f75..235d1fc72311 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2729,144 +2729,143 @@ static bool pgdat_memcg_congested(pg_data_t *pg=
dat, struct mem_cgroup *memcg)
>  static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  {
>  	struct reclaim_state *reclaim_state =3D current->reclaim_state;
> +	struct mem_cgroup *root =3D sc->target_mem_cgroup;
>  	unsigned long nr_reclaimed, nr_scanned;
>  	bool reclaimable =3D false;
> +	struct mem_cgroup *memcg;
> +again:
> +	memset(&sc->nr, 0, sizeof(sc->nr));
> =20
> -	do {
> -		struct mem_cgroup *root =3D sc->target_mem_cgroup;
> -		struct mem_cgroup *memcg;
> -
> -		memset(&sc->nr, 0, sizeof(sc->nr));
> -
> -		nr_reclaimed =3D sc->nr_reclaimed;
> -		nr_scanned =3D sc->nr_scanned;
> +	nr_reclaimed =3D sc->nr_reclaimed;
> +	nr_scanned =3D sc->nr_scanned;
> =20
> -		memcg =3D mem_cgroup_iter(root, NULL, NULL);
> -		do {
> -			unsigned long reclaimed;
> -			unsigned long scanned;
> +	memcg =3D mem_cgroup_iter(root, NULL, NULL);
> +	do {
> +		unsigned long reclaimed;
> +		unsigned long scanned;
> =20
> -			switch (mem_cgroup_protected(root, memcg)) {
> -			case MEMCG_PROT_MIN:
> -				/*
> -				 * Hard protection.
> -				 * If there is no reclaimable memory, OOM.
> -				 */
> +		switch (mem_cgroup_protected(root, memcg)) {
> +		case MEMCG_PROT_MIN:
> +			/*
> +			 * Hard protection.
> +			 * If there is no reclaimable memory, OOM.
> +			 */
> +			continue;
> +		case MEMCG_PROT_LOW:
> +			/*
> +			 * Soft protection.
> +			 * Respect the protection only as long as
> +			 * there is an unprotected supply
> +			 * of reclaimable memory from other cgroups.
> +			 */
> +			if (!sc->memcg_low_reclaim) {
> +				sc->memcg_low_skipped =3D 1;
>  				continue;
> -			case MEMCG_PROT_LOW:
> -				/*
> -				 * Soft protection.
> -				 * Respect the protection only as long as
> -				 * there is an unprotected supply
> -				 * of reclaimable memory from other cgroups.
> -				 */
> -				if (!sc->memcg_low_reclaim) {
> -					sc->memcg_low_skipped =3D 1;
> -					continue;
> -				}
> -				memcg_memory_event(memcg, MEMCG_LOW);
> -				break;
> -			case MEMCG_PROT_NONE:
> -				/*
> -				 * All protection thresholds breached. We may
> -				 * still choose to vary the scan pressure
> -				 * applied based on by how much the cgroup in
> -				 * question has exceeded its protection
> -				 * thresholds (see get_scan_count).
> -				 */
> -				break;
>  			}
> +			memcg_memory_event(memcg, MEMCG_LOW);
> +			break;
> +		case MEMCG_PROT_NONE:
> +			/*
> +			 * All protection thresholds breached. We may
> +			 * still choose to vary the scan pressure
> +			 * applied based on by how much the cgroup in
> +			 * question has exceeded its protection
> +			 * thresholds (see get_scan_count).
> +			 */
> +			break;
> +		}
> =20
> -			reclaimed =3D sc->nr_reclaimed;
> -			scanned =3D sc->nr_scanned;
> -			shrink_node_memcg(pgdat, memcg, sc);
> -
> -			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
> -					sc->priority);
> -
> -			/* Record the group's reclaim efficiency */
> -			vmpressure(sc->gfp_mask, memcg, false,
> -				   sc->nr_scanned - scanned,
> -				   sc->nr_reclaimed - reclaimed);
> -
> -		} while ((memcg =3D mem_cgroup_iter(root, memcg, NULL)));
> +		reclaimed =3D sc->nr_reclaimed;
> +		scanned =3D sc->nr_scanned;
> +		shrink_node_memcg(pgdat, memcg, sc);
> =20
> -		if (reclaim_state) {
> -			sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> -			reclaim_state->reclaimed_slab =3D 0;
> -		}
> +		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
> +			    sc->priority);
> =20
> -		/* Record the subtree's reclaim efficiency */
> -		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> -			   sc->nr_scanned - nr_scanned,
> -			   sc->nr_reclaimed - nr_reclaimed);
> +		/* Record the group's reclaim efficiency */
> +		vmpressure(sc->gfp_mask, memcg, false,
> +			   sc->nr_scanned - scanned,
> +			   sc->nr_reclaimed - reclaimed);

It doesn't look as a trivial change. I'd add some comments to the commit me=
ssage
why it's safe to do.

Thanks!

> =20
> -		if (sc->nr_reclaimed - nr_reclaimed)
> -			reclaimable =3D true;
> +	} while ((memcg =3D mem_cgroup_iter(root, memcg, NULL)));
> =20
> -		if (current_is_kswapd()) {
> -			/*
> -			 * If reclaim is isolating dirty pages under writeback,
> -			 * it implies that the long-lived page allocation rate
> -			 * is exceeding the page laundering rate. Either the
> -			 * global limits are not being effective at throttling
> -			 * processes due to the page distribution throughout
> -			 * zones or there is heavy usage of a slow backing
> -			 * device. The only option is to throttle from reclaim
> -			 * context which is not ideal as there is no guarantee
> -			 * the dirtying process is throttled in the same way
> -			 * balance_dirty_pages() manages.
> -			 *
> -			 * Once a node is flagged PGDAT_WRITEBACK, kswapd will
> -			 * count the number of pages under pages flagged for
> -			 * immediate reclaim and stall if any are encountered
> -			 * in the nr_immediate check below.
> -			 */
> -			if (sc->nr.writeback && sc->nr.writeback =3D=3D sc->nr.taken)
> -				set_bit(PGDAT_WRITEBACK, &pgdat->flags);
> +	if (reclaim_state) {
> +		sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> +		reclaim_state->reclaimed_slab =3D 0;
> +	}
> =20
> -			/*
> -			 * Tag a node as congested if all the dirty pages
> -			 * scanned were backed by a congested BDI and
> -			 * wait_iff_congested will stall.
> -			 */
> -			if (sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
> -				set_bit(PGDAT_CONGESTED, &pgdat->flags);
> +	/* Record the subtree's reclaim efficiency */
> +	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> +		   sc->nr_scanned - nr_scanned,
> +		   sc->nr_reclaimed - nr_reclaimed);
> =20
> -			/* Allow kswapd to start writing pages during reclaim.*/
> -			if (sc->nr.unqueued_dirty =3D=3D sc->nr.file_taken)
> -				set_bit(PGDAT_DIRTY, &pgdat->flags);
> +	if (sc->nr_reclaimed - nr_reclaimed)
> +		reclaimable =3D true;
> =20
> -			/*
> -			 * If kswapd scans pages marked marked for immediate
> -			 * reclaim and under writeback (nr_immediate), it
> -			 * implies that pages are cycling through the LRU
> -			 * faster than they are written so also forcibly stall.
> -			 */
> -			if (sc->nr.immediate)
> -				congestion_wait(BLK_RW_ASYNC, HZ/10);
> -		}

Don't you want to separate the block below into a separate function?
It can probably make the big loop shorter and easier to follow.

Thanks!

> +	if (current_is_kswapd()) {
> +		/*
> +		 * If reclaim is isolating dirty pages under writeback,
> +		 * it implies that the long-lived page allocation rate
> +		 * is exceeding the page laundering rate. Either the
> +		 * global limits are not being effective at throttling
> +		 * processes due to the page distribution throughout
> +		 * zones or there is heavy usage of a slow backing
> +		 * device. The only option is to throttle from reclaim
> +		 * context which is not ideal as there is no guarantee
> +		 * the dirtying process is throttled in the same way
> +		 * balance_dirty_pages() manages.
> +		 *
> +		 * Once a node is flagged PGDAT_WRITEBACK, kswapd will
> +		 * count the number of pages under pages flagged for
> +		 * immediate reclaim and stall if any are encountered
> +		 * in the nr_immediate check below.
> +		 */
> +		if (sc->nr.writeback && sc->nr.writeback =3D=3D sc->nr.taken)
> +			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
> =20
>  		/*
> -		 * Legacy memcg will stall in page writeback so avoid forcibly
> -		 * stalling in wait_iff_congested().
> +		 * Tag a node as congested if all the dirty pages
> +		 * scanned were backed by a congested BDI and
> +		 * wait_iff_congested will stall.
>  		 */
> -		if (cgroup_reclaim(sc) && writeback_throttling_sane(sc) &&
> -		    sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
> -			set_memcg_congestion(pgdat, root, true);
> +		if (sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
> +			set_bit(PGDAT_CONGESTED, &pgdat->flags);
> +
> +		/* Allow kswapd to start writing pages during reclaim.*/
> +		if (sc->nr.unqueued_dirty =3D=3D sc->nr.file_taken)
> +			set_bit(PGDAT_DIRTY, &pgdat->flags);
> =20
>  		/*
> -		 * Stall direct reclaim for IO completions if underlying BDIs
> -		 * and node is congested. Allow kswapd to continue until it
> -		 * starts encountering unqueued dirty pages or cycling through
> -		 * the LRU too quickly.
> +		 * If kswapd scans pages marked marked for immediate
> +		 * reclaim and under writeback (nr_immediate), it
> +		 * implies that pages are cycling through the LRU
> +		 * faster than they are written so also forcibly stall.
>  		 */
> -		if (!sc->hibernation_mode && !current_is_kswapd() &&
> -		   current_may_throttle() && pgdat_memcg_congested(pgdat, root))
> -			wait_iff_congested(BLK_RW_ASYNC, HZ/10);
> +		if (sc->nr.immediate)
> +			congestion_wait(BLK_RW_ASYNC, HZ/10);
> +	}
> +
> +	/*
> +	 * Legacy memcg will stall in page writeback so avoid forcibly
> +	 * stalling in wait_iff_congested().
> +	 */
> +	if (cgroup_reclaim(sc) && writeback_throttling_sane(sc) &&
> +	    sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
> +		set_memcg_congestion(pgdat, root, true);
> +
> +	/*
> +	 * Stall direct reclaim for IO completions if underlying BDIs
> +	 * and node is congested. Allow kswapd to continue until it
> +	 * starts encountering unqueued dirty pages or cycling through
> +	 * the LRU too quickly.
> +	 */
> +	if (!sc->hibernation_mode && !current_is_kswapd() &&
> +	    current_may_throttle() && pgdat_memcg_congested(pgdat, root))
> +		wait_iff_congested(BLK_RW_ASYNC, HZ/10);
> =20
> -	} while (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed=
,
> -					 sc));
> +	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
> +				    sc))
> +		goto again;
> =20
>  	/*
>  	 * Kswapd gives up on balancing particular nodes after too
> --=20
> 2.23.0
>=20
>=20

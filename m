From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/8] mm: vmscan: naming fixes: global_reclaim() and
 sane_reclaim()
Date: Tue, 22 Oct 2019 19:40:52 +0000
Message-ID: <20191022194048.GA22721@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Yyld/l3iBVpg6QGUiVTQuQUs4aorX0m4S27DlFqcmNs=;
 b=SYwxQXRPkl8nwTl0GuaBzq0tuVBm5a9Uzy4picTsKpMBgZgI+YV2VFRWpBkwlLMQzyOV
 Ovschpf4nDslPZwmZbJphYX5vs8DAWwfe6cHzCqLuETpj/S8IdMdqwfSh0ZtxMDSq+G8
 YkmbQJmknSsx79LZrChPT3WLNxg8S9NZS1A= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yyld/l3iBVpg6QGUiVTQuQUs4aorX0m4S27DlFqcmNs=;
 b=HMG1kpDaJc62VPqcM9TMTJ04d8XW0Wa7+abeJ7LKhAQoVV4Oiz7YCzeEahc3r/kLK3o4El58w3/bGcDPCDMC2U7sFSU4Q4CIKOMWwixXN977Qlwoj9qWoqN49R3VzIx0C1SBwU0fysJxZjkA/YDStH4DOQj1MP/YxbBAeijCQTI=
In-Reply-To: <20191022144803.302233-5-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <5AE45F65CD7F8B4B8921E2F7B23987C0@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:47:59AM -0400, Johannes Weiner wrote:
> Seven years after introducing the global_reclaim() function, I still
> have to double take when reading a callsite. I don't know how others
> do it, this is a terrible name.
>=20
> Invert the meaning and rename it to cgroup_reclaim().
>=20
> [ After all, "global reclaim" is just regular reclaim invoked from the
>   page allocator. It's reclaim on behalf of a cgroup limit that is a
>   special case of reclaim, and should be explicit - not the reverse. ]
>=20
> sane_reclaim() isn't very descriptive either: it tests whether we can
> use the regular writeback throttling - available during regular page
> reclaim or cgroup2 limit reclaim - or need to use the broken
> wait_on_page_writeback() method. Use "writeback_throttling_sane()".
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 38 ++++++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 622b77488144..302dad112f75 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -239,13 +239,13 @@ static void unregister_memcg_shrinker(struct shrink=
er *shrinker)
>  	up_write(&shrinker_rwsem);
>  }
> =20
> -static bool global_reclaim(struct scan_control *sc)
> +static bool cgroup_reclaim(struct scan_control *sc)
>  {
> -	return !sc->target_mem_cgroup;
> +	return sc->target_mem_cgroup;
>  }

Isn't targeted_reclaim() better?

cgroup_reclaim() is also ok to me, but it sounds a bit like we reclaim
from this specific cgroup. Also targeted/global is IMO a better opposition
than cgroup/global (the latter reminds me days when there were global
and cgroup LRUs).

The rest of the patch looks good!

Reviewed-by: Roman Gushchin <guro@fb.com>

> =20
>  /**
> - * sane_reclaim - is the usual dirty throttling mechanism operational?
> + * writeback_throttling_sane - is the usual dirty throttling mechanism a=
vailable?
>   * @sc: scan_control in question
>   *
>   * The normal page dirty throttling mechanism in balance_dirty_pages() i=
s
> @@ -257,11 +257,9 @@ static bool global_reclaim(struct scan_control *sc)
>   * This function tests whether the vmscan currently in progress can assu=
me
>   * that the normal dirty throttling mechanism is operational.
>   */
> -static bool sane_reclaim(struct scan_control *sc)
> +static bool writeback_throttling_sane(struct scan_control *sc)
>  {
> -	struct mem_cgroup *memcg =3D sc->target_mem_cgroup;
> -
> -	if (!memcg)
> +	if (!cgroup_reclaim(sc))
>  		return true;
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> @@ -302,12 +300,12 @@ static void unregister_memcg_shrinker(struct shrink=
er *shrinker)
>  {
>  }
> =20
> -static bool global_reclaim(struct scan_control *sc)
> +static bool cgroup_reclaim(struct scan_control *sc)
>  {
> -	return true;
> +	return false;
>  }
> =20
> -static bool sane_reclaim(struct scan_control *sc)
> +static bool writeback_throttling_sane(struct scan_control *sc)
>  {
>  	return true;
>  }
> @@ -1227,7 +1225,7 @@ static unsigned long shrink_page_list(struct list_h=
ead *page_list,
>  				goto activate_locked;
> =20
>  			/* Case 2 above */
> -			} else if (sane_reclaim(sc) ||
> +			} else if (writeback_throttling_sane(sc) ||
>  			    !PageReclaim(page) || !may_enter_fs) {
>  				/*
>  				 * This is slightly racy - end_page_writeback()
> @@ -1821,7 +1819,7 @@ static int too_many_isolated(struct pglist_data *pg=
dat, int file,
>  	if (current_is_kswapd())
>  		return 0;
> =20
> -	if (!sane_reclaim(sc))
> +	if (!writeback_throttling_sane(sc))
>  		return 0;
> =20
>  	if (file) {
> @@ -1971,7 +1969,7 @@ shrink_inactive_list(unsigned long nr_to_scan, stru=
ct lruvec *lruvec,
>  	reclaim_stat->recent_scanned[file] +=3D nr_taken;
> =20
>  	item =3D current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
> -	if (global_reclaim(sc))
> +	if (!cgroup_reclaim(sc))
>  		__count_vm_events(item, nr_scanned);
>  	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
>  	spin_unlock_irq(&pgdat->lru_lock);
> @@ -1985,7 +1983,7 @@ shrink_inactive_list(unsigned long nr_to_scan, stru=
ct lruvec *lruvec,
>  	spin_lock_irq(&pgdat->lru_lock);
> =20
>  	item =3D current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
> -	if (global_reclaim(sc))
> +	if (!cgroup_reclaim(sc))
>  		__count_vm_events(item, nr_reclaimed);
>  	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
>  	reclaim_stat->recent_rotated[0] +=3D stat.nr_activate[0];
> @@ -2309,7 +2307,7 @@ static void get_scan_count(struct lruvec *lruvec, s=
truct mem_cgroup *memcg,
>  	 * using the memory controller's swap limit feature would be
>  	 * too expensive.
>  	 */
> -	if (!global_reclaim(sc) && !swappiness) {
> +	if (cgroup_reclaim(sc) && !swappiness) {
>  		scan_balance =3D SCAN_FILE;
>  		goto out;
>  	}
> @@ -2333,7 +2331,7 @@ static void get_scan_count(struct lruvec *lruvec, s=
truct mem_cgroup *memcg,
>  	 * thrashing file LRU becomes infinitely more attractive than
>  	 * anon pages.  Try to detect this based on file LRU size.
>  	 */
> -	if (global_reclaim(sc)) {
> +	if (!cgroup_reclaim(sc)) {
>  		unsigned long pgdatfile;
>  		unsigned long pgdatfree;
>  		int z;
> @@ -2564,7 +2562,7 @@ static void shrink_node_memcg(struct pglist_data *p=
gdat, struct mem_cgroup *memc
>  	 * abort proportional reclaim if either the file or anon lru has alread=
y
>  	 * dropped to zero at the first pass.
>  	 */
> -	scan_adjusted =3D (global_reclaim(sc) && !current_is_kswapd() &&
> +	scan_adjusted =3D (!cgroup_reclaim(sc) && !current_is_kswapd() &&
>  			 sc->priority =3D=3D DEF_PRIORITY);
> =20
>  	blk_start_plug(&plug);
> @@ -2853,7 +2851,7 @@ static bool shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
>  		 * Legacy memcg will stall in page writeback so avoid forcibly
>  		 * stalling in wait_iff_congested().
>  		 */
> -		if (!global_reclaim(sc) && sane_reclaim(sc) &&
> +		if (cgroup_reclaim(sc) && writeback_throttling_sane(sc) &&
>  		    sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
>  			set_memcg_congestion(pgdat, root, true);
> =20
> @@ -2948,7 +2946,7 @@ static void shrink_zones(struct zonelist *zonelist,=
 struct scan_control *sc)
>  		 * Take care memory controller reclaiming has small influence
>  		 * to global LRU.
>  		 */
> -		if (global_reclaim(sc)) {
> +		if (!cgroup_reclaim(sc)) {
>  			if (!cpuset_zone_allowed(zone,
>  						 GFP_KERNEL | __GFP_HARDWALL))
>  				continue;
> @@ -3048,7 +3046,7 @@ static unsigned long do_try_to_free_pages(struct zo=
nelist *zonelist,
>  retry:
>  	delayacct_freepages_start();
> =20
> -	if (global_reclaim(sc))
> +	if (!cgroup_reclaim(sc))
>  		__count_zid_vm_events(ALLOCSTALL, sc->reclaim_idx, 1);
> =20
>  	do {
> --=20
> 2.23.0
>=20

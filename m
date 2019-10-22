From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 6/8] mm: vmscan: turn shrink_node_memcg() into
 shrink_lruvec()
Date: Tue, 22 Oct 2019 20:04:48 +0000
Message-ID: <20191022200444.GB22721@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KM3denrXSVWQiRwu0fwZ7TxzuDWvG0h3C/tN3Th1IHI=;
 b=DHnWCvVQUtxjMdm4plilCrX9pJKqnYfwoED645hD/toBj7cCNx9cAAo+EwL42J3GDnpA
 ffKQobpRMemtao6mNKO+BdkNnMxzB3BsZrhFZpV02h38VdQq41GgVRKqWuxMk7AnHEwJ
 PqGy2wiD9QpTHvP61PSxlzARM5PxrATDnv8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM3denrXSVWQiRwu0fwZ7TxzuDWvG0h3C/tN3Th1IHI=;
 b=U7aF6H98PIL72n/tPxbX2iF5O9zaGWUiHM2CaGN1pmVlTJ4N6TZfo16IM43VC5g6Gxq6DCi+cX+qhL9iJIyi5YEK9ZlaMxdNUhrqHKLOeHLWWtY96wa0EgV9HOSfxlDKpiZXMz0DdnUSY8jJb09b7f+MEEvnCRk+GcRaXIyU3Gk=
In-Reply-To: <20191022144803.302233-7-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <4F3DF65956583C4CBAC4BBF46643B806@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:48:01AM -0400, Johannes Weiner wrote:
> A lruvec holds LRU pages owned by a certain NUMA node and cgroup.
> Instead of awkwardly passing around a combination of a pgdat and a
> memcg pointer, pass down the lruvec as soon as we can look it up.
>=20
> Nested callers that need to access node or cgroup properties can look
> them them up if necessary, but there are only a few cases.
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 235d1fc72311..db073b40c432 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2280,9 +2280,10 @@ enum scan_balance {
>   * nr[0] =3D anon inactive pages to scan; nr[1] =3D anon active pages to=
 scan
>   * nr[2] =3D file inactive pages to scan; nr[3] =3D file active pages to=
 scan
>   */
> -static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *mem=
cg,
> -			   struct scan_control *sc, unsigned long *nr)
> +static void get_scan_count(struct lruvec *lruvec, struct scan_control *s=
c,
> +			   unsigned long *nr)
>  {
> +	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>  	int swappiness =3D mem_cgroup_swappiness(memcg);
>  	struct zone_reclaim_stat *reclaim_stat =3D &lruvec->reclaim_stat;
>  	u64 fraction[2];
> @@ -2530,13 +2531,8 @@ static void get_scan_count(struct lruvec *lruvec, =
struct mem_cgroup *memcg,
>  	}
>  }
> =20
> -/*
> - * This is a basic per-node page freer.  Used by both kswapd and direct =
reclaim.
> - */
> -static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgro=
up *memcg,
> -			      struct scan_control *sc)
> +static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc=
)
>  {
> -	struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>  	unsigned long nr[NR_LRU_LISTS];
>  	unsigned long targets[NR_LRU_LISTS];
>  	unsigned long nr_to_scan;
> @@ -2546,7 +2542,7 @@ static void shrink_node_memcg(struct pglist_data *p=
gdat, struct mem_cgroup *memc
>  	struct blk_plug plug;
>  	bool scan_adjusted;
> =20
> -	get_scan_count(lruvec, memcg, sc, nr);
> +	get_scan_count(lruvec, sc, nr);
> =20
>  	/* Record the original scan target for proportional adjustments later *=
/
>  	memcpy(targets, nr, sizeof(nr));
> @@ -2741,6 +2737,7 @@ static bool shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
> =20
>  	memcg =3D mem_cgroup_iter(root, NULL, NULL);
>  	do {
> +		struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>  		unsigned long reclaimed;
>  		unsigned long scanned;
> =20
> @@ -2777,7 +2774,8 @@ static bool shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
> =20
>  		reclaimed =3D sc->nr_reclaimed;
>  		scanned =3D sc->nr_scanned;
> -		shrink_node_memcg(pgdat, memcg, sc);
> +
> +		shrink_lruvec(lruvec, sc);
> =20
>  		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
>  			    sc->priority);
> @@ -3281,6 +3279,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgr=
oup *memcg,
>  						pg_data_t *pgdat,
>  						unsigned long *nr_scanned)
>  {
> +	struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>  	struct scan_control sc =3D {
>  		.nr_to_reclaim =3D SWAP_CLUSTER_MAX,
>  		.target_mem_cgroup =3D memcg,
> @@ -3307,7 +3306,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgr=
oup *memcg,
>  	 * will pick up pages from other mem cgroup's as well. We hack
>  	 * the priority and make it zero.
>  	 */
> -	shrink_node_memcg(pgdat, memcg, &sc);
> +	shrink_lruvec(lruvec, &sc);
> =20
>  	trace_mm_vmscan_memcg_softlimit_reclaim_end(
>  					cgroup_ino(memcg->css.cgroup),
> --=20
> 2.23.0
>=20

Reviewed-by: Roman Gushchin <guro@fb.com>

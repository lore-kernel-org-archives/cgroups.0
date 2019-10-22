From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 7/8] mm: vmscan: split shrink_node() into node part and
 memcgs part
Date: Tue, 22 Oct 2019 20:08:23 +0000
Message-ID: <20191022200819.GC22721@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kSxBKKs/CV01OvG76EJpyOie2QydFm1ggqmmSisDNmE=;
 b=i2nm7uUuJNSa9jAWC6h8Wqlep677YI2WZ/GblPvUPBYNuupvIhtJrptFE0tTL+KmU4YC
 woW5ru/6S84q+iXUwTczu1jpnm1K6Gn13cCUOf2kJacT/pvcl2EoXVqa7EmdYZW/jO1W
 vI3kJBXWHdJI8+Gs+QuEB1FGCXT/0VkYnlU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSxBKKs/CV01OvG76EJpyOie2QydFm1ggqmmSisDNmE=;
 b=dVjJVN7U0vFlO5PfQTcR/aXQvtWG5MeK1sIvtcPZPLaYdeFpbjSsO+SBr5G83z4B0sIFf1WvTxNquWDFIq99UGi3rtmmlcIwb4c26vP8tPfI5S9RtR1FSYThj0S8INP4YGRITL0kjjzu2mdg98CKASsrlgKKROKAUKss13cwt0Y=
In-Reply-To: <20191022144803.302233-8-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <A5FC583F63CE3C4DB54A3E316B1BE943@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:48:02AM -0400, Johannes Weiner wrote:
> This function is getting long and unwieldy, split out the memcg bits.
>=20
> The updated shrink_node() handles the generic (node) reclaim aspects:
>   - global vmpressure notifications
>   - writeback and congestion throttling
>   - reclaim/compaction management
>   - kswapd giving up on unreclaimable nodes
>=20
> It then calls a new shrink_node_memcgs() which handles cgroup specifics:
>   - the cgroup tree traversal
>   - memory.low considerations
>   - per-cgroup slab shrinking callbacks
>   - per-cgroup vmpressure notifications
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index db073b40c432..65baa89740dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2722,18 +2722,10 @@ static bool pgdat_memcg_congested(pg_data_t *pgda=
t, struct mem_cgroup *memcg)
>  		(memcg && memcg_congested(pgdat, memcg));
>  }
> =20
> -static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc=
)
>  {
> -	struct reclaim_state *reclaim_state =3D current->reclaim_state;
>  	struct mem_cgroup *root =3D sc->target_mem_cgroup;
> -	unsigned long nr_reclaimed, nr_scanned;
> -	bool reclaimable =3D false;
>  	struct mem_cgroup *memcg;
> -again:
> -	memset(&sc->nr, 0, sizeof(sc->nr));
> -
> -	nr_reclaimed =3D sc->nr_reclaimed;
> -	nr_scanned =3D sc->nr_scanned;
> =20
>  	memcg =3D mem_cgroup_iter(root, NULL, NULL);
>  	do {
> @@ -2786,6 +2778,22 @@ static bool shrink_node(pg_data_t *pgdat, struct s=
can_control *sc)
>  			   sc->nr_reclaimed - reclaimed);
> =20
>  	} while ((memcg =3D mem_cgroup_iter(root, memcg, NULL)));
> +}
> +
> +static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +{
> +	struct reclaim_state *reclaim_state =3D current->reclaim_state;
> +	struct mem_cgroup *root =3D sc->target_mem_cgroup;
> +	unsigned long nr_reclaimed, nr_scanned;
> +	bool reclaimable =3D false;
> +
> +again:
> +	memset(&sc->nr, 0, sizeof(sc->nr));
> +
> +	nr_reclaimed =3D sc->nr_reclaimed;
> +	nr_scanned =3D sc->nr_scanned;
> +
> +	shrink_node_memcgs(pgdat, sc);
> =20
>  	if (reclaim_state) {
>  		sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> @@ -2793,7 +2801,7 @@ static bool shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
>  	}
> =20
>  	/* Record the subtree's reclaim efficiency */
> -	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> +	vmpressure(sc->gfp_mask, root, true,

Maybe target? Or target_memcg? The word root is associated with the root cg=
roup.

Other than root the patch looks good to me:

Reviewed-by: Roman Gushchin <guro@fb.com>

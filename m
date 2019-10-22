From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/8] mm: vmscan: simplify lruvec_lru_size()
Date: Tue, 22 Oct 2019 19:18:10 +0000
Message-ID: <20191022191806.GA11461@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=M/V6yi+wMDg4kFrNEEAneW64BO+255sD/jPJaAf4IFc=;
 b=AMnaIQahpsF7Dx9bxfN3+ylwIpb89rU9N/9J2CDUINXAj4wrZXkoJUdIoX8veoPNQSjK
 oeqclieSAzkJKX5N7RRQnXUJ8ejlxDeRnv3/fVZEtakDdpfaD1SUJ8c7KHA7+DxvzHz2
 IZ3BONvNNX9hXi6gWwKWhvIwMVL1vUd5vSk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/V6yi+wMDg4kFrNEEAneW64BO+255sD/jPJaAf4IFc=;
 b=N+QtiYL5TnoDSocfoeAv8Kvf2Fhq/TzGtJ1AWR9iVYKsiB6SO8zroTRNwn1PFCSOuFoG4W3TamkBPzikkcUQXwJRkFVyoevk9n2cI6mPBHJOFuJiuf6aoXsI9FnxpPMovqbHd9ZqrbTJ0E48BRCxzePVTuEMZU6r7a3PpOJ4hlE=
In-Reply-To: <20191022144803.302233-2-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <4335EC072729F4448C5FC9BE0C1FC642@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:47:56AM -0400, Johannes Weiner wrote:
> This function currently takes the node or lruvec size and subtracts
> the zones that are excluded by the classzone index of the
> allocation. It uses four different types of counters to do this.
>=20
> Just add up the eligible zones.
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1154b3a2b637..57f533b808f2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -351,32 +351,21 @@ unsigned long zone_reclaimable_pages(struct zone *z=
one)
>   */
>  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, =
int zone_idx)
>  {
> -	unsigned long lru_size =3D 0;
> +	unsigned long size =3D 0;
>  	int zid;
> =20
> -	if (!mem_cgroup_disabled()) {
> -		for (zid =3D 0; zid < MAX_NR_ZONES; zid++)
> -			lru_size +=3D mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
> -	} else
> -		lru_size =3D node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
> -
> -	for (zid =3D zone_idx + 1; zid < MAX_NR_ZONES; zid++) {
> +	for (zid =3D 0; zid <=3D zone_idx; zid++) {
>  		struct zone *zone =3D &lruvec_pgdat(lruvec)->node_zones[zid];
> -		unsigned long size;
> =20
>  		if (!managed_zone(zone))
>  			continue;
> =20
>  		if (!mem_cgroup_disabled())
> -			size =3D mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
> +			size +=3D mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
>  		else
> -			size =3D zone_page_state(&lruvec_pgdat(lruvec)->node_zones[zid],
> -				       NR_ZONE_LRU_BASE + lru);
> -		lru_size -=3D min(size, lru_size);
> +			size +=3D zone_page_state(zone, NR_ZONE_LRU_BASE + lru);
>  	}
> -
> -	return lru_size;
> -
> +	return size;

Neat!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!

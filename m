From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 3/8] mm: vmscan: move inactive_list_is_low() swap check to
 the caller
Date: Tue, 22 Oct 2019 19:28:14 +0000
Message-ID: <20191022192810.GC11461@tower.DHCP.thefacebook.com>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FYdrSghnpTrVWnv8inCzCSDuoKr2VRRzrJKqEkqq9L4=;
 b=nT5rgyasfm/GRrHl9os5wzPS1D3galfrU7P6fYM6XOeYof4eNV8A+A82jJE0v6QZ38fO
 58KWPyR8vIH2O7MwFUnlE0ySurQwCpWPVWmnl1QS7buKXwWdE1lZ2b7QundiTA9CicEg
 MHdzLFCkfA5Qk5VLmIu4+af56DIn4E3CkoI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYdrSghnpTrVWnv8inCzCSDuoKr2VRRzrJKqEkqq9L4=;
 b=Una0L7fSOawJP7MPiIhtD0V3KjPNiSymwxqX8OaCmmCUp5gZgnA7eBglKpTNeNWz54fahZq3N+5S8D1EswibpcSP+Sgy4DnkqR1tUHGQHomGKWPuOCPmhthQDgE7Y1Fo+VDRtUP0RafgLZkJlz8Jap0ClOduIlXNyqn6mMnbf9k=
In-Reply-To: <20191022144803.302233-4-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <4EC1CB5581D2114D956DF44FA235F099@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 10:47:58AM -0400, Johannes Weiner wrote:
> inactive_list_is_low() should be about one thing: checking the ratio
> between inactive and active list. Kitchensink checks like the one for
> swap space makes the function hard to use and modify its
> callsites. Luckly, most callers already have an understanding of the
> swap situation, so it's easy to clean up.
>=20
> get_scan_count() has its own, memcg-aware swap check, and doesn't even
> get to the inactive_list_is_low() check on the anon list when there is
> no swap space available.
>=20
> shrink_list() is called on the results of get_scan_count(), so that
> check is redundant too.
>=20
> age_active_anon() has its own totalswap_pages check right before it
> checks the list proportions.
>=20
> The shrink_node_memcg() site is the only one that doesn't do its own
> swap check. Add it there.
>=20
> Then delete the swap check from inactive_list_is_low().
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index be3c22c274c1..622b77488144 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2226,13 +2226,6 @@ static bool inactive_list_is_low(struct lruvec *lr=
uvec, bool file,
>  	unsigned long refaults;
>  	unsigned long gb;
> =20
> -	/*
> -	 * If we don't have swap space, anonymous page deactivation
> -	 * is pointless.
> -	 */
> -	if (!file && !total_swap_pages)
> -		return false;
> -
>  	inactive =3D lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
>  	active =3D lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
> =20
> @@ -2653,7 +2646,7 @@ static void shrink_node_memcg(struct pglist_data *p=
gdat, struct mem_cgroup *memc
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
>  	 */
> -	if (inactive_list_is_low(lruvec, false, sc, true))
> +	if (total_swap_pages && inactive_list_is_low(lruvec, false, sc, true))
>  		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
>  				   sc, LRU_ACTIVE_ANON);
>  }
> --=20
> 2.23.0
>=20
>=20

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!

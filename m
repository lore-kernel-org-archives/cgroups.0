From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 18/18] mm: memcontrol: update page->mem_cgroup stability
 rules
Date: Tue, 21 Apr 2020 17:20:59 +0800
Message-ID: <1f905391-5676-2db6-efb9-74ade130740e@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-19-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200420221126.341272-19-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



=D4=DA 2020/4/21 =C9=CF=CE=E76:11, Johannes Weiner =D0=B4=B5=C0:
> The previous patches have simplified the access rules around
> page->mem_cgroup somewhat:
>=20
> 1. We never change page->mem_cgroup while the page is isolated by
>    somebody else. This was by far the biggest exception to our rules
>    and it didn't stop at lock_page() or lock_page_memcg().
>=20
> 2. We charge pages before they get put into page tables now, so the
>    somewhat fishy rule about "can be in page table as long as it's
>    still locked" is now gone and boiled down to having an exclusive
>    reference to the page.
>=20
> Document the new rules. Any of the following will stabilize the
> page->mem_cgroup association:
>=20
> - the page lock
> - LRU isolation
> - lock_page_memcg()
> - exclusive access to the page
>=20
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gman=
e.org>

Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gma=
ne.org>

> ---
>  mm/memcontrol.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a8cce52b6b4d..7b63260c9b57 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1201,9 +1201,8 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>   * @page: the page
>   * @pgdat: pgdat of the page
>   *
> - * This function is only safe when following the LRU page isolation
> - * and putback protocol: the LRU lock must be held, and the page must
> - * either be PageLRU() or the caller must have isolated/allocated it.
> + * This function relies on page->mem_cgroup being stable - see the
> + * access rules in commit_charge().
>   */
>  struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_d=
ata *pgdat)
>  {
> @@ -2605,18 +2604,12 @@ static void commit_charge(struct page *page, stru=
ct mem_cgroup *memcg)
>  {
>  	VM_BUG_ON_PAGE(page->mem_cgroup, page);
>  	/*
> -	 * Nobody should be changing or seriously looking at
> -	 * page->mem_cgroup at this point:
> -	 *
> -	 * - the page is uncharged
> -	 *
> -	 * - the page is off-LRU
> -	 *
> -	 * - an anonymous fault has exclusive page access, except for
> -	 *   a locked page table
> +	 * Any of the following ensures page->mem_cgroup stability:
>  	 *
> -	 * - a page cache insertion, a swapin fault, or a migration
> -	 *   have the page locked
> +	 * - the page lock
> +	 * - LRU isolation
> +	 * - lock_page_memcg()
> +	 * - exclusive reference
>  	 */
>  	page->mem_cgroup =3D memcg;
>  }
>=20

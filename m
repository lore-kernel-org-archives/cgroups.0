From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 01/18] mm: fix NUMA node file count error in
 replace_page_cache()
Date: Tue, 21 Apr 2020 16:28:10 +0800
Message-ID: <c5c379d5-d580-58ec-c9d1-f05d6cdc57b4@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200420221126.341272-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



=D4=DA 2020/4/21 =C9=CF=CE=E76:11, Johannes Weiner =D0=B4=B5=C0:
> When replacing one page with another one in the cache, we have to
> decrease the file count of the old page's NUMA node and increase the
> one of the new NUMA node, otherwise the old node leaks the count and
> the new node eventually underflows its counter.
>=20
> Fixes: 74d609585d8b ("page cache: Add and replace pages using the XArray")
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gman=
e.org>

Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gma=
ne.org>

> ---
>  mm/filemap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 23a051a7ef0f..49e3b5da0216 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -808,11 +808,11 @@ int replace_page_cache_page(struct page *old, struc=
t page *new, gfp_t gfp_mask)
>  	old->mapping =3D NULL;
>  	/* hugetlb pages do not participate in page cache accounting. */
>  	if (!PageHuge(old))
> -		__dec_node_page_state(new, NR_FILE_PAGES);
> +		__dec_node_page_state(old, NR_FILE_PAGES);
>  	if (!PageHuge(new))
>  		__inc_node_page_state(new, NR_FILE_PAGES);
>  	if (PageSwapBacked(old))
> -		__dec_node_page_state(new, NR_SHMEM);
> +		__dec_node_page_state(old, NR_SHMEM);
>  	if (PageSwapBacked(new))
>  		__inc_node_page_state(new, NR_SHMEM);
>  	xas_unlock_irqrestore(&xas, flags);
>=20

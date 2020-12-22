From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v2 2/3] mm/memcg: remove rcu locking for lock_page_lruvec
 function series
Date: Tue, 22 Dec 2020 16:00:20 +0800
Message-ID: <398f089d-250b-39f7-691a-9ce495b30700@linux.alibaba.com>
References: <1608614453-10739-1-git-send-email-alex.shi@linux.alibaba.com>
 <1608614453-10739-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1608614453-10739-2-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: hughd@google.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Su <sh_def@163.com>, Alexander Duyck <alexander.duyck@gmail.com>

Cc: Hui Su and Alexander Duyck as Hugh suggested.

=D4=DA 2020/12/22 =CF=C2=CE=E71:20, Alex Shi =D0=B4=B5=C0:
> lock_page_lruvec() and its variants used rcu_read_lock() with the
> intention of safeguarding against the mem_cgroup being destroyed
> concurrently; but so long as they are called under the specified
> conditions (as they are), there is no way for the page's mem_cgroup
> to be destroyed.  Delete the unnecessary rcu_read_lock() and _unlock().
>=20
> Hugh Dickin's polished the commit log, Thanks a lot!
>=20
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/memcontrol.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8d400efc81b9..0af13c4fe4b3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1356,10 +1356,8 @@ struct lruvec *lock_page_lruvec(struct page *page)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat =3D page_pgdat(page);
> =20
> -	rcu_read_lock();
>  	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock(&lruvec->lru_lock);
> -	rcu_read_unlock();
> =20
>  	lruvec_memcg_debug(lruvec, page);
> =20
> @@ -1371,10 +1369,8 @@ struct lruvec *lock_page_lruvec_irq(struct page *p=
age)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat =3D page_pgdat(page);
> =20
> -	rcu_read_lock();
>  	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock_irq(&lruvec->lru_lock);
> -	rcu_read_unlock();
> =20
>  	lruvec_memcg_debug(lruvec, page);
> =20
> @@ -1386,10 +1382,8 @@ struct lruvec *lock_page_lruvec_irqsave(struct pag=
e *page, unsigned long *flags)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat =3D page_pgdat(page);
> =20
> -	rcu_read_lock();
>  	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> -	rcu_read_unlock();
> =20
>  	lruvec_memcg_debug(lruvec, page);
> =20
>=20

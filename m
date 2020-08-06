From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Thu, 6 Aug 2020 15:41:28 +0800
Message-ID: <bf2e2e9d-ce1c-f0d5-3ccc-9499c09831cb@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1595681998-19193-18-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Johannes, Michal,

From page to its lruvec, a few memory access under lock cause extra cost.
Would you like to save the per memcg lruvec pointer to page->private?

Thanks
Alex



=D4=DA 2020/7/25 =CF=C2=CE=E78:59, Alex Shi =D0=B4=B5=C0:
>  /**
>   * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU p=
age
>   * @page: the page
> @@ -1215,7 +1228,8 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *=
page, struct pglist_data *pgd
>  		goto out;
>  	}
> =20
> -	memcg =3D page->mem_cgroup;
> +	VM_BUG_ON_PAGE(PageTail(page), page);
> +	memcg =3D READ_ONCE(page->mem_cgroup);
>  	/*
>  	 * Swapcache readahead pages are added to the LRU - and
>  	 * possibly migrated - before they are charged.
> @@ -1236,6 +1250,51 @@ struct lruvec *mem_cgroup_page_lruvec(struct page =
*page, struct pglist_data *pgd
>  	return lruvec;
>  }
> =20
> +struct lruvec *lock_page_lruvec(struct page *page)
> +{
> +	struct lruvec *lruvec;
> +	struct pglist_data *pgdat =3D page_pgdat(page);
> +
> +	rcu_read_lock();
> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> +	spin_lock(&lruvec->lru_lock);
> +	rcu_read_unlock();
> +
> +	lruvec_memcg_debug(lruvec, page);
> +
> +	return lruvec;
> +}
> +

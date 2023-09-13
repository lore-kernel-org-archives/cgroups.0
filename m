From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 15/18] x86/sgx: Prepare for multiple LRUs
Date: Wed, 13 Sep 2023 18:42:52 +0300
Message-ID: <CVHWKO25RFOU.24Z5A88M1VZA1@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-16-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694619777;
        bh=dSRv1cBIDROgqqiss/h2glTw3xEXdiH3Jh5rhTdY2To=;
        h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
        b=HBbUlFJTs74XooeS4O0KNQljjycjjwKZQzoLMo8ziUkQYkD2DYcGxdcUzqTpx6Ak3
         n3esjPzKLD0BasbPWjTUYBV5730/FdMZk9dTk9YMPETHzXTPsfUPy5I+v8ijjJCi1q
         lU+Kd43ARxKHzWwCe7C0tbOYJzoddKuunYIQ3v7aRw/I5+ldy2Z7xI83bF7GekJKut
         +JEyyHRydX0Qk519NyPfXBL8KiKl9AHC6uVFRKwi7Bf/yhRgsDGLnJkkzS06cL7bNn
         uAajshy/k3UyEKALiGzDoFnQq05F9MSOL97h2fEpb0UKH0Z/03EfhrjsA01U/E881O
         Ya11RmDcJxrXA==
In-Reply-To: <20230913040635.28815-16-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> Add sgx_can_reclaim() wrapper and encapsulate direct references to the
> global LRU list in the reclaimer functions so that they can be called wit=
h
> an LRU list per EPC cgroup.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> V4:
> - Re-organized this patch to include all changes related to
> encapsulation of the global LRU
> - Moved this patch to precede the EPC cgroup patch
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 41 +++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index ce316bd5e5bb..3d396fe5ec09 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -34,6 +34,16 @@ static DEFINE_XARRAY(sgx_epc_address_space);
>   */
>  static struct sgx_epc_lru_lists sgx_global_lru;
> =20
> +static inline struct sgx_epc_lru_lists *sgx_lru_lists(struct sgx_epc_pag=
e *epc_page)
> +{
> +	return &sgx_global_lru;
> +}

I'd simply export sgx_global_lru.

> +static inline bool sgx_can_reclaim(void)
> +{
> +	return !list_empty(&sgx_global_lru.reclaimable);
> +}


Accessors for the object should be named so that this fact is reflected,
e.g. sgx_global_lru_can_reclaim() in this case.

I would just open code this to the call sites though.

> +
>  static atomic_long_t sgx_nr_free_pages =3D ATOMIC_LONG_INIT(0);
> =20
>  /* Nodes with one or more EPC sections. */
> @@ -339,6 +349,7 @@ size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool =
ignore_age)
>  	struct sgx_backing backing[SGX_NR_TO_SCAN_MAX];
>  	struct sgx_epc_page *epc_page, *tmp;
>  	struct sgx_encl_page *encl_page;
> +	struct sgx_epc_lru_lists *lru;
>  	pgoff_t page_index;
>  	LIST_HEAD(iso);
>  	size_t ret;
> @@ -372,10 +383,11 @@ size_t sgx_reclaim_epc_pages(size_t nr_to_scan, boo=
l ignore_age)
>  		continue;
> =20
>  skip:
> -		spin_lock(&sgx_global_lru.lock);
> +		lru =3D sgx_lru_lists(epc_page);
> +		spin_lock(&lru->lock);
>  		sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
> -		list_move_tail(&epc_page->list, &sgx_global_lru.reclaimable);
> -		spin_unlock(&sgx_global_lru.lock);
> +		list_move_tail(&epc_page->list, &lru->reclaimable);
> +		spin_unlock(&lru->lock);
> =20
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  	}
> @@ -399,7 +411,7 @@ size_t sgx_reclaim_epc_pages(size_t nr_to_scan, bool =
ignore_age)
>  static bool sgx_should_reclaim(unsigned long watermark)
>  {
>  	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
> -	       !list_empty(&sgx_global_lru.reclaimable);
> +		sgx_can_reclaim();
>  }
> =20
>  /*
> @@ -529,14 +541,16 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>   */
>  void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
>  {
> -	spin_lock(&sgx_global_lru.lock);
> +	struct sgx_epc_lru_lists *lru =3D sgx_lru_lists(page);
> +
> +	spin_lock(&lru->lock);
>  	WARN_ON_ONCE(sgx_epc_page_reclaimable(page->flags));
>  	page->flags |=3D flags;
>  	if (sgx_epc_page_reclaimable(flags))
> -		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
> +		list_add_tail(&page->list, &lru->reclaimable);
>  	else
> -		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
> -	spin_unlock(&sgx_global_lru.lock);
> +		list_add_tail(&page->list, &lru->unreclaimable);
> +	spin_unlock(&lru->lock);
>  }
> =20
>  /**
> @@ -551,15 +565,16 @@ void sgx_record_epc_page(struct sgx_epc_page *page,=
 unsigned long flags)
>   */
>  int sgx_drop_epc_page(struct sgx_epc_page *page)
>  {
> -	spin_lock(&sgx_global_lru.lock);
> +	struct sgx_epc_lru_lists *lru =3D sgx_lru_lists(page);
> +
> +	spin_lock(&lru->lock);
>  	if (sgx_epc_page_reclaim_in_progress(page->flags)) {
> -		spin_unlock(&sgx_global_lru.lock);
> +		spin_unlock(&lru->lock);
>  		return -EBUSY;
>  	}
> -
>  	list_del(&page->list);
>  	sgx_epc_page_reset_state(page);
> -	spin_unlock(&sgx_global_lru.lock);
> +	spin_unlock(&lru->lock);
> =20
>  	return 0;
>  }
> @@ -592,7 +607,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, =
bool reclaim)
>  			break;
>  		}
> =20
> -		if (list_empty(&sgx_global_lru.reclaimable))
> +		if (!sgx_can_reclaim())
>  			return ERR_PTR(-ENOMEM);
> =20
>  		if (!reclaim) {
> --=20
> 2.25.1

BR, Jarkko

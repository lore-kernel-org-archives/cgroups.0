From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 04/18] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Wed, 13 Sep 2023 18:00:54 +0300
Message-ID: <CVHVOJEJZEZ1.25VFM2W8FTU8R@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-5-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694617260;
        bh=HSdEtrygzqfkzkBkJZg8xVNxTnlq6f0NK4eV4pRksxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ll37QBssXbUE+/gqNfjCW21z6o4T/ILJpIF/+0yFJ1FdlmP4avuZsJ51DiMg4IWjf
         cZozJPQXEMV/0cGTn2pqze66C3QLiUPr6XWtNzjtzQWABjZHvAqmL2pA6OI37WQj6F
         fYCu2lo9yNyNG8RopMh9qkLEGwkr6+LNXgP84mj0DTR3UHVOp3713qYbkKnby9zWTR
         WtCMs7yqD+klI4HazpC91VAr/evuX+A3oSI2p9ZNS10ysXySp0ubYR1hBzYKaD0tZY
         N2PoSnetyh39vONDdSXUma9wmVJ7j/56QAeYUWPuE6VzlUZI3PNSRhUB8WFUynTPWA
         5DEkQUcS+d1ng==
In-Reply-To: <20230913040635.28815-5-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> All EPC pages of enclaves including VA and SECS will be tracked in

s/VA/Version Array (VA)/
s/SECS/SGX Enclave Control Structure (SECS)/

Just a nitpick, because it is always good to remind what these acronyms
are (there are so many of them in this world).

> sgx_epc_lru_lists structs, one per cgroup. For now just replace the
> existing sgx_active_page_list in the reclaimer and its spinlock with a
> global sgx_epc_lru_lists struct. VA and SECS pages are still not tracked
> at this point but they will be tracked after an unreclaimable LRU list
> is added to the sgx_epc_lru_lists struct.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> V4:
> - No change, only reordered the patch.
>
> V3:
> - Remove usage of list wrapper
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 39 +++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 166692f2d501..afce51d6e94a 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -26,10 +26,9 @@ static DEFINE_XARRAY(sgx_epc_address_space);
> =20
>  /*
>   * These variables are part of the state of the reclaimer, and must be a=
ccessed
> - * with sgx_reclaimer_lock acquired.
> + * with sgx_global_lru.lock acquired.
>   */
> -static LIST_HEAD(sgx_active_page_list);
> -static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> +static struct sgx_epc_lru_lists sgx_global_lru;
> =20
>  static atomic_long_t sgx_nr_free_pages =3D ATOMIC_LONG_INIT(0);
> =20
> @@ -304,13 +303,13 @@ static void sgx_reclaim_pages(void)
>  	int ret;
>  	int i;
> =20
> -	spin_lock(&sgx_reclaimer_lock);
> +	spin_lock(&sgx_global_lru.lock);
>  	for (i =3D 0; i < SGX_NR_TO_SCAN; i++) {
> -		if (list_empty(&sgx_active_page_list))
> +		epc_page =3D list_first_entry_or_null(&sgx_global_lru.reclaimable,
> +						    struct sgx_epc_page, list);
> +		if (!epc_page)
>  			break;
> =20
> -		epc_page =3D list_first_entry(&sgx_active_page_list,
> -					    struct sgx_epc_page, list);
>  		list_del_init(&epc_page->list);
>  		encl_page =3D epc_page->owner;
> =20
> @@ -322,7 +321,7 @@ static void sgx_reclaim_pages(void)
>  			 */
>  			epc_page->flags &=3D ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
>  	}
> -	spin_unlock(&sgx_reclaimer_lock);
> +	spin_unlock(&sgx_global_lru.lock);
> =20
>  	for (i =3D 0; i < cnt; i++) {
>  		epc_page =3D chunk[i];
> @@ -345,9 +344,9 @@ static void sgx_reclaim_pages(void)
>  		continue;
> =20
>  skip:
> -		spin_lock(&sgx_reclaimer_lock);
> -		list_add_tail(&epc_page->list, &sgx_active_page_list);
> -		spin_unlock(&sgx_reclaimer_lock);
> +		spin_lock(&sgx_global_lru.lock);
> +		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
> +		spin_unlock(&sgx_global_lru.lock);
> =20
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> =20
> @@ -378,7 +377,7 @@ static void sgx_reclaim_pages(void)
>  static bool sgx_should_reclaim(unsigned long watermark)
>  {
>  	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
> -	       !list_empty(&sgx_active_page_list);
> +	       !list_empty(&sgx_global_lru.reclaimable);
>  }
> =20
>  /*
> @@ -430,6 +429,8 @@ static bool __init sgx_page_reclaimer_init(void)
> =20
>  	ksgxd_tsk =3D tsk;
> =20
> +	sgx_lru_init(&sgx_global_lru);
> +
>  	return true;
>  }
> =20
> @@ -505,10 +506,10 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>   */
>  void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
>  {
> -	spin_lock(&sgx_reclaimer_lock);
> +	spin_lock(&sgx_global_lru.lock);
>  	page->flags |=3D SGX_EPC_PAGE_RECLAIMER_TRACKED;
> -	list_add_tail(&page->list, &sgx_active_page_list);
> -	spin_unlock(&sgx_reclaimer_lock);
> +	list_add_tail(&page->list, &sgx_global_lru.reclaimable);
> +	spin_unlock(&sgx_global_lru.lock);
>  }
> =20
>  /**
> @@ -523,18 +524,18 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page =
*page)
>   */
>  int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
>  {
> -	spin_lock(&sgx_reclaimer_lock);
> +	spin_lock(&sgx_global_lru.lock);
>  	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
>  		/* The page is being reclaimed. */
>  		if (list_empty(&page->list)) {
> -			spin_unlock(&sgx_reclaimer_lock);
> +			spin_unlock(&sgx_global_lru.lock);
>  			return -EBUSY;
>  		}
> =20
>  		list_del(&page->list);
>  		page->flags &=3D ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
>  	}
> -	spin_unlock(&sgx_reclaimer_lock);
> +	spin_unlock(&sgx_global_lru.lock);
> =20
>  	return 0;
>  }
> @@ -567,7 +568,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, =
bool reclaim)
>  			break;
>  		}
> =20
> -		if (list_empty(&sgx_active_page_list))
> +		if (list_empty(&sgx_global_lru.reclaimable))
>  			return ERR_PTR(-ENOMEM);
> =20
>  		if (!reclaim) {
> --=20
> 2.25.1

Other than that looks good to me (including the commit description).

BR, Jarkko

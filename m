From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 08/18] x86/sgx: Use a list to track to-be-reclaimed
 pages
Date: Wed, 13 Sep 2023 18:30:11 +0300
Message-ID: <CVHWAYNF4W0Y.12Y1RIQ3M41CL@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-9-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694619017;
        bh=lKT1zCMPEo4WR6takfNQBJuex3ue1YKnaoqmS2NcXV4=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=SIZlypX6riIxigq0tGcN+L3buHFetTGzAsko/rwijlw+UQaEeIFUv1TDUyh34cOJg
         J2u61GpDM8H1dTC6YM3GRCQ+1KmZBkXU4MX3ItdkvzXTlNhptk/6UJ6A/9RT838m38
         NbONnCFWbdO9wexOvpM8DcSIYvo91pgl19Wmqjp+wQEPTvdEUbRnHmfuUM3kfMGkhd
         F7qqCQ+spbLf3mPVjB04U5nHDLlnphQHTA32xV/TsA8BXR1aiVbCzSD9Esq0s89E9b
         SIysmnzsrXvS1tdRHbxQuTqrYQcb0cXSfkIKRBOILRrt8M4beSDJJ7K0I/wOpunXkf
         TfEDv80rQgxiw==
In-Reply-To: <20230913040635.28815-9-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Change sgx_reclaim_pages() to use a list rather than an array for
> storing the epc_pages which will be reclaimed. This change is needed
> to transition to the LRU implementation for EPC cgroup support.
>
> When the EPC cgroup is implemented, the reclaiming process will do a
> pre-order tree walk for the subtree starting from the limit-violating
> cgroup.  When each node is visited, candidate pages are selected from
> its "reclaimable" LRU list and moved into this temporary list. Passing a
> list from node to node for temporary storage in this walk is more
> straightforward than using an array.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang<haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> V4:
> - Changes needed for patch reordering
> - Revised commit message
>
> V3:
> - Removed list wrappers
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 40 +++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index c1ae19a154d0..fba06dc5abfe 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -293,12 +293,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page=
 *epc_page,
>   */
>  static void sgx_reclaim_pages(void)
>  {
> -	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>  	struct sgx_backing backing[SGX_NR_TO_SCAN];
> +	struct sgx_epc_page *epc_page, *tmp;
>  	struct sgx_encl_page *encl_page;
> -	struct sgx_epc_page *epc_page;
>  	pgoff_t page_index;
> -	int cnt =3D 0;
> +	LIST_HEAD(iso);
>  	int ret;
>  	int i;
> =20
> @@ -314,18 +313,22 @@ static void sgx_reclaim_pages(void)
> =20
>  		if (kref_get_unless_zero(&encl_page->encl->refcount) !=3D 0) {
>  			sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
> -			chunk[cnt++] =3D epc_page;
> +			list_move_tail(&epc_page->list, &iso);
>  		} else {
> -			/* The owner is freeing the page. No need to add the
> -			 * page back to the list of reclaimable pages.
> +			/* The owner is freeing the page, remove it from the
> +			 * LRU list
>  			 */
>  			sgx_epc_page_reset_state(epc_page);
> +			list_del_init(&epc_page->list);
>  		}
>  	}
>  	spin_unlock(&sgx_global_lru.lock);
> =20
> -	for (i =3D 0; i < cnt; i++) {
> -		epc_page =3D chunk[i];
> +	if (list_empty(&iso))
> +		return;
> +
> +	i =3D 0;
> +	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
>  		encl_page =3D epc_page->owner;
> =20
>  		if (!sgx_reclaimer_age(epc_page))
> @@ -340,6 +343,7 @@ static void sgx_reclaim_pages(void)
>  			goto skip;
>  		}
> =20
> +		i++;
>  		encl_page->desc |=3D SGX_ENCL_PAGE_BEING_RECLAIMED;
>  		mutex_unlock(&encl_page->encl->lock);
>  		continue;
> @@ -347,27 +351,19 @@ static void sgx_reclaim_pages(void)
>  skip:
>  		spin_lock(&sgx_global_lru.lock);
>  		sgx_epc_page_set_state(epc_page, SGX_EPC_PAGE_RECLAIMABLE);
> -		list_add_tail(&epc_page->list, &sgx_global_lru.reclaimable);
> +		list_move_tail(&epc_page->list, &sgx_global_lru.reclaimable);
>  		spin_unlock(&sgx_global_lru.lock);
> =20
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> -
> -		chunk[i] =3D NULL;
> -	}
> -
> -	for (i =3D 0; i < cnt; i++) {
> -		epc_page =3D chunk[i];
> -		if (epc_page)
> -			sgx_reclaimer_block(epc_page);
>  	}
> =20
> -	for (i =3D 0; i < cnt; i++) {
> -		epc_page =3D chunk[i];
> -		if (!epc_page)
> -			continue;
> +	list_for_each_entry(epc_page, &iso, list)
> +		sgx_reclaimer_block(epc_page);
> =20
> +	i =3D 0;
> +	list_for_each_entry_safe(epc_page, tmp, &iso, list) {
>  		encl_page =3D epc_page->owner;
> -		sgx_reclaimer_write(epc_page, &backing[i]);
> +		sgx_reclaimer_write(epc_page, &backing[i++]);
> =20
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  		sgx_epc_page_reset_state(epc_page);
> --=20
> 2.25.1

LGTM

BR, Jarkko

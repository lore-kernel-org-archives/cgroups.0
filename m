From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 11/18] x86/sgx: store unreclaimable pages in LRU
 lists
Date: Wed, 13 Sep 2023 18:33:07 +0300
Message-ID: <CVHWD79XTNDZ.11P43GDNRS5U0@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-12-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694619192;
        bh=wVm1k0TOJbmKVKWtuApWJmUkPsOLAVzqcEkW45pG0t8=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=UHmcKKx5qUnYnb3/0P1QEmNeWfQB7o945kzpJpRvn/Z92HHaHAUML/t2cTbqRoidQ
         E2pLQDQJIagjk3Q0tdjmgeQArmROhqE4QgDVcP2tBGPi4Y7UI4xHsZ6ALXSG/28bvJ
         tktQcKyEvje4mTuClGdKF/gQsXLPD2rZKXwt9PHsITYO78CNA0AUnpwqQ73L7a6/eL
         O5RwXhxJgwOAnMPXULx9759yl+CSF5PLCblaAj0vx+J1o6oWDgsJRjgLTIyUKKxL3i
         Uh/3aaoXHCiYixp2HWNgAHdoGOC9O3+vHCxrNKtcQ+0V+koodiJ6WNknO4l+vMM1tO
         eWbZHrXoeDDYQ==
In-Reply-To: <20230913040635.28815-12-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> When an OOM event occurs, all pages associated with an enclave will need
> to be freed, including pages that are not currently tracked by the
> cgroup LRU lists.
>
> Add a new "unreclaimable" list to the sgx_epc_lru_lists struct and
> update the "sgx_record/drop_epc_pages()" functions for adding/removing
> VA and SECS pages to/from this "unreclaimable" list.
>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> V4:
> - Updates for patch reordering.
> - Revised commit messages.
> - Revised comments for the list.
>
> V3:
> - Removed tracking virtual EPC pages in unreclaimable list as host
> kernel does not reclaim them. The EPC cgroups implemented later only
> blocks allocating for a guest if the limit is reached by returning
> -ENOMEM from sgx_alloc_epc_page() called by virt_epc, and does nothing
> else. Therefore, no need to track those in LRU lists.
> ---
>  arch/x86/kernel/cpu/sgx/encl.c  | 2 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
>  arch/x86/kernel/cpu/sgx/main.c  | 3 +++
>  arch/x86/kernel/cpu/sgx/sgx.h   | 8 +++++++-
>  4 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 91f83a5e543d..bf0ac3677ca8 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -748,6 +748,7 @@ void sgx_encl_release(struct kref *ref)
>  	xa_destroy(&encl->page_array);
> =20
>  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> +		sgx_drop_epc_page(encl->secs.epc_page);
>  		sgx_encl_free_epc_page(encl->secs.epc_page);
>  		encl->secs.epc_page =3D NULL;
>  	}
> @@ -756,6 +757,7 @@ void sgx_encl_release(struct kref *ref)
>  		va_page =3D list_first_entry(&encl->va_pages, struct sgx_va_page,
>  					   list);
>  		list_del(&va_page->list);
> +		sgx_drop_epc_page(va_page->epc_page);
>  		sgx_encl_free_epc_page(va_page->epc_page);
>  		kfree(va_page);
>  	}
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/io=
ctl.c
> index 95ec20a6992f..8c23bb524674 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -48,6 +48,7 @@ void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_=
va_page *va_page)
>  	encl->page_cnt--;
> =20
>  	if (va_page) {
> +		sgx_drop_epc_page(va_page->epc_page);
>  		sgx_encl_free_epc_page(va_page->epc_page);
>  		list_del(&va_page->list);
>  		kfree(va_page);
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index ed813288af44..f3a3ed894616 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -268,6 +268,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *=
epc_page,
>  			goto out;
> =20
>  		sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
> +		sgx_drop_epc_page(encl->secs.epc_page);
>  		sgx_encl_free_epc_page(encl->secs.epc_page);
>  		encl->secs.epc_page =3D NULL;
> =20
> @@ -510,6 +511,8 @@ void sgx_record_epc_page(struct sgx_epc_page *page, u=
nsigned long flags)
>  	page->flags |=3D flags;
>  	if (sgx_epc_page_reclaimable(flags))
>  		list_add_tail(&page->list, &sgx_global_lru.reclaimable);
> +	else
> +		list_add_tail(&page->list, &sgx_global_lru.unreclaimable);
>  	spin_unlock(&sgx_global_lru.lock);
>  }
> =20
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.=
h
> index e06b4aadb6a1..e210af77f0cf 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -150,17 +150,23 @@ static inline void *sgx_get_epc_virt_addr(struct sg=
x_epc_page *page)
>  }
> =20
>  /*
> - * Tracks EPC pages reclaimable by the reclaimer (ksgxd).
> + * Contains EPC pages tracked by the reclaimer (ksgxd).
>   */
>  struct sgx_epc_lru_lists {
>  	spinlock_t lock;
>  	struct list_head reclaimable;
> +	/*
> +	 * Tracks SECS, VA pages,etc., pages only freeable after all its
> +	 * dependent reclaimables are freed.
> +	 */
> +	struct list_head unreclaimable;
>  };
> =20
>  static inline void sgx_lru_init(struct sgx_epc_lru_lists *lrus)
>  {
>  	spin_lock_init(&lrus->lock);
>  	INIT_LIST_HEAD(&lrus->reclaimable);
> +	INIT_LIST_HEAD(&lrus->unreclaimable);
>  }
> =20
>  struct sgx_epc_page *__sgx_alloc_epc_page(void);
> --=20
> 2.25.1

LGTM

BR, Jarkko

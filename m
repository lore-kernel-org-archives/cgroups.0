From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 03/28] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Mon, 17 Jul 2023 12:45:36 +0000
Message-ID: <CU4GHCJTRKLZ.1RK23NWPHJGNI@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-4-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689597941;
        bh=gO1fpIF4DrAPNB+QftjUHUJdhOei+AxWsZlYNQnSN+E=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=tMsP/BQ24EY3ad0FkSEF2GXd7wj/sMcuwrJdufSy1jZNXzcdRqx7rGNvPMwYUezXm
         zuPMvxT97kn3WQMolnkDvbWiywN5xoSsdCOZQ2Yv5hIHiGv4uyrVW8W9zrtpswA+rk
         zumJ26mCSHg1oa0pyZKDDTkTk8Wh5ExfiF6CQA/bb7VzFZ/2tzquH81WNw5hiaS7Lw
         YGttfb3x0HJEoqB0FQUMfUqy/aAzRG/zbgolX8CzyNFgp3eWEfikQbIxR55YrCsudK
         yRShGGCil31NE7bWJNz0M7meW7BDYJVaLWDGqT2S9To1jLrCUcJs6iRyzpwTJNOI6F
         K74NG/tTBoZPg==
In-Reply-To: <20230712230202.47929-4-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Introduce a data structure to wrap the existing reclaimable list
> and its spinlock in a struct to minimize the code changes needed
> to handle multiple LRUs as well as reclaimable and non-reclaimable
> lists. The new structure will be used in a following set of patches to
> implement SGX EPC cgroups.
>
> The changes to the structure needed for unreclaimable lists will be
> added in later patches.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> V3:
> Removed the helper functions and revised commit messages
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.=
h
> index f6e3c5810eef..77fceba73a25 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -92,6 +92,23 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_e=
pc_page *page)
>  	return section->virt_addr + index * PAGE_SIZE;
>  }
> =20
> +/*
> + * This data structure wraps a list of reclaimable EPC pages, and a list=
 of
> + * non-reclaimable EPC pages and is used to implement a LRU policy durin=
g
> + * reclamation.
> + */
> +struct sgx_epc_lru_lists {
> +	/* Must acquire this lock to access */
> +	spinlock_t lock;

Isn't this self-explanatory, why the inline comment?

> +	struct list_head reclaimable;
> +};
> +
> +static inline void sgx_lru_init(struct sgx_epc_lru_lists *lrus)
> +{
> +	spin_lock_init(&lrus->lock);
> +	INIT_LIST_HEAD(&lrus->reclaimable);
> +}
> +
>  struct sgx_epc_page *__sgx_alloc_epc_page(void);
>  void sgx_free_epc_page(struct sgx_epc_page *page);
> =20
> --=20
> 2.25.1


BR, Jarkko

From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate
 LRU lists
Date: Wed, 13 Sep 2023 12:46:16 +0300
Message-ID: <CVHOZMZHDPIE.225HW6UH95GX9@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-4-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694598381;
        bh=TAuV6GLlzFJQ0bcVvBb3QY5ZH6PaZoo0XdL+52Pgtuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/13rqsUiPDMmHD9VWDHTbqsJaNpGA11cTKPDjP4oG/c+WCkr0vbuhN1l9hXFj+vP
         9OAImUb5s4eaqcw3AonTOX1njYNZYagpu86/pIj/JEt94V3DRiHIyJLErMis5fQQgJ
         pQipWwYFU6tr5jzYHDLocr4llbHftb8tVxbC3xEj4+FsedSnmkGsDgddD51vK37D5s
         vGA3avJUK445jHoei9o3ernFZ8PpRNeNlooULEgghfQ2t5p+SyWjTMM36wmGEG/DG4
         XIAR2eMET9cODcaTuPt/9RgYjk+TENyCkLu6syLQQS86WMo5NeJ7GZQhxopjzRBCZw
         Ls6lYmHxdJA1w==
In-Reply-To: <20230913040635.28815-4-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Introduce a data structure to wrap the existing reclaimable list and its
> spinlock. Each cgroup later will have one instance of this structure to
> track EPC pages allocated for processes associated with the same cgroup.
> Just like the global SGX reclaimer (ksgxd), an EPC cgroup reclaims pages
> from the reclaimable list in this structure when its usage reaches near
> its limit.
>
> Currently, ksgxd does not track the VA, SECS pages. They are considered
> as 'unreclaimable' pages that are only deallocated when their respective
> owning enclaves are destroyed and all associated resources released.
>
> When an EPC cgroup can not reclaim any more reclaimable EPC pages to
> reduce its usage below its limit, the cgroup must also reclaim those
> unreclaimables by killing their owning enclaves. The VA and SECS pages
> later are also tracked in an 'unreclaimable' list added to this structure
> to support this OOM killing of enclaves.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> V4:
> - Removed unneeded comments for the spinlock and the non-reclaimables.
> (Kai, Jarkko)
> - Revised the commit to add introduction comments for unreclaimables and
> multiple LRU lists.(Kai)
> - Reordered the patches: delay all changes for unreclaimables to
> later, and this one becomes the first change in the SGX subsystem.
>
> V3:
> - Removed the helper functions and revised commit messages.
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.=
h
> index d2dad21259a8..018414b2abe8 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -83,6 +83,20 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_e=
pc_page *page)
>  	return section->virt_addr + index * PAGE_SIZE;
>  }
> =20
> +/*
> + * Tracks EPC pages reclaimable by the reclaimer (ksgxd).
> + */
> +struct sgx_epc_lru_lists {
> +	spinlock_t lock;
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
>

Looks good but not yet time for ack'ing.

BR, Jarkko

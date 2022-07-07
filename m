From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Date: Thu, 7 Jul 2022 21:08:36 +0000
Message-ID: <YsdLVBtl16mx3+Ot@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z0i/FsEtEYZWQoqmAH7Voc71S2cgw06FoAKusiT8OZ4=;
        b=WoU0PSQ0Wj5Vhi5VAdOixoxhmqcmoNDkx6vHqBySeC9zqf2nqsQfssDemp0HQ+Ov1B
         x/J5MxoGXzLdJH5GEyRAbOhWT68fOGc+6rHAXDByBx1OVQfP46gGjK+Mi+BzW6aTzy1J
         zCmFPJ2SlEc+diWQW3EPCjFu0t4IWIGEdVT9pGCnFTtf0M7aL/JzkavojLQOy4s/UgNF
         NGApv5Q7B2F5jgchJKAeNIaqUXEoBZLJR5OdL0c5HU9ZNIBlR45kMkufdSbiFomJXlCl
         /ZAg/DkWLMF98iVndrnP9vxLYNAXMsIgTDVMZU2Ziwpk1aIQXpLAs3/2s4PDhY8kMxbt
         LAVQ==
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWNGWvitb5QawA@public.gmane.org

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in memory
> secondary pagetable stats. This function will be used by subsequent
> patches in different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/kvm_host.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3b40f8d68fbb1..032821d77e920 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If more than one page is being (un)accounted, @virt must be the address of
> + * the first page of a block of pages what were allocated together (i.e
> + * accounted together).

Sorry for the belated thoughts...

If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
mmu_lock for read.

> + */
> +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> +{
> +	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 

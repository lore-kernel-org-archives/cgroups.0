From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Date: Mon, 27 Jun 2022 16:20:04 +0000
Message-ID: <YrnYtMGmGDxCrwdv@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6X68KuyBDU81KFCllZcPJCpgvdaKM9lp1nYP5LV1kY=;
        b=QYuHqx8JmD3fGZhFw9UuYiMUgaHHG5YjGJZr+BhXEcVvOKmxYAAHNIYT4pML0YKcd9
         UOpJZM3FxgCDYFkMEGVBOlFqLEi8hSMYRQnc+e7vRrYWrYSatKpLhI/fy9hbjAzv1Pnb
         Fzbk/A5QTs7U7PdF27OM5n8DIpWN30JeOZDLCACOEVdlNkDU2Q35PBJKkpYSbiWrD6Tw
         wUqWe7xVXLUA8Y8WFwrTpTXlCat4Ci9KWWfxvDWzzZ/KX8yqgOjmViXM2APbm4qweJdE
         PTl/Ci9fvhKr/8UGP8qNqQ7aXyTDMrVnpzr/DD4SM5yQhjeV+eXwvVZzqlB5dla5a1gv
         MANA==
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY@public.gmane.org

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in secondary
> pagetable stats. This function will be used by subsequent patches in
> different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 883e86ec8e8c4..645585f3a4bed 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2246,6 +2246,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If nr > 1, we assume virt is the address of the first page of a block of

But what if @nr is -2, which is technically less than 1?  :-)

> + * pages that were allocated together (i.e accounted together).

Don't document assumptions, document the rules.  And avoid "we", pronouns are
ambiguous, e.g. is "we" the author, or KVM, or something else entirely?

/*
 * If more than one page is being (un)accounted, @virt must be the address of
 * the first page of a block of pages what were allocated together.
 */


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
> 2.36.1.255.ge46751e96f-goog
> 

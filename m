From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Date: Tue, 12 Jul 2022 16:03:37 -0700
Message-ID: <CAJD7tkZ-r7O1AD8kAUgoY0Y2RNQkBpbtmtKpq68xN4PO=fzPnw@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com> <YsdLVBtl16mx3+Ot@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0kilpuaWkkH1jWKZwcnpv75y3bBAyVMGJWLT8pq7Zew=;
        b=ZBE5KGyRMkxibp5iaQK1l2yLFQs3jMAWpu5gwk0mkKX4ubei8nAy3KENVxr6zAoHjv
         GxxAukLzTPcow4xb39vYwDGdcaSRPa60fmvrQz7t5M+INg1M5ckPSC915vA9q2vN94AD
         /SGqziGRgsU+lRLMnfhy3E5QN+LwNKSm54tmpu0mNnq5YnUHuf05goqCVAxNqaaAiN6B
         kCkPthpHgFI7wBZw9z3V/ubta+xmhbhQHRM/O5EcP+46woLYQpwn+fg2Dj/B6KQdkz8q
         cxYdjJT7Re3j22yGvnr+ktEYQOKJ6wkxisMXfv/a2tIwVaodgTZvM0zkiXaKA3U/CSDX
         wuPw==
In-Reply-To: <YsdLVBtl16mx3+Ot@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, Huang@google.com, Shaoqin <shaoqin.huang@intel.com>, Cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel>

On Thu, Jul 7, 2022 at 2:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > Add a helper to account pages used by KVM for page tables in memory
> > secondary pagetable stats. This function will be used by subsequent
> > patches in different archs.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3b40f8d68fbb1..032821d77e920 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
> >  }
> >  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> >
> > +/*
> > + * If more than one page is being (un)accounted, @virt must be the address of
> > + * the first page of a block of pages what were allocated together (i.e
> > + * accounted together).
>
> Sorry for the belated thoughts...
>
> If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
> itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
> mmu_lock for read.
>

Sure! I will send a v7 anyway to address the comments on patch 1. Thanks!

> > + */
> > +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> > +{
> > +     mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> > +}
> > +
> >  /*
> >   * This defines how many reserved entries we want to keep before we
> >   * kick the vcpu to the userspace to avoid dirty ring full.  This
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >

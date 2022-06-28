From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by KVM MMU.
Date: Tue, 28 Jun 2022 22:09:36 +0000
Message-ID: <20220628220938.3657876-3-yosryahmed@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hqFBlBT797q6Bk+fNjYVKQU7mV5jV3ma9qnt5KK3uBo=;
        b=JEAq+g+yt98HJQFYcbZo11EgdQCrTknULQcgOojyYtX5/1qIJPFoMDpUb0JvS07kBs
         UBB0lOj3a7XuYN+RxZH7OqEQNbrIbIfwbCX+Napc1EFMPMrzrqRPrpv6TLBnEGIk4l6e
         D8NTKSe14qutuJxDTg6f/mJOdQOL1xHUrqnK3PlzvOfoI2lI6HUiSSkGIdpK0f7vh6H4
         6O9GKuEoHUyXKiAyRapcd/Jdby2QsOa/y878lIAO/AkXQnUJ/iuK6p0Jig+0f5ZboxYv
         e9Ap/B7iZODIQKB3o8NbA9y6v8baiPB6zs+62vjyZxY29inV33HeqiOuSq0QsRfR0U2q
         Gycw==
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: Huang@google.com, Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>

Add a helper to account pages used by KVM for page tables in memory
secondary pagetable stats. This function will be used by subsequent
patches in different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b40f8d68fbb1..032821d77e920 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.37.0.rc0.161.g10f37bed90-goog


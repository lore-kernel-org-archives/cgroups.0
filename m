From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v7 2/4] KVM: mmu: add a helper to account memory used by KVM
 MMU.
Date: Tue, 23 Aug 2022 00:46:37 +0000
Message-ID: <20220823004639.2387269-3-yosryahmed@google.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=5wbHjJjCu3OWrOn0g8QSFmD92QscX6sNHkdnPnrNJvc=;
 b=GGOXmJOAwFS6LKwoOWp4bp7t6wNw/r+7YZKC8GNGkd18DnlB6LfP9CL34RL2KPfceG
 AXZl8PPfPtapEOLbCmJ/rNGm5f6yciTGJoywKkjojZNxw+GL1YEMWcjzDhmGBCk/MdMy
 4t7Q1LoMp7rN7dy2pMFqxMAJGP7jixHUwhGq1q/8ObLjXUCDxT+pRv0n8APeUo1COdXm
 hZwjDYvOa5gy4NpGGIl+jhzRr9f9Ii2wUpWXASQIPm5HwhVrZhUzyQI6uum045xl3TUP
 3jXo+RDzJG2rD4y1NqG9xsCTA/WKZF3fW3AxCEi9F87GMBLRezoaX2KOatGvk8ccetqZ
 Mr+Q==
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Huang@google.com, Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org

Add a helper to account pages used by KVM for page tables in memory
secondary pagetable stats. This function will be used by subsequent
patches in different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..04c7e5f2f727 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2247,6 +2247,19 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
+ *
+ * kvm_account_pgtable_pages() is thread-safe because mod_lruvec_page_state()
+ * is thread-safe.
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
2.37.1.595.g718a3a8f04-goog

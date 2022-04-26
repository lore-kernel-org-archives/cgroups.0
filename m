From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/6] KVM: mmu: add a helper to account page table pages
 used by KVM.
Date: Tue, 26 Apr 2022 05:39:00 +0000
Message-ID: <20220426053904.3684293-3-yosryahmed@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=75ck2E1viXT4HNKGmhZGUqApOq35yGNlgD3kbgrzKrw=;
        b=j/6W1Jv8f36ZodhL68vNcySdndUH2oV1c5OzKpRXYolTLJgwBi7OaIg/S/yKMnJp+b
         lqqaZUm1JBr3oQixRNwaNTgB81/saUAppnPAjz68yxAbmgh4igyoOQ92n9+HzD+TEgqv
         ajW2TFBTyLuEXXVz0pJuHgyUGpGRZnhkjtQoBS+4am6LkE8kl60VYw6Q/6q6/jo9xQNu
         GX4i53uLVaKJIRtdwjxSSMxM+nKgqH6qhEODIoJjq5XuOby3Ip1qDLu+YxucaAIrUMzY
         Psb6biLd1G6xVSJaPjnJffEREeUS4oL482CYqW+UsriFD7QsTwFn/nDOVqJKFywwwAfj
         8XNg==
In-Reply-To: <20220426053904.3684293-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huacai Chen <chenhuacai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksandar Markovic <aleksandar.qemu.devel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anup Patel <anup-aa5cPYPs4nSSZfiimGR9Ow@public.gmane.org>, Atish Patra <atishp-WKKQYwWt7ev9JmXXK+q4OQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Shameer Kolothum <shameerali.kolothum.thodi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mips-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-riscv-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a helper to account pages used by KVM for page tables as pagetable
stats. This function will be used by subsequent patches in different
archs.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..54cc4634053c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2221,6 +2221,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If nr > 1, we assume virt is the address of the first page of a block of
+ * pages that were allocated together (i.e accounted together).
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
2.36.0.rc2.479.g8af0fa9b8e-goog


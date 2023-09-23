From: Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v5 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate LRU lists
Date: Fri, 22 Sep 2023 20:06:42 -0700
Message-ID: <20230923030657.16148-4-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438422; x=1726974422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bl38Qf8S1sTRN04lW2YFAodcrfy1L4fMzLvJCxC13/E=;
  b=axsybe+aDrMZ0KkfyOZE9abRzGIrB+i9eofz2fJIqTumnixBlfciEw/J
   BjAHBdIdT3EsEXyMnzw1qWyWBt7rnlOO5JOFHQnivhXm3t172kkst+HRh
   /at8+1vb/bVeCYz4vux0aBYwivGQOeh7x6jlSVc8XCoBA9QR5SJKU0YAQ
   H6WSpVD4LWUhDqnzWUgx4BtFop4FR8EaepmRI82Tcjp3rdecVL2poYJ/V
   WJJEqKo+VqNp2YhWzazf2D1/lDkd0mn70MT3WyZvxzXkAafyOsU0+C0HK
   po6BgD5azrljYiJL9G7g3R/wYC+tbmCC79Vw6q+0WyfQJVqDxyGu89eHv
   Q==;
In-Reply-To: <20230923030657.16148-1-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com
Cc: zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce a data structure to wrap the existing reclaimable list and its
spinlock. Each cgroup later will have one instance of this structure to
track EPC pages allocated for processes associated with the same cgroup.
Just like the global SGX reclaimer (ksgxd), an EPC cgroup reclaims pages
from the reclaimable list in this structure when its usage reaches near
its limit.

Currently, ksgxd does not track the VA, SECS pages. They are considered
as 'unreclaimable' pages that are only deallocated when their respective
owning enclaves are destroyed and all associated resources released.

When an EPC cgroup can not reclaim any more reclaimable EPC pages to
reduce its usage below its limit, the cgroup must also reclaim those
unreclaimables by killing their owning enclaves. The VA and SECS pages
later are also tracked in an 'unreclaimable' list added to this structure
to support this OOM killing of enclaves.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Co-developed-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
---
V4:
- Removed unneeded comments for the spinlock and the non-reclaimables.
(Kai, Jarkko)
- Revised the commit to add introduction comments for unreclaimables and
multiple LRU lists.(Kai)
- Reordered the patches: delay all changes for unreclaimables to
later, and this one becomes the first change in the SGX subsystem.

V3:
- Removed the helper functions and revised commit messages.
---
 arch/x86/kernel/cpu/sgx/sgx.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..018414b2abe8 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -83,6 +83,20 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 	return section->virt_addr + index * PAGE_SIZE;
 }
 
+/*
+ * Tracks EPC pages reclaimable by the reclaimer (ksgxd).
+ */
+struct sgx_epc_lru_lists {
+	spinlock_t lock;
+	struct list_head reclaimable;
+};
+
+static inline void sgx_lru_init(struct sgx_epc_lru_lists *lrus)
+{
+	spin_lock_init(&lrus->lock);
+	INIT_LIST_HEAD(&lrus->reclaimable);
+}
+
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 void sgx_free_epc_page(struct sgx_epc_page *page);
 
-- 
2.25.1


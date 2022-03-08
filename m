From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] KVM: use vcalloc/__vcalloc for very large allocations
Date: Tue,  8 Mar 2022 05:59:18 -0500
Message-ID: <20220308105918.615575-4-pbonzini@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u7L8HPCDt5lQJUN1tDnCrctmaA+f57JR/0xy1mw5PmA=;
        b=KYQhFmY7UEoMFb2ynyQH8Xb+tc1z8t8QIVTxQmsjVtWmfNOsAl35qwtCRfsqoQfydFPf8e
        AeHF1T9osBmrkJCnc/3DXu70bIun+9cvq2J8V0OXv5cO160xjkR+CZd7UEh67InImR2BAH
        teLb+rTNZabvj15th83frL4SV+EJTiY=
In-Reply-To: <20220308105918.615575-1-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Allocations whose size is related to the memslot size can be arbitrarily
large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
sizes that fit in 32 bits.  Now that it is available, they can use either
vcalloc or __vcalloc, the latter if accounting is required.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 arch/x86/kvm/mmu/page_track.c      | 7 ++++---
 arch/x86/kvm/x86.c                 | 4 ++--
 virt/kvm/kvm_main.c                | 4 ++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e414ca44839f..be441403925b 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -251,7 +251,7 @@ int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	p->pfns = vzalloc(array_size(slot->npages, sizeof(*p->pfns)));
+	p->pfns = vcalloc(slot->npages, sizeof(*p->pfns));
 	if (!p->pfns) {
 		kfree(p);
 		return -ENOMEM;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 68eb1fb548b6..2e09d1b6249f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -47,8 +47,8 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 			continue;
 
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				 GFP_KERNEL_ACCOUNT);
+			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
+				  GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
 	}
@@ -75,7 +75,8 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 	if (slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE])
 		return 0;
 
-	gfn_track = kvcalloc(slot->npages, sizeof(*gfn_track), GFP_KERNEL_ACCOUNT);
+	gfn_track = __vcalloc(slot->npages, sizeof(*gfn_track),
+			      GFP_KERNEL_ACCOUNT);
 	if (gfn_track == NULL)
 		return -ENOMEM;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f79bf4552082..4fa4d8269e5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11838,7 +11838,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 		if (slot->arch.rmap[i])
 			continue;
 
-		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
+		slot->arch.rmap[i] = __vcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
 			return -ENOMEM;
@@ -11875,7 +11875,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = __vcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c941b97fa133..a5726099df67 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1274,9 +1274,9 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = __vcalloc(2, dirty_bytes, GFP_KERNEL_ACCOUNT);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 
-- 
2.31.1


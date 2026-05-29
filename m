Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04C33E1688;
	Fri, 29 May 2026 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057187; cv=none; b=FbgME5prBXFNPVs6bhlz2TWxi7pAwq4hlxF6gBIWKEQt3u1gnVaqE0MFKED7HD0M+lF/CcWTMxtbrnZ9iMgRQlY9GELmU7om9ySXaH7vnZwf5fRSsxQlwEbfdj631bE1HO1YS5z3qY1WhD8BJkH4OQovFhTRvCm2YO9Yg1TdGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057187; c=relaxed/simple;
	bh=2jOwB81hIiabcdQV76BP550VxG9p9yrp8SjCpV0ZmVA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=riD4vmIQhf8TWP8ze3Vnsd0jOg6eeMryNcKqK4Jqshn4mhIpEni2CcehVZSKZ40aSNuZaI9G4TzHR1zQC1IRYULPHULQGD9SNjTTDBEYAk7/RiOfe1zdgQlhGK2SBtbe5GuXSKtdSkYKv88zaDalBiNHbhiQAQvOyKj5Nyp4vb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=xYlebyWJ; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="xYlebyWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057183; bh=cGeZMeV+6Toy2BfwU50kHDN1vTufg8/wOGuq0DvP3ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYlebyWJ6iNwSk68CRHjhw0IyNqkx2uaU+DJwpaoVhlC+UHcNa1NzcvVgU8zTlrrX
	 UEBFmK3fiyKWgTZuq/tIKSePlxCtX+GvRTLfefN3WEC7gT++na7N+Uei+c5ZLtLCBP
	 P1L/wO9xJFb7QTN4kQWiB+bTYWUS8exkZ4hUwe9g=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057180tkgo7kc1y
Message-ID: <tencent_A2335C92CF3C8A7EF3121E4A23D437531608@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+XlrNUl1Lxurg2YUpupTBj+94wLieCfHcv0JrqBr9ojPlIzbJqI
	 x386pIbILgiph0fcnAAdez/p4vVKlgRXojF+wmEB5ZY7a9m7zElx+jUi6NEpdq6D3+uxyqpjhCgI
	 WNrxNLKhLIMM9915NjPrml5pw1rOJY8NCxptsD4LYTdTSYiiD37GDyqa/WqfyaLXgvxG81S3Sq+j
	 34xI8IlJCZwsAJZQLhFsggR804KMeWER3l8eCo6GtrHle981IvR7mB5qhwZKuuPdvO9tWf5oXue8
	 db5F+5LlCb7ky0SqFz/8ECb0Y63scxgKvddp6HcPFWDgHyou2diJp6RC4ZrjAELeyxxfEKv3HFoJ
	 cJ0rcz5XrTl9wW+KmFXTN3mweDxeQFy4etXz2AnnkEUx16bAupA1NCObm/e6+gTlcq6nfLqiqYSg
	 +PqQX+Fc8dih2wIvYxFVOzpAwA31J4vNHE1CUwMqH2pIRs1rElumI5dVpRQbuBAB75+wQt0ZyYIt
	 qN4GSCu6hSJVqlaZ19mY1v1W+w1wLCoW89IkL85LEIkFW6w+Efc1ma99G564fOJ4B/JYooxYU0Si
	 EjbwIsmrIH4aNqdb9X2pp7pex4NVVnkKQvCiLUqIXkykzmDCAHv979boLO5y4uToWSBBa+5C9kqO
	 dKLJtNHIgVec+bMDneMhz1TVr06qjmuK7H2noH3umPYqRaOTgQpcui2/4QXFksVJr9dLliSHXANw
	 y3K8cdC9BjfNSptWmOivQUcTwHKzofvSVMA2YGCyCsu9Rm3qZg2L6h4okkpZ4/p2jdqnfVtz3Fq+
	 Wie6Aq60x60wATTWD6tVXEPFC1/OEx3AiS6brGN7SbnoKkYQT5+pdyyHuVB3t0i4Ct4gGqAwPn+E
	 99jccLH7PL2dm8BAKZLBKV08PWyYaNmwOS2dS/yDQ2SUK1IGBuVHrRSdY5Vfx9hxVmJR7gFpEKyZ
	 +B2cIwX+8LA3JHi560XBMpBYR9X4boC0KHiTSRkVoQ4fCpuq5BRyrT105Y8erdJqT7na3WhGN04t
	 uaEx0vLH6nnB/agzx/qqna9bL5n5IdOKqN4k+GWQ==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 7/9] mm/shmem: provide VMA-hint locality for zswap large swapin
Date: Fri, 29 May 2026 12:19:26 +0000
X-OQ-MSGID: <20260529121928.4115683-7-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let the shmem swap fault path pass locality evidence into the common
zswap large-swapin policy. Shmem does not have anon PTE-young density
evidence, so this first step only treats explicit VM_SEQ_READ as
positive evidence and VM_RAND_READ as a veto.

The non-fault shmem readahead path remains unchanged. This keeps large
zswap swapin limited to synchronous shmem faults where the caller
supplies a VMA and the common policy can still fall back to order-0.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/shmem.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fa99b48ed62b..a5ac35ac85fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/fileattr.h>
 #include <linux/filelock.h>
 #include <linux/mm.h>
+#include <linux/memcontrol.h>
 #include <linux/random.h>
 #include <linux/sched/signal.h>
 #include <linux/export.h>
@@ -1791,6 +1792,29 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
+static unsigned long shmem_swapin_locality_orders(struct vm_fault *vmf,
+						  unsigned long orders)
+{
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	unsigned long candidates = orders & ~BIT(0);
+
+	/*
+	 * Shmem does not have anon-style PTE young density evidence. Start with
+	 * explicit VMA access hints; future shmem/page-cache readahead evidence
+	 * can be folded into this producer without changing common swapin policy.
+	 */
+	if (!vma)
+		return 0;
+
+	if (vma->vm_flags & VM_RAND_READ)
+		return 0;
+
+	if (vma->vm_flags & VM_SEQ_READ)
+		return candidates;
+
+	return 0;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2020,18 +2044,22 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		struct vm_fault *vmf, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
+	unsigned long locality_orders;
+	unsigned long orders;
 	pgoff_t ilx;
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
-	     !zswap_never_enabled())
+	if (vmf && unlikely(userfaultfd_armed(vmf->vma)))
 		order = 0;
 
 again:
+	orders = BIT(order);
+	locality_orders = shmem_swapin_locality_orders(vmf, orders);
 	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
-	folio = swapin_sync(entry, gfp, BIT(order), 0, vmf, mpol, ilx);
+	folio = swapin_sync(entry, gfp, orders, locality_orders, vmf, mpol,
+			    ilx);
 	mpol_cond_put(mpol);
 
 	if (!IS_ERR(folio))
@@ -2339,7 +2367,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (!folio_matches_swap_entry(folio, swap) ||
 	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
-		goto unlock;
+		goto failed_swapcache;
 	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
@@ -2369,6 +2397,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
+	if (folio_test_large(folio))
+		memcg1_swapin(folio);
 	folio_put_swap(folio, NULL);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
@@ -2379,9 +2409,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 failed:
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
+failed_swapcache:
+	if (folio && folio_test_large(folio) && folio_test_swapcache(folio))
+		memcg1_swapin(folio);
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);
-unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-- 
2.34.1


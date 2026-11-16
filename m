Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827080;
	b=vzxBd51lfmclRWaD0u7WIft7Mqx/YItV1IzuCGnoEMv3lSbFHHGEgA+o0RVTxWyYuXn9
	 +CnK8b10np0zqP/DImhmZorM160Mflavjf69PdozoRTtUp9JsNfF1Z+uw5xezORl69T42
	 oJp0dfU5nIIO+K0BolXaeDeriTYgZjN4aty8ChsQiG6lqgGjui/wsRBZnes3OJKH0OIqd
	 5+7wX+3bGAAUaKS/zmBrkkxD+F9i/wN7K9cwLKAfPd7ygWidzFStK7RKooU05CdlG1ajm
	 UlxaBTBVMItpAzM7b1eKhJq0e3OXEkgl7dEB+IbyNDrlWlBkID2xAfXVPVf934BiY1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
	b=3kWI2Grnbi67p4bFC67kH1K3PsHdAQ3yemInS8rOygQ+NN4DyjuPFztUOwBPet9+A6GM
	 MhZgQ+nOdSD7PO3EknxhRW0KODMubxp84+wUHi84VrEPVcTOyfygDIUScy9wojMVHqnvl
	 l3aNyhdY6ZpZb5VgF4iNxa2LutNyr9KCPDsruEbVDQtYm2u15KB5tLHduBaGxOsFjZqCl
	 j806pBWDsBujoFHTl0F13J+5xp6m82qSx0ZucdoTZcT58y5bayRUxcab+czgtpcQhCAEx
	 1vB1rB0cbNnTLGWiHbxqRbDAu9Rc5haj6KkRSL4gGiVOM2i7AbtN0nAWUE/EiXN3Htw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ftUOuy0H;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A144060A3808
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A144060A3808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ftUOuy0H
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so3508518c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827079; x=1795431879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
        b=ftUOuy0Hdn24IqcvQSyim5EcEkT6MsP7Hn4EWzJRTF6Lf1XKby5/ry69hz1xiabVd5
         mR2mOwf5CBd6YkBTt3iuEV0apa3go15XWbKzuDY4CHAhzPNDOToaFTeuyL6rZobYZGR0
         /mlvj1XKHiPPqXLpNdXdV7IVivJHFwGe8oYqCtNP3oq78XiZpFGLuZIx/jn0WBsngISA
         XDGdWHUddsgCR8FawoSV8yQrMbk/EAxxeHISg9yjL43awqsCmc3IWbMJC4MH3PjMntua
         w/7vS7+KTLmbYCKBEVhH04BS4tghMRp73ZZT9uH1gPUfuL4nbvdgsRZYlwh8N33DCI9E
         svkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827079; x=1795431879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qKxpEcN2pivN4rr9uZi0u3NXCbLqXQzeVzDGfJiaQ78=;
        b=goHFRx7Z1vUGjdBXkvybrV/3ym1r7e8RBKb2dGKyN6iPzcMtdhflOGxkIzV6fs424e
         FDt1dlBZzGxhzhZxUkpStm9andjgIvLXe/sdu2tIAuI1T8Vcb2q9tLeB5n/RLMKWm21G
         AqMf1c2m1sKzpA4S+YbT0WHI6E0H6jJB1ByAfqOdOzJhvrIdoHmK12yq2zC7LybCJjBK
         Id39D8rGul2OMKZYxmqz0FBD1tMxT0Vynp93s3ijsCtgzPGZpP7PZ3A7gAHDvvfNDQVQ
         3bUsPpBZHVht7xrWBEbGoAnhi5O61TkBUgcyzObIebk6394Sr4juhtieYjNGhViHcxfD
         gU6g==
X-Forwarded-Encrypted: i=1; AL+hErGzJb9wX+l1dqGAfEAyXaHHeFOHlYYU/6RXSqAISHedCfZiBI5jbeNieWKOINjeMu7QuJgJjwpC@vger.kernel.org
X-Gm-Message-State: APuU4Z/5OVtDj/8WPQ+UeEEzaZspLut6katZBZTIyjSSNPRrcvWi3IBw
	RCy84tMBod+VqdQ6ziHcBGZXlgTHQieUsTqjrRp3hZp7MqCELa0SVi1C
X-Gm-Gg: AYBFou3l2+t1UrIXNG9K+RnYlgZwA9kyq606wYSUJjvvk1bjamuzKtqd/DE7QU/cS9j
	XjkXow9ixM5RMqKXfo7qoW6ce3N2qwPwY9BDu5D0cvYIYa+YvTNzYtt8nU5ruAGX8fV3fz7LNfn
	apY9ILmMoZZoJqJmBsLc/ZQVuovjvjDD5jZKgzsgYzcVilzWWNOFJCs8fbKT/cla48ryjbMNist
	FOWKx5CZooO6+9Mnj1ljL22GophyWNWJcwaJ8hNxms2b/tsGaSuPQBb5bkZOZ2Dnnr/RtvSdIUv
	vhI1iBwfyyWuLZmS+s+4yx6VC7OZkVTResqd+4zypTclIrNWv6v1DfM+Za71jcJ8gWboOuIPpWH
	A5TqyInxvDzQeKhp2MUKXoAEFMhRsskS8BK+jU8Dqubpgm4kPvdioY1CTtuJRqxcJmVfbT2mKg7
	0Hp1xbLfCaLdNer6B92TQOcQVlHOkgWUgY9li8JRm5T+WvdmpybQyalnzt1vtwMUpbE/hT8bTEk
	MdDoNUNT/iP6xf2bclEya2yZQgFxnMd0PqBZzoW2lEIDDGaLL/aFmvPv5O0UgbW1t8hvgBbFaMZ
	GC86vLVsMi6ZcH7VuiwdI2cxtqlFaeKoxwxG9iVCEOc+htU=
X-Received: by 2002:a05:701b:4590:20b0:1b3:b53e:b4c5 with SMTP id a92af1059eb24-1b503137aafmr9667743c88.38.1794827078542;
        Mon, 16 Nov 2026 03:04:38 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:38 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 12/16] mm: memcomp: report precise token residency
Date: Mon, 16 Nov 2026 19:01:18 +0800
Message-ID: <20261116110122.309748-13-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report whether a token can satisfy a read without I/O for anonymous and
shmem mappings, including each base page of a large folio. Query backing
swap-cache uptodate state without reading, decompressing or consuming
a shadow. Drop PTL and XArray locks around the query and revalidate.

Preserve each base kernel's native syscall and page-size handling.
Add test-only query seams with the KUnit patch, not this production
step.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h |   7 +++
 mm/memcomp.c            |   1 +
 mm/memcomp/api.h        |   5 ++
 mm/memcomp/mincore.h    |  77 +++++++++++++++++++++++++++++
 mm/mincore.c            | 104 +++++++++++++++++++++++++++++++++++++++-
 mm/swap_state.c         |   5 ++
 6 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 mm/memcomp/mincore.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 8248a44bbb57a9e98afe29cc0e0599ca9f6bc988..f992a5e716fc6dc59b75072e6bed41eb4454e083 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -45,6 +45,8 @@ enum memcomp_anon_fail_event {
 #ifdef CONFIG_MEMCOMP
 
 bool memcomp_available(void);
+/* Process context only, with no PTL or XArray lock held. */
+bool memcomp_mincore(unsigned long token);
 bool memcomp_release_folio_reclaim(struct folio *folio,
 				   struct mem_cgroup *target_memcg);
 void memcomp_publish_cache_eviction(struct folio *folio, struct memcomp_ref *ref);
@@ -191,6 +193,11 @@ unsigned long memcomp_shadow_token(void *shadow);
 
 #else
 
+static inline bool memcomp_mincore(unsigned long token)
+{
+	return false;
+}
+
 static inline bool memcomp_available(void)
 {
 	return false;
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 01254bf22c8834dc61d731cf5f776cb77cd9c908..a246c801910b72a5084d4db17d4183e0d69bb958 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -3903,6 +3903,7 @@ static bool memcomp_writeback_defrag_pass(void)
  * Core load - decompress one page from @entry into @dst.  Sleeps on the
  * token lock and possibly swap IO; never called under the PTE lock.
  */
+#include "memcomp/mincore.h"
 #include "memcomp/workingset_load.h"
 #include "memcomp/load.h"
 #include "memcomp/consumers.h"
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
index b73bde6c3d976f05bbe3ff35ecd57bf82f58f789..47946253497046eae4c01b230fafc5f2e6dc1623 100644
--- a/mm/memcomp/api.h
+++ b/mm/memcomp/api.h
@@ -39,6 +39,11 @@ void memcomp_invalidate_cache(unsigned long token)
 	mc16_cache_drop(token);
 }
 
+bool memcomp_mincore(unsigned long token)
+{
+	return mc16_mincore(token);
+}
+
 bool memcomp_entry_present(unsigned long token)
 {
 	return mc16_entry_present(token);
diff --git a/mm/memcomp/mincore.h b/mm/memcomp/mincore.h
new file mode 100644
index 0000000000000000000000000000000000000000..ebba2424b65ef4f0ce5fba1892c6728f43a346b8
--- /dev/null
+++ b/mm/memcomp/mincore.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_MINCORE_H
+#define _MM_MEMCOMP_MINCORE_H
+
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+
+/* Include after storage/access/refs and the memcomp_slot_* helpers. */
+#ifdef CONFIG_SWAP
+static struct folio *mc16_mincore_swap_folio(swp_entry_t swap)
+{
+	struct swap_info_struct *si;
+	struct folio *folio;
+
+	si = get_swap_device(swap);
+	if (!si)
+		return ERR_PTR(-ENOENT);
+	/* No allocation, read, readahead or swap-cache hit accounting. */
+	folio = filemap_get_folio(swap_address_space(swap), swap_cache_index(swap));
+	put_swap_device(si);
+	return folio;
+}
+#endif
+
+/* Process context only: the caller pins its PTE/XA owner across this query. */
+static inline bool mc16_mincore(unsigned long token)
+{
+	struct memcomp_ref ref;
+	struct mc16_view view;
+	unsigned int state;
+	bool present = false;
+#ifdef CONFIG_SWAP
+	struct mc16_swap_fields fields;
+	struct folio *folio;
+	swp_entry_t swap = { };
+#endif
+
+	might_sleep();
+	if (!token)
+		return true;
+	if (!mc16_get(token, &ref))
+		return false;
+	mutex_lock(memcomp_lock_of(token));
+	if (!mc16_view_locked(&ref, &view) || !mc16_flags_valid(*view.flags))
+		goto unlock;
+	state = mc16_flags_state(*view.flags);
+	if ((*view.flags & MC16_F_RESIDENT) || state == MC16_PENDING ||
+	    state == MC16_STORED || state == MC16_WRITEBACK ||
+	    state == MC16_SAMEFILL) {
+		present = true;
+		goto unlock;
+	}
+#ifdef CONFIG_SWAP
+	if (state == MC16_SWAPPED &&
+	    mc16_swap_decode(*view.word, *view.length, &fields)) {
+		swap = swp_entry(fields.type, fields.swap_offset);
+		/* A token guard alone does not pin a backing changed by swapoff. */
+		if (!swap.val || memcomp_slot_dup(swap))
+			swap.val = 0;
+	}
+#endif
+unlock:
+	mutex_unlock(memcomp_lock_of(token));
+#ifdef CONFIG_SWAP
+	if (swap.val) {
+		folio = mc16_mincore_swap_folio(swap);
+		if (!IS_ERR_OR_NULL(folio)) {
+			present = folio_test_uptodate(folio);
+			folio_put(folio);
+		}
+		memcomp_slot_put(swap);
+	}
+#endif
+	mc16_ref_put(&ref);
+	return present;
+}
+#endif /* _MM_MEMCOMP_MINCORE_H */
diff --git a/mm/mincore.c b/mm/mincore.c
index d6bd19e520fcfb9389e6825eefd72d0b51ad2969..17e8d7a5b316edcfb13d72242767eea662a559dd 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -18,7 +18,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
-
+#include <linux/memcomp.h>
 #include <linux/uaccess.h>
 #include "swap.h"
 
@@ -49,6 +49,35 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
  * and is up to date; i.e. that no page-in operation would be required
  * at this time if an application were to map and access this page.
  */
+#ifdef CONFIG_MEMCOMP
+/* The XA guard, not the unreferenced value returned by filemap, pins token. */
+static int mincore_memcomp_page(struct address_space *mapping, pgoff_t index)
+{
+	struct memcomp_ref ref = { };
+	unsigned long token;
+	void *entry;
+	bool pinned, stable;
+	int present;
+
+	xa_lock_irq(&mapping->i_pages);
+	entry = xa_load(&mapping->i_pages, index);
+	if (!is_memcomp_shadow(entry)) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
+	token = memcomp_shadow_token(entry);
+	pinned = !token || memcomp_entry_get_ref(token, &ref);
+	xa_unlock_irq(&mapping->i_pages);
+
+	present = pinned && memcomp_mincore(token);
+	xa_lock_irq(&mapping->i_pages);
+	stable = xa_load(&mapping->i_pages, index) == entry;
+	xa_unlock_irq(&mapping->i_pages);
+	memcomp_entry_put_ref(&ref);
+	return stable ? present : -EAGAIN;
+}
+#endif
+
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
 	unsigned char present = 0;
@@ -60,7 +89,21 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
+#ifdef CONFIG_MEMCOMP
+again:
+#endif
 	folio = filemap_get_incore_folio(mapping, index);
+#ifdef CONFIG_MEMCOMP
+	if (folio == ERR_PTR(-EEXIST)) {
+		int ret = mincore_memcomp_page(mapping, index);
+
+		if (ret < 0) {
+			cond_resched();
+			goto again;
+		}
+		return ret;
+	}
+#endif
 	if (!IS_ERR(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
@@ -97,6 +140,41 @@ static int mincore_unmapped_range(unsigned long addr, unsigned long end,
 	return 0;
 }
 
+#ifdef CONFIG_MEMCOMP
+/* Enter with PTL held; return with a fresh mapping, or NULL for ACTION_AGAIN. */
+static int mincore_memcomp_pte(pmd_t *pmd, unsigned long addr,
+			       struct mm_walk *walk, pte_t orig,
+			       pte_t **ptepp, spinlock_t **ptlp)
+{
+	struct memcomp_ref ref = { };
+	bool compressed = is_swap_pte(orig) &&
+		is_memcomp_entry(pte_to_swp_entry(orig));
+	unsigned long token = compressed ? swp_offset(pte_to_swp_entry(orig)) : 0;
+	bool pinned = true, stable;
+	unsigned char present = 0;
+
+	if (compressed && token)
+		pinned = memcomp_entry_get_ref(token, &ref);
+	pte_unmap_unlock(*ptepp, *ptlp);
+	if (compressed)
+		present = pinned && memcomp_mincore(token);
+	else
+		__mincore_unmapped_range(addr, addr + PAGE_SIZE, walk->vma, &present);
+
+	*ptepp = pte_offset_map_lock(walk->mm, pmd, addr, ptlp);
+	stable = *ptepp && pte_same(ptep_get(*ptepp), orig);
+	if (*ptepp)
+		pte_unmap_unlock(*ptepp, *ptlp);
+	/* A changed PTE may have dropped the last owner: put outside PTL. */
+	memcomp_entry_put_ref(&ref);
+	if (!*ptepp)
+		return -EAGAIN;
+	/* The first validation is the snapshot; do not retain a stale ptep. */
+	*ptepp = pte_offset_map_lock(walk->mm, pmd, addr, ptlp);
+	return stable ? present : -EAGAIN;
+}
+#endif
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -119,8 +197,29 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		return 0;
 	}
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+#ifdef CONFIG_MEMCOMP
+again:
+		;
+#endif
 		pte_t pte = ptep_get(ptep);
 
+#ifdef CONFIG_MEMCOMP
+		if ((is_swap_pte(pte) && is_memcomp_entry(pte_to_swp_entry(pte))) ||
+		    (pte_none_mostly(pte) && vma->vm_file &&
+		     shmem_mapping(vma->vm_file->f_mapping))) {
+			int ret = mincore_memcomp_pte(pmd, addr, walk, pte, &ptep, &ptl);
+
+			if (!ptep) {
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
+			if (ret < 0)
+				goto again;
+			*vec = ret;
+			goto next;
+		}
+#endif
+
 		/* We need to do cache lookup too for pte markers */
 		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
@@ -146,6 +245,9 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 #endif
 			}
 		}
+#ifdef CONFIG_MEMCOMP
+next:
+#endif
 		vec++;
 	}
 	pte_unmap_unlock(ptep - 1, ptl);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4669f29cf555748c9c3245a370a613dbfca37d76..f955f67502f503730864c34bf1711c9d4ecb5a10 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -416,6 +416,11 @@ struct folio *filemap_get_incore_folio(struct address_space *mapping,
 		return ERR_PTR(-ENOENT);
 
 	swp = radix_to_swp_entry(folio);
+#ifdef CONFIG_MEMCOMP
+	/* A compressed value is not a folio; mincore queries it outside PTL. */
+	if (is_memcomp_entry(swp))
+		return ERR_PTR(-EEXIST);
+#endif
 	/* There might be swapin error entries in shmem mapping. */
 	if (non_swap_entry(swp))
 		return ERR_PTR(-ENOENT);

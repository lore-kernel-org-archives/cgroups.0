Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827039;
	b=olUNDYJp9yz8N22n8cnR5GxSnObbb/W4kM7T+C91LuKmxoTrIil/JssyOsstkNP9bkKS
	 PjkOHeUzeoIyb3PzZ9UAqrAsOvT8+M95lIUHtZd5pN0G9zTZrV87nkQMU+cAWXgKCNWr1
	 9RblmR8QtgOSCkSX381skycp0uZnI4JDdpPg+ri5vtk3wbE0wNDtJYIlq8FpNfcOHkRJ/
	 iBo5Cl0NLcgYKpLh18+EXCG1iK5Nq4tqS8/XscB/YPxovSk7XVMnBi2c8r9elNEvIxbx7
	 NLT8qHZePrjXoliaWdxG3IG3XlMwPRWAoHN8E2Cg7ya8T30sIuCSV9D3TY7+gXgusXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
	b=Q4BfMhzft+Q2YYQdyrdfTz+7dP11pX/nN8fFVj297rT4Y7bphKsZ8OuIzMm6NavsGGOA
	 H7Bf5VFVWgsbNEq18giSZMQ7FG2HQpX+88Sf3hKq6q3rlGgpKkiYNOZ4nNTw8YqiMAX03
	 azJMKC4MCjoy2VfQTuafY+3Kj6O1P//ykq3lWgprYj1zJVtCcFfhsgkTU7J+zTBVb5m2v
	 Kh3QisYbulGOnTbyIZTiIcmzz6jnimyy+tU/IWiZ14XZ51KW7dOfDvSS1TFc/1i5RQiOL
	 PRiOC64xyN0Z2nNweXlXZlHU4ITat9RCOWha4bzreAjdub10Jrh7B4nKh6l1lwi/MmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=udSl0I23;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C658606A336
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C658606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=udSl0I23
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14394530ec6so3920888c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827038; x=1795431838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
        b=udSl0I23nKTERwbqNjwEoycYaHQTORz49/d6qKE63LcnavmrYfTRhvshGEHH6gjWrf
         32R30HwDvzDEHxtHDCYpWBakaU5ULu09GG/XdNFB1uISn0pIttbUMtb1kcYGuKegr3yx
         FBL9SrW9P4Nhr/0vzhnAw/8gn4MRasjxBbt/A/poTaK5d3V3Q6kcUwpVzYVJyCQYMDoO
         v7oRVOJ7iZpHvPfwjEfsCuNp+cYGsX6yqg64fZUOTCdJkJAItL5mYP8Fogt5EuMNuHBX
         1aFTCEqnm5NbQKQRe4NqwAo76JcUkOKV1Cwme47OYQTLxGjsl7x+zTCf9mAYgP+G1W1s
         iqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827038; x=1795431838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
        b=QcmyyqzlKKu7URekhb0780clsJd86QpO6zprukChiYBSbJEv93qurXpbbICyyXCn5T
         Q6XlnkToEpSnMkA4dIKRwHVwzFR/K2YvhdUPw6JHpyawhOlvOy8bHYzZpH5dgcU5+KAE
         sIZhG8SreG4gIlcDJco03jY88U+KyxPef8ALlng8OtGzmIKHc7qvziRUzt3Un/Zm6OpN
         RsJfsNQWY0bFfrUaFhlsfYwoh97QSsYuBnYNn/3rHFamSMjA6fQa7d9q6BX9QpdVim34
         +3YLLf6L0fBT8ZnJniTVEf4k7VBPkEnbxLyWX0subPE2V+Y0mqFYu5RcBjjoBw+vhwch
         TcZg==
X-Forwarded-Encrypted: i=1; AL+hErEhCJqahWGTlAO5+qT/qIiEJJhQNnr9o7EUdLTTB/U/taZz2gJbEDWEe1PR0V1/+Wo3gZcrSBar@vger.kernel.org
X-Gm-Message-State: APuU4Z8fsURY1hUXKsSloM/0eLGuH5AILVdU9r2h/SZuR75GbL6gXv7h
	a5W1DDDGklFUs/fMR08HnAZfvu5nm1it/2M7Ah7nb60K90GMjPaSPaK8l9eDjTbpzrmYRmVs
X-Gm-Gg: AYBFou3jI+chV30PRkzhiFOCLX99yDfaJlEtkivA7vrNhtHdeLJAMNy5ugmpBpG56OH
	NlX7QxJBdQbCszeSAqFDlmJnWNNkyoDDLF6GFwarMMhFyZhSEv5uRknRx7xEw2zO/EdHM8CLQ7X
	fNTeFZsRxfWUINJeVA9FbTzDI2RbKMw0BQhaiMEiFN6i+HYdEZrMsxIO93Ymc/r4o/TJjwCYW5y
	tfCkFq5+qaf8AgqjFHPUcjY9lgESEHH1HIKwYwhvks+cUZwF8OpZZayPy2QTa511fSW6ZX2satC
	JzyWDyrtcBcmG12KhSRDUb2znUYxppLL42st4WdIvHpBwldGNMrbTYZ7bkt/4nCBHutkjhc44W6
	166LYCzGLyg7SN/N+VrPlj86QbLNcmZ2xG3rc1pHrrbobXZnPKZXF2xcdiEGuU88Hkrw7aakMgo
	wYmfXJ7S7LzCQilLogJSdtuiO9VW/trt+BmH2lgxGRmu+PB3Zv5BGgD7oWxu/OmuFpysslGapqa
	DjDsUH46oLg0Ng1t2EijqRnKmwrqACHD1rARmlCGlhO30SEt8KXOe9H8bWGUb778aFBRs+fLny9
	4MFUfV9iEvo5wEyyzbPft4NQKbXVuREtApIWKvp6nxWy81Q=
X-Received: by 2002:a05:7022:282:20b0:149:1feb:6da4 with SMTP id a92af1059eb24-1b5031244a9mr9354527c88.32.1794827038262;
        Mon, 16 Nov 2026 03:03:58 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:57 -0800 (PST)
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
Subject: [RFC PATCH 04/16] mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
Date: Mon, 16 Nov 2026 19:01:10 +0800
Message-ID: <20261116110122.309748-5-nakixii@gmail.com>
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

UFFDIO_MOVE rejects memcomp entries as unsupported non-swap entries.
Support moving them without requiring the memory-cgroup, shmem,
writeback or asynchronous-compression paths.

Move nonresident tokens like swap entries while keeping a lookup
reference across PTE revalidation. The reference prevents token reuse
from changing the backing whose resident state was checked. Return
-EAGAIN for a busy entry or a stale token rather than moving it without
a stable handle. Keep zero-token movement neutral to zero ownership.

A resident pending token still names a folio whose anonymous rmap points
to the source address. Restore that folio there, then retry through the
present-PTE move path instead of moving the resident token directly.
Drop both RCU PTE mappings before the token-lock lookup and preserve the
existing PTE and exclusivity checks.

Rollback of memcomp entries makes partially unmapped large folios more
common. The per-page exclusivity check also covers that state without
treating the first page's flag as the flag of every mapped subpage.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/userfaultfd.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d8a699981d097ae393a981a33cede5f5ce6e2725..0ed91fdd2e80a89073ce2f165e0d557a55218e55 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -15,6 +15,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
+#include <linux/memcomp.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -1150,6 +1151,9 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
 	int err = 0;
+	swp_entry_t memcomp_checked_entry = { };
+	bool memcomp_token_checked = false;
+	struct memcomp_ref memcomp_checked_ref = { };
 
 	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
@@ -1338,6 +1342,77 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		struct folio *folio = NULL;
 
 		entry = pte_to_swp_entry(orig_src_pte);
+		if (is_memcomp_entry(entry)) {
+			int resident;
+
+			if (!pte_swp_exclusive(orig_src_pte)) {
+				err = -EBUSY;
+				goto out;
+			}
+			/*
+			 * A resident token must be faulted back where its
+			 * folio's rmap expects it; the present-pte path then
+			 * moves the folio.  Any other token carries no
+			 * address and moves like a swap entry.
+			 *
+			 * pte_offset_map_nolock() leaves us in an RCU read-side
+			 * section.  Drop both mappings before querying the token:
+			 * memcomp_entry_resident_get() may take the token mutex when
+			 * it wins its trylock, and lockdep quite correctly rejects
+			 * even that conditional mutex acquisition in this context.
+			 * The PTEs are revalidated by retry before either move path.
+			 */
+			/* Zero is a pure value: MOVE keeps its logical owner count. */
+			if (!swp_offset(entry)) {
+				err = move_swap_pte(mm, dst_vma, dst_addr, src_addr,
+						    dst_pte, src_pte, orig_dst_pte,
+						    orig_src_pte, dst_ptl, src_ptl, NULL);
+				goto out;
+			}
+			if (!memcomp_token_checked ||
+			    memcomp_checked_entry.val != entry.val) {
+				if (memcomp_checked_ref.slot)
+					memcomp_entry_resident_put(&memcomp_checked_ref);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
+				dst_pte = NULL;
+				src_pte = NULL;
+				resident = memcomp_entry_resident_get(swp_offset(entry),
+								      &memcomp_checked_ref);
+				if (resident < 0) {
+					err = resident;
+					goto out;
+				}
+				if (resident) {
+					struct vm_fault vmf = {
+						.vma = src_vma,
+						.address = src_addr,
+						.pgoff = linear_page_index(src_vma, src_addr),
+						.pmd = src_pmd,
+						.orig_pte = orig_src_pte,
+					};
+
+					err = memcomp_restore_resident(&vmf,
+								       &memcomp_checked_ref);
+					memcomp_token_checked = false;
+					if (!err)
+						goto retry;
+					goto out;
+				}
+				if (!memcomp_checked_ref.slot) {
+					/* Do not move a stale token without a stable entry. */
+					err = -EAGAIN;
+					goto out;
+				}
+				memcomp_checked_entry = entry;
+				memcomp_token_checked = true;
+				goto retry;
+			}
+			err = move_swap_pte(mm, dst_vma, dst_addr, src_addr,
+					    dst_pte, src_pte, orig_dst_pte,
+					    orig_src_pte, dst_ptl, src_ptl, NULL);
+			goto out;
+		}
 		if (non_swap_entry(entry)) {
 			if (is_migration_entry(entry)) {
 				pte_unmap(src_pte);
@@ -1400,6 +1475,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	}
 
 out:
+	if (memcomp_checked_ref.slot)
+		memcomp_entry_resident_put(&memcomp_checked_ref);
 	if (src_anon_vma) {
 		anon_vma_unlock_write(src_anon_vma);
 		put_anon_vma(src_anon_vma);

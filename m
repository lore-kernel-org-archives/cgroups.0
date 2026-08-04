Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521134499AD;
	Tue,  4 Aug 2026 10:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785838170; cv=none; b=Btsa+Xpgktho5o7g5klWgARe0FBXbtisxWiYi34Lm2PzkSJlzN8v45nV0cKdpJeWkp4Hq+QKCg+yHG+t+rnC5+jDqwtd+WP1hC+pWj/TiwSA+sSKZZRLeVPRHOLGaa5/siLISZL64EkKUBoE4+IKV2iA26HbZzPWE9xF3JdoZRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785838170; c=relaxed/simple;
	bh=SwMPTec0XlsK3+ngJJM1wNsxRciodd4u1nRU0SQHMFs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=s9FYXjQeVv5GUvgCaHZ2znPbKDGBoRucTdWmgREdlMiHOvO8sk/nNaF1FFuZ35ALd/6uFW+4RrWlO5+6+RDwp3nKuYafwpZ0fnRMpZ+R8VsJV7/ZwLQhkBHpOcYJjShmWkk4pLzNZtDiX4+kP5SsB/X6++fmQZbnKw7teedzelI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6q1gaMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6q1gaMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8886D1F000E9;
	Tue,  4 Aug 2026 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785838168;
	bh=zSARHNwVJ7L9JzGIAragO5c4yBJk6IVxhx/FLcrG5/E=;
	h=From:Date:Subject:To:Cc;
	b=U6q1gaMNhmhF77SMlDLau6BNbmX1CvPWsjkJxIA3aYyrNBMFqaSS3yiD8WpmTBENI
	 FRPpAPG+zYvumGS7cSdDzuRwIogXErQ7Dpt1kQWMfec4cdAZwJ9SYzHSQGT3Kx1wA0
	 q3O8tk7mVQhkgLDDUfhN7mYPi4TQDaz8BDS4O94T2EdQKAkcRwfNrcIgZ5SJBwW4dE
	 fMdh7YzAWgL+NleQfe2ceEMb8ObC+TeFFlycX6EVG0GeM4K+TKy11MQztYiSdwB5L3
	 /aEGKOlpgxj0TLq3pRDc4516ZVDev6K1lZ+C9A7AjkVdH+ecYc059W6/ZZbAYJdpcs
	 GwQFAekLnsziQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 04 Aug 2026 11:08:59 +0100
Subject: [PATCH] mm: add some missing includes to mm-local headers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
X-B4-Tracking: v=1; b=H4sIADq6cWoC/yXM3QqCQBDF8VeRuW5g3eyDXiW8WMejTpgbOxqB+
 O5tefmDc/4rGZLC6FaslPBW0zhllIeCZAhTD9Y2m7zzZ3d1FXf6YYtP8BgljDwgtEjGDo2Up+5
 YycVTPr8S8vIfvte7bWkekPlXo237AgFNwQh6AAAA
X-Change-ID: 20260804-fix-some-local-headers-0ebc15f34c72
To: Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=SwMPTec0XlsK3+ngJJM1wNsxRciodd4u1nRU0SQHMFs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIKdzkHhq632MladitB+3HJo94M/6OelkfT9Bpffphiq
 n9M5uLPjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEfy8jw9UOv9XlzTdb8pfd
 zlWyfDXf4PWJL8/VNEtktno3H2k4WsLIcClaVnB5rGrCrB2PBPtEYxLjX67g+Ba3Z9W0jG1Vyna
 8nAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

There are a number of internal headers local to mm/ which reference
functions and data types without including the relevant headers.

mm/vma.h is a special case that intentionally does not include additional
headers, but the others are not.

This breaks tooling like clangd (which is where I noticed this), though the
build is OK due to the C files including the headers happening to include
required dependencies.

It's better to be explicit about dependencies anyway, so add the missing
includes and fix clangd as a bonus.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/cma.h           | 1 +
 mm/hugetlb_cma.h   | 2 ++
 mm/memcontrol-v1.h | 1 +
 mm/pgalloc-track.h | 3 +++
 mm/shuffle.h       | 2 ++
 mm/swap.h          | 1 +
 mm/vmalloc.h       | 2 ++
 7 files changed, 12 insertions(+)

diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..ab6d39898ea5 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -2,6 +2,7 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/cma.h>
 #include <linux/debugfs.h>
 #include <linux/kobject.h>
 
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 3aa483573d17..730b2b4965b6 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_HUGETLB_CMA_H
 #define _LINUX_HUGETLB_CMA_H
 
+#include <linux/hugetlb.h>
+
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 0f703f239c80..1e394269c613 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -4,6 +4,7 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/memcontrol.h>
 
 /* Cgroup v1 and v2 common declarations */
 
diff --git a/mm/pgalloc-track.h b/mm/pgalloc-track.h
index e9e879de8649..1a6de1358a21 100644
--- a/mm/pgalloc-track.h
+++ b/mm/pgalloc-track.h
@@ -2,6 +2,9 @@
 #ifndef _LINUX_PGALLOC_TRACK_H
 #define _LINUX_PGALLOC_TRACK_H
 
+#include <linux/mm.h>
+#include <linux/pgtable.h>
+
 #if defined(CONFIG_MMU)
 static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long address,
diff --git a/mm/shuffle.h b/mm/shuffle.h
index 61bbcddeeee6..11bec7521ab8 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -2,7 +2,9 @@
 // Copyright(c) 2018 Intel Corporation. All rights reserved.
 #ifndef _MM_SHUFFLE_H
 #define _MM_SHUFFLE_H
+
 #include <linux/jump_label.h>
+#include <linux/mmzone.h>
 
 #define SHUFFLE_ORDER MAX_PAGE_ORDER
 
diff --git a/mm/swap.h b/mm/swap.h
index d077e5893a42..ec580c713204 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -5,6 +5,7 @@
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
 #include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
+#include <linux/swap.h> /* for MAX_SWAPFILES_SHIFT, struct swap_info_struct */
 
 struct mempolicy;
 struct swap_iocb;
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index dcfe30eaa80c..8866ddcff668 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -5,6 +5,8 @@
 #ifndef __MM_VMALLOC_H
 #define __MM_VMALLOC_H
 
+#include <linux/vmalloc.h>
+
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,

---
base-commit: e47602c51d20a93fa1711ed896dc9480de4374d9
change-id: 20260804-fix-some-local-headers-0ebc15f34c72

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


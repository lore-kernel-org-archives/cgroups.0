Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A34245D5D3;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=XkzESrRCXnAdDPHGhoAUi7N4HoQgQkwLQRGJOZq5vxzlL99Jl9ZF9bQxyUx0zkV/HgHigcBmlxvVEI1VP6WEMDzW5aAheKNQD5RY8ggPZ5XokAD761fAeEKo6SyqoWPVTRi9U7XvrFdchUXklduTbOju1c1VUst4UfkgTvPgF04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=5/iRF3xNqMsJsR53Yn485u1SJJR2JsiIiVvY2SQNe+s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HX9WUdja1h9seS7Rbl1gmmYsQ21FOwIt0Z+fSOzAwaoa860MkVf6XCQM76dlPYz1mfjWK4G64sDJrkBCvPPJvwjaqCUbECdHWDNq9I9HksjJ9ZFucEeAdb5AZoLsijAVHybV8CnbHP9noX3plAgpT43CRDx1gL0vO5GB4jcKnuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+SxcELL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+SxcELL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79314C2BCFB;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=5/iRF3xNqMsJsR53Yn485u1SJJR2JsiIiVvY2SQNe+s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c+SxcELLjBmZdtQTreWKXPNovxnW3u7q1JQ10iW2wkifkQmxpZYDgskte5XeqvBNm
	 PNrXcMFlRbxCeOEeollYUTgXaOl3GLV7G2H8Fow4XuQcOhzJunxXRuO6KG0AagMrXu
	 U/2yO8njKtb97sVW68BEkxcMQtnKs5m60gsRABH4Tt5jmGeZq81q95djQnIbeZRAoJ
	 iP38iUplPnQxQP+CCyoZYAOGksNwUFjs4DQEBDWTEh8YJ9W+q1VXmjCyoZOF7fGcfu
	 Uf6Txk5Errh4Ckax4kGdHZ3MrnORlhH94SCSjIxC5/EUzMu3Tfn7SPOkyIKT+WrEhK
	 NdtmrjAE0NuEw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67147C44536;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:18 -0700
Subject: [PATCH v4 10/16] WIP: fs: hugetlbfs: Refactor subpool getters and
 integrate with hugetlb_subpool API
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-10-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=5109;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Rr0t6FQpLc5GBEHSOpDNGxRyeiM/tB/HQxHFWvewyxI=;
 b=r8aum4myXhKIuGOvNFNRV2xnP+sRjMi82PJGF7WGGuvumuJvvLXs2oRu08WpAjRrptqeMPkev
 cpDbibmLIwAB3MMC8TVRLPb2o/yYixAdK/+t9iAz2EISXgaiFArJ1q+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

Refactor the direct field accesses to spool->max_hpages, spool->min_hpages,
and calculate subpool properties using getters inside
mm/hugetlb_subpool.c.

This will allow the definition of struct hugepage_subpool to be
encapsulated and private to mm/hugetlb_subpool.c

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 28 +++++++++-------------------
 mm/hugetlb_subpool.c | 39 ++++++++++++++++++++++++++++++++++++++-
 mm/hugetlb_subpool.h |  4 ++++
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 86c21f8272470..b424afdedb3ee 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1060,7 +1060,6 @@ static int hugetlbfs_show_options(struct seq_file *m, struct dentry *root)
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(root->d_sb);
 	struct hugepage_subpool *spool = sbinfo->spool;
 	unsigned long hpage_size = huge_page_size(sbinfo->hstate);
-	unsigned hpage_shift = huge_page_shift(sbinfo->hstate);
 	char mod;
 
 	if (!uid_eq(sbinfo->uid, GLOBAL_ROOT_UID))
@@ -1082,12 +1081,13 @@ static int hugetlbfs_show_options(struct seq_file *m, struct dentry *root)
 	}
 	seq_printf(m, ",pagesize=%lu%c", hpage_size, mod);
 	if (spool) {
-		if (spool->max_hpages != -1)
-			seq_printf(m, ",size=%llu",
-				   (unsigned long long)spool->max_hpages << hpage_shift);
-		if (spool->min_hpages != -1)
-			seq_printf(m, ",min_size=%llu",
-				   (unsigned long long)spool->min_hpages << hpage_shift);
+		unsigned long long max_size = hugepage_subpool_max_size(spool);
+		unsigned long long min_size = hugepage_subpool_min_size(spool);
+
+		if (max_size != -1ULL)
+			seq_printf(m, ",size=%llu", max_size);
+		if (min_size != -1ULL)
+			seq_printf(m, ",min_size=%llu", min_size);
 	}
 	return 0;
 }
@@ -1106,18 +1106,8 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		/* If no limits set, just report 0 or -1 for max/free/used
 		 * blocks, like simple_statfs() */
 		if (sbinfo->spool) {
-			long free_pages;
-
-			spin_lock_irq(&sbinfo->spool->lock);
-			buf->f_blocks = sbinfo->spool->max_hpages;
-			if (sbinfo->spool->max_hpages == -1) {
-				free_pages = -1;
-			} else {
-				free_pages = sbinfo->spool->max_hpages -
-					     sbinfo->spool->used_hpages;
-			}
-			buf->f_bavail = buf->f_bfree = free_pages;
-			spin_unlock_irq(&sbinfo->spool->lock);
+			buf->f_blocks = hugepage_subpool_max_hpages(sbinfo->spool);
+			buf->f_bavail = buf->f_bfree = hugepage_subpool_free_hpages(sbinfo->spool);
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
index 6184860ed7374..ac0f9057b4921 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -12,7 +12,6 @@
 #endif
 #include <linux/spinlock.h>
 #include <linux/bug.h>
-
 #include "hugetlb_subpool.h"
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -38,6 +37,44 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 	}
 }
 
+long hugepage_subpool_free_hpages(struct hugepage_subpool *spool)
+{
+	long free_pages;
+
+	spin_lock_irq(&spool->lock);
+	if (spool->max_hpages == -1)
+		free_pages = -1;
+	else
+		free_pages = spool->max_hpages - spool->used_hpages;
+	spin_unlock_irq(&spool->lock);
+
+	return free_pages;
+}
+
+static unsigned int hugepage_subpool_hpage_shift(struct hugepage_subpool *spool)
+{
+	return huge_page_shift(spool->hstate);
+}
+
+unsigned long long hugepage_subpool_max_size(struct hugepage_subpool *spool)
+{
+	if (spool->max_hpages == -1)
+		return -1ULL;
+	return (unsigned long long)spool->max_hpages << hugepage_subpool_hpage_shift(spool);
+}
+
+unsigned long long hugepage_subpool_min_size(struct hugepage_subpool *spool)
+{
+	if (spool->min_hpages == -1)
+		return -1ULL;
+	return (unsigned long long)spool->min_hpages << hugepage_subpool_hpage_shift(spool);
+}
+
+long hugepage_subpool_max_hpages(struct hugepage_subpool *spool)
+{
+	return spool->max_hpages;
+}
+
 struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 						long min_hpages)
 {
diff --git a/mm/hugetlb_subpool.h b/mm/hugetlb_subpool.h
index be1f1cf012c9c..41d22239f2c3e 100644
--- a/mm/hugetlb_subpool.h
+++ b/mm/hugetlb_subpool.h
@@ -13,5 +13,9 @@ struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
 long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
+long hugepage_subpool_free_hpages(struct hugepage_subpool *spool);
+long hugepage_subpool_max_hpages(struct hugepage_subpool *spool);
+unsigned long long hugepage_subpool_max_size(struct hugepage_subpool *spool);
+unsigned long long hugepage_subpool_min_size(struct hugepage_subpool *spool);
 
 #endif /* _MM_HUGETLB_SUBPOOL_H */

-- 
2.55.0.229.g6434b31f56-goog



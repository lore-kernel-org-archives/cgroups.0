Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4994028E9;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784602389; cv=none; b=lZfZ1J9N9AYZjqPZbDgMhe/atm8/7Jop1TI34v3uebbWebRlnagEcoeC5LvK232CkYVVfI3xFGH2/nU/oIoqJhIcmVfDLPThM1XhwXiPNlwvclUxo++zCJMMhEQWT+UvroBNtQSccxMnbH+3WNL/nseP6yxHdaoDeJP6uXVPUpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784602389; c=relaxed/simple;
	bh=dQJa64TA7n7wPBuMQAm33gNRQMnt8IhQlLQye0FISNY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lS+J8zILTvPIq8mwvEBM41FptudMThql6aNeN4Lb2XTKtEisc4mc8kkE3CeUxnzOBSqnUrK0Er/FJj5cuVKuJZPvxGjR89K1myj7Wf3fkdR2BYgjUm+16N1wsWyEsy2I+2MbugyNzqKUM9rQ3ePzmXfl6qFIQGIFSxCaNx199eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8H9z6J2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8H9z6J2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41D1FC32781;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=dQJa64TA7n7wPBuMQAm33gNRQMnt8IhQlLQye0FISNY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t8H9z6J2NlgIVtT1kugXvkDJmSfCnl/14OIJqMCSkY5iPUGGV5RRk2b+MHWBPTbJo
	 yyry6m/JVZK797uqnu8HKVDr1Xl42r2ISMOMd5VXjFgNBiX50jEE1ORfGgpDPjNyDW
	 kAAdqn0bVNdwa3uYLfDf1DNbklQXsAldsYGHhydTXSDoS7Q2/z9NC2W9pl5LS4FN7N
	 wxh7JQks4WkF6PacqhAlSTeKW4ZBrusHlS5NAy83+VGrWXGKSkkmxHmLD2XtTxcScz
	 J0MI1U3Uk7YpK6x9HNj973LLvA5eQb0CAl4V4wSoe02QoeD6n3XXObj//MtqK7gB4P
	 88E6ZqK3OhaIQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFA6C44524;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:10 -0700
Subject: [PATCH v3 07/13] WIP: fs: hugetlbfs: Refactor subpool getters and
 integrate with hugetlb_subpool API
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-7-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=5388;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/bVMwhDzkKWXm/PUQ4Oz0DueIPwM1LmPE5uQODdNRt4=;
 b=e9KVJDUd1/O3E5VwDVW5E9FSn4k3+pT0IRfemqqYsyY5VfHIO+b7wVSj17bceSsnoRwaed+Zi
 i/0O5pqbxyBCVCbC2l3qDsBLYdKyysNubSNU1FyLXhC3GzBd6/ng4aw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

Refactor the direct field accesses to `spool->max_hpages`, `spool->min_hpages`,
and calculate subpool properties using dedicated, encapsulated accessor getters inside
`mm/hugetlb_subpool.c`.

Introduces and exports the following harmonized subpool getters to `mm/hugetlb_subpool.h`:
- `hugepage_subpool_free_hpages()`
- `hugepage_subpool_max_size()`
- `hugepage_subpool_min_size()`
- `hugepage_subpool_max_hpages()`

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 28 +++++++++-------------------
 mm/hugetlb_subpool.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/hugetlb_subpool.h |  4 ++++
 3 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8c1caad74c409..8abe0574b1c7e 100644
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
index b12c16aa7e4c5..99e7975911079 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -12,7 +12,6 @@
 #endif
 #include <linux/spinlock.h>
 #include <linux/bug.h>
-
 #include "hugetlb_subpool.h"
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -41,6 +40,50 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
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
+	long max_hpages;
+
+	spin_lock_irq(&spool->lock);
+	max_hpages = spool->max_hpages;
+	spin_unlock_irq(&spool->lock);
+
+	return max_hpages;
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379A45D5C1;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=VjPD8+M71HNM/YbGb5kh1Sn3tIpczAEHM0dFXKAQsGu8fZ6lu3cXyOT8w7xAzX+SsnLXEFhYOFxKiCcizBJvQQOtICRPPW95DdEpGT0Tq4QnTF8PlK0QDouKpP7yFSxSHplAhxabEzhWht04cmyy9sSOLIcgmTSm/T7WoGWpwOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=pZEyi0J8om2ghDb6qME7uBKDwU9wZvWkyYWuA+nq1e8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tV12YoVInPYRpWVXahkvJ5Hhiima1Uc8WvA4HNaODIrV9jWvBm0+6p+YoZDWz2AsBqO0C/i4ySOaP1N8nanEvKN4juGerzQPaFlchdPIm7BRUB0x9r+2w4RvqDJhMS4Pu4ndFoZZdxcYLzMyMT4V9GyyH7tZR8iY60u1xAOX3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W82BRnUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W82BRnUd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58061C2BCC6;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=pZEyi0J8om2ghDb6qME7uBKDwU9wZvWkyYWuA+nq1e8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W82BRnUdxyWAQ4f+cvMo4Mzo/wV2rmi5lhO2VF23HZfYcpQlM1lcZFumECqhiTapo
	 DDQcSUd/6W9pwIAL8tUYYQaHBDjrQqJ7zsAw0sWyLEfpPyQurqZksyNlpq9aJ9LN6C
	 46g6yYXKoivcLALO7nTHcCJ94zTmAajL4Y+ilay0BhY7B0glNXu2KAclYcYK+fuE+U
	 M5YeUICXkGKJ0dst8euM3PQgtEBvQNQzh+9kuz+zSY2ZY1NA60vH5cXn6bXWDl8SZZ
	 ZmE7WLlNM4AaVq8ytPb6gMjSj4OFrvYII3K4E8XEWl9D+Kj/QAeD0cvG/8xQbqvOLW
	 G8Du92zuS5plQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459EFC4453D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:16 -0700
Subject: [PATCH v4 08/16] fs: hugetlbfs: Fix global reservation leak in
 hugetlbfs_fill_super()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-8-88e8b81970dc@google.com>
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
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2642;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xpwOn4o/8dwkPGcKx/D+08zZJl/SEz5ntK6oD42SVfo=;
 b=GfSo+082yV0XV2379mD54lWB1yFERnvv5vJcHzxcpA+vOTbZSFPHC1fJRtNvwaK1ItH4SHmMa
 P9nAWPJRDfrDUTI9SSn5NKpQmgKTijYg6y0r21Dm4bc+LzKU2zgTomV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

In hugetlbfs_fill_super(), if hugepage_new_subpool() succeeds in
allocating a subpool (which reserves global huge pages when
min_hpages != -1), but a subsequent initialization step like
d_make_root() fails, the error path directly invoked
kfree(sbinfo->spool).

Directly freeing the subpool structure with kfree() bypasses
hugepage_put_subpool() and its underlying unlock_or_release_subpool()
destructor. Consequently, hugetlb_acct_memory() is never called to
release the global page reservations allocated for min_hpages,
permanently leaking global huge page reservations.

Fix this leak by calling hugepage_put_subpool(sbinfo->spool) on the
error cleanup path instead of kfree(sbinfo->spool).

sbinfo->spool must be checked before dereferencing the subpool in
hugepage_put_subpool(). Add a NULL guard to hugepage_put_subpool() instead
of checking it in the caller to align it with other subpool helpers like
hugepage_subpool_get_pages() and hugepage_subpool_put_pages() that
gracefully handle NULL subpools. This allows callers to safely invoke
hugepage_put_subpool() without requiring explicit NULL checks. This is also
aligned with how kfree() can be called on NULL.

With the NULL guard in hugepage_put_subpool(), the NULL check in the only
other caller can also be removed.

Fixes: 7ca02d0ae586f ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 6 ++----
 mm/hugetlb.c         | 3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 26c0187340636..e5d86f31eba5b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1133,9 +1133,7 @@ static void hugetlbfs_put_super(struct super_block *sb)
 	if (sbi) {
 		sb->s_fs_info = NULL;
 
-		if (sbi->spool)
-			hugepage_put_subpool(sbi->spool);
-
+		hugepage_put_subpool(sbi->spool);
 		kfree(sbi);
 	}
 }
@@ -1423,7 +1421,7 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b759748468734..90ec015a11181 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -177,6 +177,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
 {
 	unsigned long flags;
 
+	if (!spool)
+		return;
+
 	spin_lock_irqsave(&spool->lock, flags);
 	BUG_ON(!spool->count);
 	spool->count--;

-- 
2.55.0.229.g6434b31f56-goog



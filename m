Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D845A298;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=KYX6blh/Oo3WyRRCMVQypesM9c2sE92XE1NicfzvWvcdp76Mzx4aksLhzl941ech4qle+GIQQlwP0PcQcPWI6Af1N64Pguo/3WQYYqN+mF6TLLgAVqXH6LEii/sk7DdV6iwHQdMh495LImdjjITGr53Ij2joJsuzElorufAQKmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=5jfm2MbqP71BsjfPjrd0Br42vvUHXqP+s/GdXagyPXY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nMPWMPSgNZW3rgn3dQxeNEqPCiv5xpHR9h6K6UhMnF8zeFQmGVBcX0F6xZDA7Lyo1zU+wNj86/WXUVdoT/xI/H8L3k8irgbwb9Lf9PmkbM1okyeDtvGDok6aV1uuF5BDGo1UGg2ysTqqbDtJPNNS35zX6br+cTBL5WIy6jA8XXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFzoNq87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFzoNq87"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A4D3C19425;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=5jfm2MbqP71BsjfPjrd0Br42vvUHXqP+s/GdXagyPXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TFzoNq87S38GGo6Ssm7lOwhxQZMCtuARuGEPFPG4IS5BpH2vy5rIMSFiaSyYpl4mJ
	 Xm0VJdnaW6UqgomQ7nAzsoeX2WAIQnZ8lT26S5m7JpYb1ESNUWOYt1V8cx4zYeqQLY
	 sED7WuyAx3Q/WXzc1/6v6MYjVuPRnBB9ahGBSYFR90eqZ1Bps6JovLDKWQ2XPcuEjy
	 h9tq65Q6RqTBhyMp3VmgKPnOLD1k9HsiVZpHD6nlbAwyV+X5dUnm/GHgtuNoqeYTZb
	 pCqBsZimkvBmjF9jR1I9VI6amHsMAUhQ436dSFTfZ79Qe3D41HpWxv80/Yo3E4sdx5
	 FVhF9YAYEb2OQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35563C4453A;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:15 -0700
Subject: [PATCH v4 07/16] mm: hugetlb: Fix Use-After-Free in
 unlock_or_release_subpool()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-7-88e8b81970dc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=1786;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+8BKlqcw0osweyRZX4DVMuCuKwenNXcfBjXVW5HQiFI=;
 b=1QJ1v6HnKCN4SUgfZ0zCwSM1fabe4JN3I0E4aRntYBp8Vk2QcabaSyeAnsKBGGeTC3Y76lQen
 YmRVqUCR2SyD0f88goOEuJb9brctkXRJonc3/dbLVzTo9GlGyTpg6do
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

In unlock_or_release_subpool(), spool->lock was released before calling
subpool_is_free(spool). Because subpool_is_free() accesses spool->count and
spool->used_hpages locklessly, concurrent threads calling
hugepage_subpool_put_pages() or hugepage_put_subpool() could race when
spool->count is 0.

If Thread 1 drops spool->lock and is preempted before subpool_is_free(),
Thread 2 can acquire spool->lock, decrement spool->used_hpages to 0,
evaluate subpool_is_free() as true, and free spool via kfree(). When Thread
1 resumes, subpool_is_free() dereferences the freed spool pointer, causing
a Use-After-Free (UAF) or double free.

Fix this race by evaluating subpool_is_free() while holding spool->lock
prior to unlocking.

Fixes: 1d88433bb0085 ("mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8431c00d48267..b759748468734 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -137,12 +137,11 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 						unsigned long irq_flags)
 {
+	bool is_free = subpool_is_free(spool);
+
 	spin_unlock_irqrestore(&spool->lock, irq_flags);
 
-	/* If no pages are used, and no other handles to the subpool
-	 * remain, give up any reservations based on minimum size and
-	 * free the subpool */
-	if (subpool_is_free(spool)) {
+	if (is_free) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);

-- 
2.55.0.229.g6434b31f56-goog



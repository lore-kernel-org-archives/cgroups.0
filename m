Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7DB3A0E9D
	for <cgroups@vger.kernel.org>; Thu,  5 Mar 2026 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772712005; cv=none; b=VE1EvyVrjCQayGhYmtG0WdjFa1dW0uD9XEqqTG/KC0JCukT6yFV6ULgeykhQD1S9eiEmS+mQtRKYjsg8RnYCfM5Vm672hVKS3fOY8vjbqnYoD55WKivwwMgaLLkDEloClKNh6GX5LXSzwPXC2bHn3RRpuhXoLvgP2kPKCsSPDwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772712005; c=relaxed/simple;
	bh=lomsJiRun49fJQhC81vs2LmoS+7TmRP+dsmyx7T2TzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNkmWgiTWPHQXXkpo28X0qY8OpGL8MqK1joqw39OkopikUWNmZdjBD/QVZmYrfJksqzMBxUmxa/B8zTtBWahMbbnDdsExC1CQxeJdPVnpooOZHFR6nmX+6YDOdDwq6Z517ttU33DWBRFVRWJECQECF7TqlMX0/wiNES5Ko1WrSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ULgx3CO2; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ULgx3CO2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772712001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ME0/F5y30Uv1s+QbxgHUtCa7ObeVmIsWm7RG/5Co0FY=;
	b=ULgx3CO2HqA2P9ywrhLXm8b1vwiy/kInSpCXg3uJ+8iCynQKk54mAUKR9fYwxk8bU0lEzd
	4GHK8veV3AqtbXGyEWzW4/c86ienIwVtSTyWnY5zODh2lVJf13R2dG+oU06J7xNhi9Epx/
	PZGWtvUyHzmkZptXFjRRD3J4kQz1/Hs=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 33/33] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Thu,  5 Mar 2026 19:52:51 +0800
Message-ID: <2c90fc006d9d730331a3caeef96f7e5dabe2036d.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Muchun Song <songmuchun@bytedance.com>

We must ensure the folio is deleted from or added to the correct lruvec
list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b53..ad50688d89dba 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -342,6 +342,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -356,6 +358,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -370,6 +374,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f9f66e0b40e1..73bfa93696a27 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1920,7 +1920,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


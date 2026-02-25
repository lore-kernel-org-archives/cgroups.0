Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F22E8897
	for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 07:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772005860; cv=none; b=ZVe3ZVbidwLvnMUD3VVnzCxoWSlFydPs+UDP3mgKssVz0M+Tu36myPxoh3l4kmi7uHeTjJ0f5OYy30vAgmUSTyajn/cNRZxVEiiGWyHPeEZg63WNRm0SflvJReS3u+BlT0kOmeaY/pw7MRQUzRfSY92dv+IuRQhaF0bw/aRYjww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772005860; c=relaxed/simple;
	bh=9c31522ZsrW1siZuLCpKFXj9Q1T2hnhqH1/dr7ntmNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss/+ZTwrRgTlP5minh6TwnKTFARI9b1i7+tkBEOdheo6XMlhcQgItI3iY8Y6O4SthV8Ni1udvFlaawo3UHYpZmZfl357PA0r7ap1rhL2AUNx1Sn+2S5A6TbT18Scvi/SrXxpBNaSEmPXSIJcG9uiX3I+1LVCP0mjB/K26LvL8P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kSEBfFCo; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kSEBfFCo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/198v9MPJs+KJCrWZ0LWBhkz6feBqnUHTx73TsS3q/w=;
	b=kSEBfFCoTY6CSo+CQsjXZoqRgLSgNwJWY78h9wNrmHKn6b/6//0bFsi9oatIQPlm7vnmuw
	WwZHqyJ2P+yL9L2FU4sopSApUmXQa5/JAYLF+u1OP9VMyfvoyy1MFfFq3fDOdFft5D3F5j
	8d2j7c0gJTd7CDPUvCebJDj4XiKh1Gs=
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
Subject: [PATCH v5 09/32] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Wed, 25 Feb 2026 15:48:42 +0800
Message-ID: <d6d48fdcf329c549373ac0a1c80fd9f38067e34e.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba574..343c97eab9e57 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -922,8 +922,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -944,6 +943,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


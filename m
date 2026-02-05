Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3437B3E1
	for <cgroups@vger.kernel.org>; Thu,  5 Feb 2026 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770282177; cv=none; b=RcvZsaxV3QxOQ/FNNWEyzHLrvBhLNPBrvqd/s+3YooKZ1GkQoSKdI7IrteBz3i/tpyI12ODtFj1VU3NAMxnO3fUpvyXYv+EFrl9Agf5vdYKzidlldto93ba+BPx5fFoHRCy6I9kyIlcp1ZJ6qbIVX3dhyo9VZTbn2m56pjbRwnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770282177; c=relaxed/simple;
	bh=sdbiiDWlwPwTxO+iS9bBtnS7KEtIQMdNhIjZr+nfeq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7TS6PwvSUA0ENDR7QkdUdMGYaHTVW5UCUfPVnBa4AnnAGUtFXiRL8v4OHfkOmNDZjjRurGMNMEMDAKGD4ifwTxh1FMa2evY9xLI2JBJP+u61SNDLzQ/SAhYtxSrThAS7z8F2PABhhfDTXje/tBlB9B+7z15CYJor/GVNexgkag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N1OtdHXU; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N1OtdHXU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAOP1V+p8DjZyPt8ukquYlqE0yR6eZreaGxjmoz7+YE=;
	b=N1OtdHXUihchpXMDHhkMzio44iCHxAJ/sdu5PAUUE4RMn3vsydl6nFRilXucTN4RWSP5wV
	5hr1bW/nlblRcvODBSzsYaD9LZof+CH9WmtVPFwBlhQil8sxsyyDyU7+8ymQOqEF0Wpim9
	VVLGOTTpest5FZFx6sSvie04tLkSvHM=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 13/31] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Thu,  5 Feb 2026 17:01:32 +0800
Message-ID: <4230a3381da7605324eef432c19e24eb6dd3c0fe.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
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

In __folio_migrate_mapping(), the rcu read lock is employed to safeguard
against the release of the memory cgroup in folio_migrate_mapping().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd4..45ba49af2136c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -672,6 +672,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -699,6 +700,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
-- 
2.20.1


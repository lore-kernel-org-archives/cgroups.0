Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22B9383C7D
	for <cgroups@vger.kernel.org>; Thu,  5 Mar 2026 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772711808; cv=none; b=Rq4NnogmxWvUaTOb6MBBeDE62ln+c0cAqIBXqxBacPOc8KgHDwUAJw5onG73V5Cg4bag8MEPzua95rk7DaIwFdDk0JLla++GkmvD8J1lWmLbCYaG1SIFISXKjPe+7en3B5xFhGIc1V0rPkjiCMiyXmAlPNyb0S23mHsG+Os4Vtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772711808; c=relaxed/simple;
	bh=d++7Mji7sslSIpALnZvyQ3DoWN99uHX/f4AP2kZE3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jezd2KZRPNkYkZjQoDk0PSnuq0ErxFa4zcP3Enjqt2PWG5/UigVzKa8Ah/HDBaZGhekY8oASNQ1Rc9nxevCfv5u/Z0G05Wnjo1ux+RXExHfsS5aNogIA2ZENhP2j1auaQuuokQj8GOPD6DHsLLvUuybf2sDSh746eIRkiPqMcE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rFyAWsFw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rFyAWsFw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evy5ffpxH1pOU6KU8S5DoExZmuc8IAjbV0oiS0M36hM=;
	b=rFyAWsFwp6ftMmtwWBjFPZuuy+ovo7+R0luaziVgpgjr5WTaq8+zWKMGUQzhQlZfUTq3Ek
	gEz5fQWKGv5h+FfKYvTOMlmL4usXczqwQMgmQxXj1wwI9eoEvsMGqEZREUbRjLpCLamjX1
	zhtW0Qi/5QgfqLC47w3RZu4F4drXcPI=
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
Subject: [PATCH v6 15/33] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Thu,  5 Mar 2026 19:52:33 +0800
Message-ID: <21d1abab7342615745ea4c18a88237335ab44d13.1772711148.git.zhengqi.arch@bytedance.com>
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

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in mem_cgroup_swap_full().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a4bb8b8b2c457..063fdfdd58223 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5345,27 +5345,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (!memcg)
-		return false;
-
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			break;
+		}
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
-- 
2.20.1


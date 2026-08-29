Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09D72AF00
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 02:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787970777; cv=none; b=lpjzoHVhuHrX2X3h5wTSdyXGgin+xutqyfdOtcq2C1SVc8Get24xeTpEPjASjhnk6WFc7JmPQNCCS/qaSpqEqjRNfLhRGPwhy/HmWfK0dZf1nJIrdaN6FvHNlXd5MMIPHvaCkR3pX26GcrcKTWPGVmcSpdbcBQ3vB3E1nKE91Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787970777; c=relaxed/simple;
	bh=H1xtjBEAg3BPif39hck2d213NLc0Z1FDsX7jcBX47e4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZiNFKKSk2dTqPbI2JNNIwWEsYFCSbDwXWchDYPTkMYpkhS097+0KIAbr9cs9hJQKBkHVm0giao7OmhsQJnap6RJHhCBTiTpp7Oy6/iFrqH8DV8VRsuDRX5sqDCURQHfKf26SvZ+IkKL7f1SV0S7zc4JQvP3UBs1G4VcoZeMkYvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e9qHmgdf; arc=none smtp.client-ip=91.218.175.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e9qHmgdf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H1xtjBEAg3BPif39hck2d213NLc0Z1FDsX7jcBX47e4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787970774; v=1; x=1788575574;
 b=e9qHmgdffEAllsCyb3XwlS1rkgZlJ+NInPSUhsjHQBBpLcbnM72Sqa9kufFDnea4Tv1p6xZD
 sDGOTlrdvt8vXOZHdHr0d9g1mFa6Q7Gd47tBmMEe6Iw3EBGaff36Iq5/7Mo9+LfWUS1VcWeqLKQ
 8QEvlD0bKue2ELQbhlMl9y0g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dddd84c8fda15912;
	Sat, 29 Aug 2026 02:32:53 +0000
X-Mizu-Trace-ID: dddd84c8fda15912
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	stable@vger.kernel.org
Subject: [PATCH] memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
Date: Fri, 28 Aug 2026 19:32:51 -0700
Message-ID: <20260829023251.474083-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
try_charge_memcg(), which does not short circuit the root memcg.  That
memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
objcg was created for and is never updated, while memcg_reparent_objcgs()
does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
child of root therefore passes every obj_cgroup_is_root() filter but
resolves to the root memcg.

Folios keep the objcg they were charged with, so this is easy to reach
through zswap: allocate anon memory in a cgroup, move the task out,
remove the cgroup, then write to the root cgroup's memory.reclaim.  The
reclaimed folios are charged through the reparented objcg and end up in
refill_stock() with the root memcg:

  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   [...]
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30

Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
skips refill_stock() for the root memcg, so the root's page counter grows
and is never uncharged.  It is not user visible, since memory.current is
not exposed on the root, but it is a leak.

Use try_charge(), which returns early for the root memcg, restoring the
symmetry with obj_cgroup_uncharge_pages().

The above sequence was scripted into a standalone reproducer (zswap on,
swap on a virtio disk, 512MB of anon memory faulted in inside a child of
the root cgroup, the task then migrated to the root cgroup, the child
removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
first zswap store of a reparented folio, with the same call chain as the
report.  With this patch applied the splat is gone while the zswap store
count over the run is unchanged, so the same path is still exercised.
cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
failures.

Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---

Note: I kept it simple for easy backports. I will followup with more cleanups
where I will remove try_charge().

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a18ee4509ab..1709ac96bbde 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3157,7 +3157,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
-- 
2.53.0-Meta


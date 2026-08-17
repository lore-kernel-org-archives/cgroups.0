Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61593B42FE
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 10:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963126; cv=none; b=GZgXl7DnIfSou5kPdzNzgi+jvlcRmSsxRqEZ0Jsf8JT9zBVNFTOcWOxXUez3q6jrNpO5zM5avPfEznnBcbxMcFX2BEx1J2lLJWbUWHMvm1m4k7Uhrh1OzfKjuIXinx9ZjnqBnhn1Srrl13dmmcHtovImxOo7/iwEihOYJJHHJBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963126; c=relaxed/simple;
	bh=16wS0vaFpZB02cSosiEXtjgYZz176GFSDjHs0guh5kA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V7LByWzMlRzG/EaFq8QuTus+nZcgGSgGhgSnEfvI1LhNT3Q8psTPhWM0V0MMb4nErKPHDjZnjLhX7RVDGUeX5w2LydaCIOSHuThis3R1SIXn/ekjbaUvsgQtva1+1mxZJaJdPJ2VmiyGV4G583ZRIxP48PdvNnEzxjg0HZggIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lpd/3j+C; arc=none smtp.client-ip=91.218.175.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lpd/3j+C"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=16wS0vaFpZB02cSosiEXtjgYZz176GFSDjHs0guh5kA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786963122; v=1; x=1787567922;
 b=lpd/3j+CKFZSIrHQ2wXf/5tK9INfQC8afXAXzF7N/PZkcVwDykX0RxZp43l3VnXcuRO/1rTS
 yUHA6KvUy+rqWgCRN4cu6QzffYP7MD0t42fXiZ1EgzJJ3syV1QFRPl7KbbLECdHBJRCR1U/Hjwf
 CShAzZpZCvZjz2koM3+v7ilk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:6::)
	by mta11.migadu.com with ESMTPS id ef52f60d09db3a3c;
	Mon, 17 Aug 2026 10:38:42 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: shakeel.butt@linux.dev,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org
Cc: kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	kernel test robot <yi1.lai@intel.com>
Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
Date: Mon, 17 Aug 2026 03:38:35 -0700
Message-ID: <20260817103835.2937733-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
vmstats_percpu pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
60-second run on a 176-CPU test system.  Those writes bounce the line
while memcg statistics paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the
test system with one socket. The patched kernel brings the performance
to within 0.5% of the parent which is within the observed boot-to-boot
spread (up to 1.2%).

Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
-- 
2.53.0-Meta


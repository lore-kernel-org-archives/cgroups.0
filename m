Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.204
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315694;
	b=iuGMwRyJOTu/MeiP841DKvdpzEwaMveNwshbLOLz/TIFr91QIw1RXof841p7Cw9ggbol
	 voJ+HGBbaQ1b2Ilv3SHbCAaG1gKT6EBLG6hvoSPxZM2YxmDJatcZlccTplwt0oqyRkZCc
	 PyHQTJFl5Ntk5ZXPkdBXteuZ5Ukqj7rRmh2gmKCiphXTv0xLUETN0jJD40SAS9UkBsPwK
	 ricLumO6ufvxXAQVZdTKPDRPxlhT8yw/ERSWUKJHk9xjSQmuKjIhdv98Ljnavdu+aya/4
	 DC7a8QdXwUFTXvTB0xmUTjwVQjr6s0q4/b2a9hCypTI45sTnvGm60rOJvKT3glwEeQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315694;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wvXKv2uGoryhV8ejGU2oe5V38xffHiqxUDzEj+9Yto4=;
	b=vVkl+aSI1FJtbYdSt1nFq8DQui636KUzXyGB/1lgC/OYtdcJz21gDidqr6lxYVT9/tc0
	 +q1PMLvmiDr1P7DCUlrev//a4YijaSF6KdNyEC+J9tcHRrHOfTQdKNNEICrbjdy8QJiEX
	 MIfO1S2ul4FY8xdfmkshID66zbzqzMyzwiuFueSWpCXlvk0835dXDnC3KlPtM+jiRidE3
	 9eqUoc7MUETRbncFbEgDJKeCPEIpaM+uRIB6TL3HSuZ1/amITp4R9KnKjDNKNUhiAPYe3
	 9LLnU+Kfa7tuv/BluL/QFSQDLnO2KTEpAtAGFRQ1bSMhL9ERzsfbsQCNBlKQUkMcyzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xgBbcIYd;
	arc=none smtp.remote-ip=95.215.58.204
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727B60A260A
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7727B60A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xgBbcIYd
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FlgX4ij9PP8OLUKybf0hSOU7C77RZjMnD053eX5Rndg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315691; v=1; x=1795920491;
 b=xgBbcIYdsWrScz/oSs25iQBtmCvRoJPC5puXDBYAuVeVwGFLVNe6SaeNj5t37nhEfm6o5V69
 TohB8FPxWLMSjKUQPM01Mdloy556YRU4Wj66DO4wzWnehgJNbQSia2eDujE02ZzdcGuu0rnFAXF
 uNNkVmPxBss03ajpBYuueN5c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf46edc9697afc8d;
	Sun, 22 Nov 2026 02:48:11 +0000
X-Mizu-Trace-ID: cf46edc9697afc8d
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/7] memcg: remove synchronous memory.high enforcement
Date: Sat, 21 Nov 2026 18:47:36 -0800
Message-ID: <20261122024737.2741569-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A task stuck in memcg limit enforcement in the charge path keeps its
locks, and tasks in other cgroups that need them wait for a limit that
has nothing to do with them.

memory.max is a hard limit, so the charge path has to enforce it.
memory.high doesn't: since commit b23afb93d317 ("memcg: punt high
overage reclaim to return-to-userland path"), the charge only records
the overage, and the task reclaims and is throttled on return to
userspace, where it holds no locks. Avoiding this priority inversion
was one of the reasons for that commit.

But return to userspace is too late when one system call charges a
lot, like mlock() of a large range. So commit c9afe31ec443 ("memcg:
synchronously enforce memory.high for large overcharges") made a
charge that can block handle the overage right away once more than a
batch is pending. That step reclaims and sleeps, up to 2s per call,
under whatever locks the caller holds: mmap_lock while mlock() faults
in a MADV_HUGEPAGE range, or invalidate_lock and locked folios in
readahead. It also misses THP charges in other ranges, which can't
block under the default defrag setting.

The previous patches handle the overage where the task holds no locks,
or only the locks of its file, in the operations that charge the most
in one call: populating memory, shmem fallocate, buffered writes,
reads into user memory and MADV_COLLAPSE. Remove the synchronous step.

Other paths now handle the overage only on return to userspace, and
memory.max still limits them. Many can get a hook later. For example,
reading /dev/urandom into an untouched buffer reaches 513M under
memory.high=64M. With THP on, it did before too, but with small pages
the synchronous step used to throttle it. Another is mprotect() making
an mlocked private range writable, which copies its pages with
mmap_lock held for writing.

Update the memory.high documentation to say when tasks are throttled.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 Documentation/admin-guide/cgroup-v2.rst | 12 ++++++++++--
 mm/memcontrol.c                         | 20 ++++++--------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..215710a44a88 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1386,6 +1386,14 @@ write "max"; to set it to zero explicitly, write "0".
 	over the high boundary, the processes of the cgroup are
 	throttled and put under heavy reclaim pressure.
 
+	A task is throttled when it returns to userspace after
+	charging, and at some points in long operations, such as
+	populating memory or large buffered reads and writes. A
+	system call that allocates a lot without reaching such a
+	point can take the usage over the high boundary by up to
+	the amount it allocates. Kernel threads are not throttled:
+	a worker reclaims for them instead.
+
 	Going over the high limit never invokes the OOM killer and
 	under extreme conditions the limit may be breached. The high
 	limit should be used in scenarios where an external process
@@ -1396,8 +1404,8 @@ write "max"; to set it to zero explicitly, write "0".
 	reclaim is bypassed. This is useful for admin processes that
 	need to dynamically adjust the job's memory limits without
 	expending their own CPU resources on memory reclamation. The
-	job will trigger the reclaim and/or get throttled on its
-	next charge request.
+	job will reclaim and/or get throttled after it charges
+	memory again.
 
 	Please note that with O_NONBLOCK, there is a chance that the
 	target memory cgroup may take indefinite amount of time to
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6d147153bd06..4771730e017a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2615,8 +2615,9 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 }
 
 /*
- * Handle pending high overage during a blocking charge or on return
- * to userspace.
+ * Handle pending high overage on return to userspace, or at a point in a
+ * long-running operation where the task can sleep (see
+ * mem_cgroup_over_high_throttle()).
  */
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2725,9 +2726,9 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
-	 * Check the charged cgroup and its parents. Local charges normally defer
-	 * reclaim until return to userspace so it can use GFP_KERNEL. Large
-	 * pending overages may be handled synchronously below. The handler looks
+	 * Check the charged cgroup and its parents. Local charges defer reclaim
+	 * until return to userspace, or until a long-running operation reaches
+	 * a point where it can sleep and calls the handler. The handler looks
 	 * up current->mm and rechecks the limits. If the task moved to another
 	 * cgroup in the meantime, the handler works on the new cgroup instead.
 	 * That is rare and costs little.
@@ -2765,15 +2766,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		current->memcg_nr_pages_over_high += nr_pages;
 		set_notify_resume(current);
 	}
-
-	/*
-	 * Earlier charges may have left high overage pending even if this charge
-	 * found no new overage. Handle it now if this charge can block, to limit
-	 * overrun while the task remains in the kernel.
-	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
2.53.1-Meta


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.231
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315695;
	b=EJfI87Cg+lEcm0nT/0rbIUOTjQeg+eccCxEiDPt/63RnJEjeEsYaZZ58ACkvqecovjEM
	 bUbLK70blEIfUMFK/3+Ic3g2ETQIatDRxPIe2EuqU3Sa8ymxbLrBtpaOuJMjwgd7yAPEO
	 TWL7x1i9rAEiGUPWl14UiKZ/BBRPLCDqueFpTxLD8tr5CXFEfr7YX9wyC2I9cvevIQyq8
	 DQBmhKvAUn+J24uwYqSubp91lCAO62FA986ATbOaMn6pD1iotvtwCPbIrRG9AD9f7qzjh
	 zutL2A2sGueL9iaR8epVT3/zzf/wGNIGw4GmUbm1tP6dAur8eFz6Cy3eKFzyb0IixGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315695;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E9PD9aOANTvQHboEG3uZgcAavMQLIgieVrLH9GH/oL0=;
	b=RBzJR1Nc05GI7dvWMQWm6r8vhfm2zypqQ5RxqUzkjoLp6M5Rf3t2SRfp5CGJ51D/DYtz
	 m1QcSrwg+jpw6O/iNfu82zx92eNd2CgW0I56FsG1mfKyXsL1QyP3WE1HVQikz5MD4yemw
	 JbiIOSy+kjQ4VJ+qRjxj8BeGid0t8Oh2MJoiXUZutCGBdT0g3boo/Fos+hpGsroavjUGo
	 7XwMrq9mj67QBN8PD1Et4QgZX8AGcW9uWqe7DAfjsMdiNZ6kqvNZf5MwraWYVXK2w7Pyu
	 YLpbWarlmY0pPFgg8HleiTAAgn4EYQfYx3s8SA8+k6MR4GYN/Fj/MI+CYnSD8GfhF6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vh6p6hz+;
	arc=none smtp.remote-ip=91.218.175.231
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C60606A32C
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46C60606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vh6p6hz+
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gqIN7txgscTN3NZxToZ9cIdy5PReEg1UWTFzKR5TdBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315693; v=1; x=1795920493;
 b=vh6p6hz+QC7kt4cKEXLjj/gDKNipkYbr+4+Smh8XNRgxwXfkPvvgmAmYgsYyhz7R3RLxeIlk
 B20/wOUqhg7oiduHUlwUtd4lygNKMBS7yp9kJ1W+dnc3n3HQtO+zLT6doeOM2m411cPwI4y8EYI
 V8IdtCGBZ6JBhugZbTcZLmXg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 943718c149af7563;
	Sun, 22 Nov 2026 02:48:13 +0000
X-Mizu-Trace-ID: 943718c149af7563
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
Subject: [RFC PATCH 7/7] selftests/cgroup: make test_memcg_high_sync check that throttling holds
Date: Sat, 21 Nov 2026 18:47:37 -0800
Message-ID: <20261122024737.2741569-8-shakeel.butt@linux.dev>
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

test_memcg_high_sync mlock()s 200M with memory.high=30M and
memory.max=140M, and expects memory.high to throttle the call before it
reaches memory.max. But it checked memory.events right after the first
high event, so it passed as soon as the handler ran once, even if the
rest of the call was not throttled.

That hid a real gap: with THP=always and the default defrag=madvise,
THP charges skipped the synchronous handler, and only a few page table
charges ran it. In a VM, usage reached 85M within 115ms and memory.max
about 2s later.

After the first event, check for 5 seconds that no max event shows up
and the child is still running, then that memory.current went up.
Counting high events isn't enough: one handler call can log many while
it retries reclaim. Also kill and reap the child, which may still be
throttled.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 39 +++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..1af984761a02 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -771,14 +771,16 @@ static int alloc_anon_mlock(const char *cgroup, void *arg)
 
 /*
  * This test checks that memory.high is able to throttle big single shot
- * allocation i.e. large allocation within one kernel entry.
+ * allocation i.e. large allocation within one kernel entry. The name is
+ * from when this was done synchronously in the charge path.
  */
 static int test_memcg_high_sync(const char *root)
 {
-	int ret = KSFT_FAIL, pid, fd = -1;
+	int ret = KSFT_FAIL, pid = -1, fd = -1, i;
 	char *memcg;
 	long pre_high, pre_max;
-	long post_high, post_max;
+	long first_high, first_current;
+	long post_max, post_current;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -811,17 +813,40 @@ static int test_memcg_high_sync(const char *root)
 
 	cg_wait_for(fd);
 
-	post_high = cg_read_key_long(memcg, "memory.events", "high ");
-	post_max = cg_read_key_long(memcg, "memory.events", "max ");
-	if (post_high < 0 || post_max < 0)
+	/*
+	 * The first event only shows that throttling started. For 5 seconds,
+	 * check that the child is still running and doesn't reach memory.max,
+	 * then that memory.current went up, so it is throttled, not stuck.
+	 * High events don't show progress: one handler call can log many.
+	 */
+	first_high = cg_read_key_long(memcg, "memory.events", "high ");
+	first_current = cg_read_long(memcg, "memory.current");
+	if (first_high < 0 || first_high == pre_high || first_current < 0)
 		goto cleanup;
 
-	if (pre_high == post_high || pre_max != post_max)
+	for (i = 0; i < 50; i++) {
+		usleep(100000);
+		post_max = cg_read_key_long(memcg, "memory.events", "max ");
+		if (post_max < 0 || post_max != pre_max)
+			goto cleanup;
+		if (waitpid(pid, NULL, WNOHANG) == pid) {
+			pid = -1;
+			goto cleanup;
+		}
+	}
+
+	post_current = cg_read_long(memcg, "memory.current");
+	if (post_current <= first_current)
 		goto cleanup;
 
 	ret = KSFT_PASS;
 
 cleanup:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		while (waitpid(pid, NULL, 0) < 0 && errno == EINTR)
+			;
+	}
 	if (fd >= 0)
 		close(fd);
 	cg_destroy(memcg);
-- 
2.53.1-Meta


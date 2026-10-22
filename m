Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792708796;
	b=nWE2Ka0dckv4SmPkQbShJ9C+twahh7kVFTtyDSrYBoYhc5W4eUW2/j71VaMwSk5f2iLj
	 5/HU7nXFEdcLmX22kT6iwSThFJto9QjjS71LZ2qNjgdtj354rSfiiby5KhePSdw6p1onr
	 25+ovtrnI3KqnzObVcNTb4lCM4KuMt/2YrXqIl2btJmHrQg+3aFT3nbDzaCIvcAnKEKFy
	 nJu0PtdBx99+3Z9HJHkFMSQKSsaH+mCp0H6jajzrFp2Bv7Hhhue5jyY6OVMRCRfta2Zev
	 GRGQy/XuegkBuMVCRU2se+5jzhP0Gh1MWo0l7X4eXTBK3j3DZHSX5PKVM4Lk4HW5ffQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792708796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
	b=0A7wVp6PJVPvHiuW1XjlufCNs1PQ1ItYvXC3ONetZ40QSIqDsdeRHISzU5fOiM0NEtVs
	 J7FomX2MPe0ipwYZS7BxqSbzNaFYcM9aw+LU1KbW2e6DIyIrglzcTe0osWOpS5i8DQ31C
	 6OA05+64CCWSXT98VavFJO4+bFQjebyKxkH4QhkxNJXNKYUJCIGrXlPsNVzUv3rO5YFcw
	 Ld421a2M+loNKV61lBPrdlY/IXcqPPhnpxn1OAae3wkstc8OBrgd72U24e3zu6KipArSe
	 +PCgpYqoHIai4lRpgGbbyiS4ErOzImSV6VLewcscuwA0lRk5ILx2Mk7Nm3pW72T4d5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BWYJDvBx;
	arc=none smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18494606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 22:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18494606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BWYJDvBx
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-679a2b540f3so344447d50.2
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 15:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708795; x=1793313595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
        b=BWYJDvBxc13zcWVa9gU5C2ky/jIuAyMCfTkpLLedsExzpQVCO8KlBdSEMDmaZc85fw
         tZCq8HyS0ejA3xBh7KQZtbUfpoBlf37xxyLqvIa/41KuWAPUmLWwnmpBFlW07q2Q4mkN
         kw5k0Greh+Dws0n8a7RsUxI9LcZBnxfX7RyJ7wnuOaUtcGWA7dbLqB8ZQ+XjvPT3xrwA
         FSbJGPguTZKPBYA94AB1D9Zwsjs9u6cBrWNsAgexssfhgc1VdEoySXdJrY8Z5OqHyc/2
         rbPkSRb6qzg+Xaedu1jsJ9NPAPNNJYwnDNX/GHMb79sUMrbFipShhWRYgP7oX86cVl6t
         cSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708795; x=1793313595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
        b=rzE4MW1UPu5e9QOz9+WGcFUAbjrA3iJQi0tilXZoxu7lWl5RAiCrCp1o6/jAqy8gg2
         KsQwrybL8t2ad5kKNLLresXZkK7RlAx4b2Jvcwzwi3F7QwKcuBpBgwEaWxSgO7CqjYDx
         8KFzAyH2cR4A9cKoYQTjx7/3wDqdGiqPff929dFnUOQxTQaUpvCBXWs38rS+2VlbbEg8
         GaPvohOZju2ZFrc06XAUfbCAGgMBvtohXJuwLsoN4fGxW61g+blb5JpoQEGUNBRDmxLA
         kKO9YRIDLky2n2pYbAFwK+NclFshaNq4Gg/W/ULszZzzU7R0zoOrVA0nIZGMF83Mu2tc
         Nzhw==
X-Forwarded-Encrypted: i=1; AKwUvBwVPEgofBe1uTHuXQOD2Yv8t2KG2c2FOhTckSMC+kuaWAH8qFT4ZrLpHonCTVlmzqe2FnjRzmaD@vger.kernel.org
X-Gm-Message-State: AFq9FYKkWm85e61BlZjhNpI6H6DIU9PFJLW0jGBswUEH5WtbjoDvBAAW
	j/llMP2QMf0TUAFwN9y77wu50vLLq4/junEw1lAJVy2gmji5Dsn06iNz
X-Gm-Gg: AYBFou0xbllEDgnJaiLNYLQbdKaXzJYynMIPpiB2P8zp5voNFKpQi6uh3dWPyrqnP9g
	JNAjSe8tLQZWulI+MwEqMnjBJXIvN8TXiD9agoH9eHrphlgsNmgIexv2wzTk/bJ7F7/vkBvHWe2
	1qn8wAmWm42qQwJwe5iZkpQTIST95k+SOp6a+L4LhlxeqaByalJeyArkqOf3fNgylJmVnqaHEtD
	kdaJwu2lJh6R0qE3pa/1sBIRFSJVvkE6aAF9tDFmZMqy5ssfRv9N01tDhcZDXrGYcLC0bm/OLdb
	ieEU3d9ZDvv1Bz7ois1oy4QIM1iJ91asS0x/k8cQkWmMCp51408WpI8w8CzCAto6heNFZv0rd9y
	Nux4LT+EfeHIfyiGcqBgBNEffem0pP+VzMu0184QJgAeTmUqWAcpqMs7M1n1uaZe2R+/TfWf8o/
	sCpIyZQVzmgQkPxvQu1PQs9qafBlbFTguL1F+ekY7x1tv+GtxN1Zn6i8nINBcnpR9wrJ5VzYEO/
	hwbAeow4OYS7O7p6rddVkgBAx68jh5vsRy9a/SaJalevxPs+dz2c6pA6p/UdN6BqCTsuLhDyyzo
	vi3gyz677lZP4udZylVU1AFIAC4B5OAb
X-Received: by 2002:a05:690c:386:b0:8b0:d554:a7c with SMTP id 00721157ae682-8b157db8fa9mr3158447b3.79.1792708795054;
        Thu, 22 Oct 2026 15:39:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1561c5e46sm5013287b3.43.2026.10.22.15.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] memcg: reduce cacheline contention between lruvec stat updates and LRU lists
Date: Thu, 22 Oct 2026 15:39:29 -0700
Message-ID: <20261022223930.138779-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261022223930.138779-1-joannelkoong@gmail.com>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
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

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node. These updates are extremely frequent (eg these
updates happen several times for every page that's faulted in, freed,
dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but Intel CPUs do spatial
prefetching [1] and fetch cachelines in 128-byte aligned pairs.
Depending on where struct mem_cgroup_per_node lands in its slab, that
cacheline can be paired with the cacheline holding the LRU list heads.

When this happens, every stat update also pulls in a copy of the LRU
list heads cacheline, which is written to constantly by other CPUs under
the lru_lock. The stat update has to fetch it from another CPU, which is
unnecessary overhead since the stat update doesn't use the LRU list
heads at all. But even worse, the lru_lock holder then has to invalidate
those copies and wait for the acknowledgements to come back before it
can do its next write, which makes the lru_lock critical section longer
for everyone waiting on the lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly, so
that the read-mostly cacheline is paired with the cold cacheline
instead of the LRU list heads.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.59M   (+18%)
  shmem, 80 threads  7.94M     8.66M   (+9%)
  anon,  20 threads  3.04M     3.08M   (+1%)

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..69ed283f7db9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +125,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.52.0


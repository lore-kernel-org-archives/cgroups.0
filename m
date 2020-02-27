From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/3] mm: memcontrol: fix memory.low proportional distribution
Date: Thu, 27 Feb 2020 14:56:04 -0500
Message-ID: <20200227195606.46212-2-hannes@cmpxchg.org>
References: <20200227195606.46212-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fSikhrFs5BcRusqV72w1ZPleJmM+MohxSSUW83ONj5U=;
        b=oBEvIdqy/cYuOQutMhWUrNcPeYL2gICCQr+fu7tq7vVplWwxr0u7hW9ENL65iMdRom
         xFPYrs5j+CvsSDj/SOJ0fb+AQ/JGskuPHfhd/wFPRruaeOtFk7Qsg0IPt9PLNCzvD8GM
         MmHIl/zx6wFCAnLSLRRaK29JxbAtIbEZ+s4gqBOK5c3KKtIn4PFtJZlJHD01gCLtU7K1
         EEkJsiMrCUO5M/l4QvUQDaP2zS6qxa36u/D6n3QWZmfkHyiDGzSoYqRjuxTxE5s1Ij6k
         dRwDWFVoDGKvv8qDZk+m2mPbpSKjWvMiuAVVYT76aAmsqxeBqxRVUU1ugyX8ZIdHdP1x
         pdJA==
In-Reply-To: <20200227195606.46212-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

When memory.low is overcommitted - i.e. the children claim more
protection than their shared ancestor grants them - the allowance is
distributed in proportion to how much each sibling uses their own
declared protection:

	low_usage = min(memory.low, memory.current)
	elow = parent_elow * (low_usage / siblings_low_usage)

However, siblings_low_usage is not the sum of all low_usages. It sums
up the usages of *only those cgroups that are within their memory.low*
That means that low_usage can be *bigger* than siblings_low_usage, and
consequently the total protection afforded to the children can be
bigger than what the ancestor grants the subtree.

Consider three groups where two are in excess of their protection:

  A/memory.low = 10G
  A/A1/memory.low = 10G, memory.current = 20G
  A/A2/memory.low = 10G, memory.current = 20G
  A/A3/memory.low = 10G, memory.current =  8G
  siblings_low_usage = 8G (only A3 contributes)

  A1/elow = parent_elow(10G) * low_usage(10G) / siblings_low_usage(8G) = 12.5G -> 10G
  A2/elow = parent_elow(10G) * low_usage(10G) / siblings_low_usage(8G) = 12.5G -> 10G
  A3/elow = parent_elow(10G) * low_usage(8G) / siblings_low_usage(8G) = 10.0G

  (the 12.5G are capped to the explicit memory.low setting of 10G)

With that, the sum of all awarded protection below A is 30G, when A
only grants 10G for the entire subtree.

What does this mean in practice? A1 and A2 would still be in excess of
their 10G allowance and would be reclaimed, whereas A3 would not. As
they eventually drop below their protection setting, they would be
counted in siblings_low_usage again and the error would right itself.

When reclaim was applied in a binary fashion (cgroup is reclaimed when
it's above its protection, otherwise it's skipped) this would actually
work out just fine. However, since 1bc63fb1272b ("mm, memcg: make scan
aggression always exclude protection"), reclaim pressure is scaled to
how much a cgroup is above its protection. As a result this
calculation error unduly skews pressure away from A1 and A2 toward the
rest of the system.

But why did we do it like this in the first place?

The reasoning behind exempting groups in excess from
siblings_low_usage was to go after them first during reclaim in an
overcommitted subtree:

  A/memory.low = 2G, memory.current = 4G
  A/A1/memory.low = 3G, memory.current = 2G
  A/A2/memory.low = 1G, memory.current = 2G

  siblings_low_usage = 2G (only A1 contributes)
  A1/elow = parent_elow(2G) * low_usage(2G) / siblings_low_usage(2G) = 2G
  A2/elow = parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) = 1G

While the children combined are overcomitting A and are technically
both at fault, A2 is actively declaring unprotected memory and we
would like to reclaim that first.

However, while this sounds like a noble goal on the face of it, it
doesn't make much difference in actual memory distribution: Because A
is overcommitted, reclaim will not stop once A2 gets pushed back to
within its allowance; we'll have to reclaim A1 either way. The end
result is still that protection is distributed proportionally, with A1
getting 3/4 (1.5G) and A2 getting 1/4 (0.5G) of A's allowance.

[ If A weren't overcommitted, it wouldn't make a difference since each
  cgroup would just get the protection it declares:

  A/memory.low = 2G, memory.current = 3G
  A/A1/memory.low = 1G, memory.current = 1G
  A/A2/memory.low = 1G, memory.current = 2G

  With the current calculation:

  siblings_low_usage = 1G (only A1 contributes)
  A1/elow = parent_elow(2G) * low_usage(1G) / siblings_low_usage(1G) = 2G -> 1G
  A2/elow = parent_elow(2G) * low_usage(1G) / siblings_low_usage(1G) = 2G -> 1G

  Including excess groups in siblings_low_usage:

  siblings_low_usage = 2G
  A1/elow = parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) = 1G -> 1G
  A2/elow = parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) = 1G -> 1G ]

Simplify the calculation and fix the proportional reclaim bug by
including excess cgroups in siblings_low_usage.

After this patch, the effective memory.low distribution from the
example above would be as follows:

  A/memory.low = 10G
  A/A1/memory.low = 10G, memory.current = 20G
  A/A2/memory.low = 10G, memory.current = 20G
  A/A3/memory.low = 10G, memory.current =  8G
  siblings_low_usage = 28G

  A1/elow = parent_elow(10G) * low_usage(10G) / siblings_low_usage(28G) = 3.5G
  A2/elow = parent_elow(10G) * low_usage(10G) / siblings_low_usage(28G) = 3.5G
  A3/elow = parent_elow(10G) * low_usage(8G) / siblings_low_usage(28G) = 2.8G

Fixes: 1bc63fb1272b ("mm, memcg: make scan aggression always exclude protection")
Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c   |  4 +---
 mm/page_counter.c | 12 ++----------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74cfd4d..874a0b00f89b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6236,9 +6236,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
  * elow = min( memory.low, parent->elow * ------------------ ),
  *                                        siblings_low_usage
  *
- *             | memory.current, if memory.current < memory.low
- * low_usage = |
- *	       | 0, otherwise.
+ * low_usage = min(memory.low, memory.current)
  *
  *
  * Such definition of the effective memory.low provides the expected
diff --git a/mm/page_counter.c b/mm/page_counter.c
index de31470655f6..75d53f15f040 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -23,11 +23,7 @@ static void propagate_protected_usage(struct page_counter *c,
 		return;
 
 	if (c->min || atomic_long_read(&c->min_usage)) {
-		if (usage <= c->min)
-			protected = usage;
-		else
-			protected = 0;
-
+		protected = min(usage, c->min);
 		old_protected = atomic_long_xchg(&c->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
@@ -35,11 +31,7 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 
 	if (c->low || atomic_long_read(&c->low_usage)) {
-		if (usage <= c->low)
-			protected = usage;
-		else
-			protected = 0;
-
+		protected = min(usage, c->low);
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
-- 
2.24.1


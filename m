Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794782086;
	b=yLSb+QbAIqe8FiJAH6/4odMTtakCDHbQtztCYFdQqy61Fmj0+Sch+aS1FqOzcElRJ84z
	 qHU5thyD/0AZcn1BCqgObOFOqYpEGV4GTbzKACB65auHme1jF5veRQ8Cy+G0TyPhjU3Iu
	 H5AtYgsIIboQuKQvfJWlKl5seAKL8Zef8CqiWW7tdLS78Qj3+X9jN0a+MdGvWt3zdH4Na
	 3IRPIvwlj+FG29LCCvqNXkjqhcN/qMmZsouKc5GJvgcA5gn41eebY1NQi+PLMQMU4BNRD
	 eIHepxvgppUdiReMMOFSy8O65vIA0a8RVWhCdjnIrc8XcOYGW56g2HJzJgaGdafUcqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794782086;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	b=Aa8UtblOWqKgnd4yL7VhQDvq2rhavjG1zuRihuOYWj8G9UsFY8uTcR0j9gIRWUViyhZo
	 SAh9SibSxRK18fZAG93XuHePgvR36fD4tUnqljRumuOnQxWwSrJ50pP4JF5BdPA9Ic5wk
	 ubpjkFK0i4SGl3VTnjiKR/lpIkpHUvdzyfIF5Lpvs26JBlKqRNCpKbTa/GFv2TBwCfNlS
	 kz9DRClpzDXwD8UJQZZo5AQsISGU5Hed7eRIu9ucT+VAAR5joyNVkyzxAHAMHm2eDiKXk
	 WT28PTArLU+PqWs5Ll6F0QTFT+GVacyb8odHBtVfeB8ICksReo8ekzeXHyLulKf7YEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bISE3zh6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251DE606A33B;
	Sun, 15 Nov 2026 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bISE3zh6
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782086;
	b=Q4wbpYZFEgbru3vNPbFyCmn5+2zBhgwhkBgFwo0r9huEevalZtx20v1KJMSjVVDE3nTM
	 PEM9LzdN/qglBnQcmVYstIO4NNK6Xnn2/niG1TO7Sx7gl3Vm7lrTAz3Q0GHeDhPcURmOU
	 1HmMWGwZSi1kpAXIieTJD5FKYyWbH24iEnt4l+DfkcTVsIu2ZvoBzs235z/kSxN3fsURw
	 JFBTT44ze3fzeIkM60VACfrH4fwbpt4KkmghwZukOLylCKPKs4ZGGzCSKWeY8WdC0eCbl
	 n2z9ZruAIkYxNGsnRvI6MC2O8dCip+HAAPPYE6cXlDNq52kgzREUwBn/vCebhCF0JXQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782086;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	b=NBbyvf40Niz5t2LYt6+77wFo9lBLjD50UIdGNNBKdUocNgdZq5enYKFF9zKhSd450vPD
	 deCrPDLVmh7Lin2KrwbT58uGYAS+R9fyS8C9mvdbgUeP1dvNTHJ4VuCuIHWtq0GEvO7Pt
	 GnPmm+jBQTUeGmYVwftw48RplrqSsej8kfbh4sXu6t7yw+csp+xubN4mPqNHedDmw3cYS
	 Ax2NMVo0GP5kWeLYnVdYDLi2bHhtX3giWY4FzezoT++9T7OoPCW5aFsqWHz80Zkhea78W
	 m/HmYmS+D/f3Rfa1Z4blSKQ4taZVoT+L4i1jkQ+/928LIXeAOQdbq2SHcHgnNXHSh2A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D24141F000C6;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782085;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bISE3zh6v5YoUqO4iihTt3xCNizWtnZRLXYlw0YZm5SUXQw2PVXC1o36NG0jXqJwB
	 zD5cbZD/Y+x2YVb1bvi0Ra6bTAOXHii1td465oztARAiXqnquIkVwy4eiAg709Bgjc
	 nRSq4fN0jZOB1n5N5MKjIqFRPngwFk6QUgW60dGrH1MpYaNpgeDZgdhVCmooZz5NvM
	 QuJQjBOw0UbY4w+KKDoWnBffMnZwU7kBc3W2M2RItnpKa01ws1ohNqjvH8cKOzc8de
	 niLttdE2eJFFmyWcqagC8zBNE1EWMoXGSNYOdX1m1mBAVPigRK0WliGnI9ghW7DZVc
	 h9g6iKv0ioWmw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 629BF4A245;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:42 +0000
Subject: [PATCH RFC nf-next 2/9] memcg: bound memory.high delay arithmetic
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-2-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=5496;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=w3ayk+U8FCJ6lXFONsO42X2e0VbfkJT2uJZSfO6L6nE=;
 b=7Z0tS5xgqA3bYLUfmPyREPp431QgCdAYI5U0LRMjsIixhzk90bkt7WUmUx5FBL8IKOplA3krb
 fdElWo/CNpRAFHKXE8tJFC0elxZLFFJXqMoF+ZXM1deKDCqsTXQLByw
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit

From: Alireza Asgari <alireza@asgari.net>

The memory.high penalty can overflow while scaling the usage ratio,
squaring the scaled ratio, or multiplying by the task's deferred page
debt. An overflow can turn a large intended penalty into a small or zero
one. On 32-bit kernels the unsigned-long intermediate is also truncated
before two right shifts totaling 34 bits, making the delay zero.

Keep the intermediates in u64 and bound the relative excess at twice the
high limit. At that bound even one page of debt exceeds the existing
two-second final cap. A bound of one times the high limit would change
valid one-page results. Below the bound, use wide multiplication and
division so a large numerator with a modest ratio remains accurate.

Preserve the fixed-point rounding order. Bound each memory or swap
component before converting to unsigned long, then retain the existing
cap on their sum. With HZ below 12288, the bounded square times HZ fits
below 2^56, and the later product with UINT_MAX pages fits below 2^54.

This work was examined during AI-assisted source review of virtual
capacity accounting. Song Hu previously reported the square overflow;
Zhang Jiao proposed a fix for that overflow and the 32-bit intermediate.
Johannes Weiner and Bingfang Guo also discussed multiplication and return
width. This implementation addresses those problems and the numerator
and debt-scaling boundaries. It is an alternative for discussion, not a
claim of a newly discovered problem or a revision of Zhang's submission.

The accompanying KUnit cases call the arithmetic helpers directly on
32-bit and 64-bit kernels. They cover zero and sub-batch debt, ordinary
rounding, large numerators, the cap boundary, and the prior zero-delay
example. This isolates the arithmetic; it does not reproduce end-to-end
reclaim or throttling with large physical allocations.

Both arithmetic cases passed on 64-bit and 32-bit x86 KUnit kernels built
from this series. They exercise the production arithmetic helpers without
requiring large allocations or claiming an end-to-end throttling result.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Link: https://lore.kernel.org/20260818012115.65838-1-husong@kylinos.cn/
Link: https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2610.3/11270.html
Link: https://lkml.rescloud.iu.edu/2610.3/12576.html
Link: https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2610.3/11904.html
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/memcontrol.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1980fb7431a8..665ce8dfb9ec 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2521,6 +2521,15 @@ static void high_irq_work_func(struct irq_work *work)
  #define MEMCG_DELAY_PRECISION_SHIFT 20
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
+/*
+ * An overage of twice the high limit gives a nominal delay of 256 * HZ.
+ * Even one page of debt then exceeds the two-second cap. Bounding the
+ * overage here keeps the delay products in u64: with HZ < 12288, the
+ * square times HZ is below 2^56, and after scaling the product with
+ * UINT_MAX pages of debt is below 2^54.
+ */
+#define MEMCG_MAX_HIGH_OVERAGE (2ULL << MEMCG_DELAY_PRECISION_SHIFT)
+
 static u64 calculate_overage(unsigned long usage, unsigned long high)
 {
 	u64 overage;
@@ -2535,8 +2544,12 @@ static u64 calculate_overage(unsigned long usage, unsigned long high)
 	high = max(high, 1UL);
 
 	overage = usage - high;
-	overage <<= MEMCG_DELAY_PRECISION_SHIFT;
-	return div64_u64(overage, high);
+	if (overage >= high && overage - high >= high)
+		return MEMCG_MAX_HIGH_OVERAGE;
+
+	/* The scaled numerator may overflow u64 even for a small ratio. */
+	return mul_u64_u64_div_u64(overage, 1ULL << MEMCG_DELAY_PRECISION_SHIFT,
+				   high);
 }
 
 static u64 mem_find_max_overage(struct mem_cgroup *memcg)
@@ -2576,9 +2589,9 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
-	unsigned long penalty_jiffies;
+	u64 penalty_jiffies;
 
-	if (!max_overage)
+	if (!nr_pages || !max_overage)
 		return 0;
 
 	/*
@@ -2589,6 +2602,7 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	 * its crazy behaviour, so we exponentially increase the delay based on
 	 * overage amount.
 	 */
+	max_overage = min(max_overage, MEMCG_MAX_HIGH_OVERAGE);
 	penalty_jiffies = max_overage * max_overage * HZ;
 	penalty_jiffies >>= MEMCG_DELAY_PRECISION_SHIFT;
 	penalty_jiffies >>= MEMCG_DELAY_SCALING_SHIFT;
@@ -2601,7 +2615,9 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
 	 * larger the current charge patch is than that.
 	 */
-	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
+	penalty_jiffies =
+		div_u64(penalty_jiffies * nr_pages, MEMCG_CHARGE_BATCH);
+	return min_t(u64, penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
 }
 
 /*
@@ -2654,6 +2670,7 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
+	/* Each component is capped, so their sum also fits unsigned long. */
 	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 

-- 
2.34.1



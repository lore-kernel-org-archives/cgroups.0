Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5750422533;
	Mon, 12 Oct 2026 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831746; cv=none; b=oS5Qyopj0pSkRV2Pe8Q8cWfiTO5kgHHcAw0wQWGfi9g5cqFtNzR9RgLtpDoJrBCVod5BNrVf2i4KEPZ7Hr1/GkWAvMgqKSZl6Fssmes5c3+pIJD9k5A2oL1PdwwYuB1yP5BthzeB1lgqYJMBF+mkmYJVXhHVlDkNuFcXqmCtixU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831746; c=relaxed/simple;
	bh=sgqSFWt9QMaYDbRATjwngu1xgWH6JMIrDwHY0LfYDgI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DXBR0hvd3j7sHyfORrcyjNutN86awCEUkC+KrAsMrHCUoY8KlZfUFyz0S5rvV4paG2wKVbdULFVZutQPXUqcwqn92H8L/MgCT3GQAc3m7d6lp95ZKh75fbSdthX9Alxtl43qZ4kj3IW5P6ts0QgOM5v4l0iVwpBsLD8kyrlC3Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=KPIVWejy; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="KPIVWejy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=0I8GOwsNfVBf1ocQIOmC6adonpYL2n9Kt8qHuFjsm9o=; b=KPIVWejyViqjaa/MrnX
	I2L86UP++7eo1ClCfbW7c4BLwK9juPQXZEZKcXpDgXGuJ1Qj2lD0+Y91JYsUuGEWuLMxXboiqiCY8
	7lFxWKNkU1aa9xy33O12hZRtKMeqXR319CZ7yfVi9lgo6kDP8ghl1Y0Hcmd0wEQPhogbe819eBEfE
	Ej5vZM8i0rKUU4bxyTOymzyj09u7gYqIE3+kqLSQviTmWccHdunXlXfy+iReqUMCnAGER+SIgmCUD
	8eDNZ1GEIbSFP5JsBfRFefL7aHZvwlt5qoMm/n5MtRhuGiIkRpVTs3xYTIb7O92Li0wJ9EKkSxbNr
	pkfkWDp5L6simrQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLEY-007syj-2S;
	Mon, 12 Oct 2026 21:02:12 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 21:02:13 +0200
Subject: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of two
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3121;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=sgqSFWt9QMaYDbRATjwngu1xgWH6JMIrDwHY0LfYDgI=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS67Pc6tMLHtOZDm0nqsnTDjnJAAAjUD5NZnN
 GVUqCYMcZaJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uuwAKCRBRlgpH+WFc
 KqGbD/49yWgPWlLPSl3HXbdfNNzYwu0VYpGP0ZgzeFk1e9Rhcrgf5Yyt9gIQVQyKvrQY8icvmJg
 qbenPSuqznrQoyPu8h/ZxP/hyO/puP9PFQs8PlR0sYiLsZ8ArLOrMMDHCcgLdKdq6MWugLGICQZ
 viYJ0mvSbL0OkXKgq8FK9iczkJArFQNeNrpKPMX5EddIhE/X/eknopupw7EoTpKtCThRgt8tXOo
 oeKPvgZ2+U9E3osu0Q6E+tLRY5hqi+Bm5NISk2XrbNgO8p414M+Zq17bzYAZfQr1CtcOGBQB3Ih
 RoDbQ3WNyHgu0k4OKruYPCoDHcAGgnerDWry7oZQOCvMnKq8ICtmABTQCBqGgGS+FuweTcTRyaE
 YOYsQqhdwtQRn6FMMT/zd9SnvH/NIlUwv5zTxVom9/LgC4RwlPaHabbcH6YeP5WsrLCQk89cHOa
 umQXigP7ijQtXlKfFPUS1/t7DiO/1abQSyByF0uY9cANTNcMjuQ9Ig+dc/oLayRpkpqrrv2e+Qt
 EMO4XwDp+CA3zTkjMOf8FFC97bsfC9l+JfblFnmzbj7Q48z7PKY3vt/WGUaExWhXSm1ZNOJPWbY
 voEFYRYCtSohnaICiDj78D9AVgeWKLvWw2rEyYtNfp1ZIej/bOB1X7LJPjB7XBT75FTSgUQSttK
 xX6gB0I2p6RbXAA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
two, plus the one-word bitmap of shrinkers with objects charged to the
cgroup. That word takes the unit just past the power of two, to 520
bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
it is padding.

The units are allocated when the cgroup goes online and freed when it is
freed, so a dying cgroup keeps them until the last reference to it is
gone. Their number is the number of memory cgroups, times the NUMA
nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
the peak number of memcg-aware shrinkers registered at once, and every
superblock registers one, so a host that mounts many filesystems and
runs many cgroups carries the padding as unreclaimable slab, and keeps
paying it for new cgroups after the mounts are gone.

Let a unit cover one id less than a word holds. The bitmap still fits
one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
longs, so the unit fills a power-of-two kmalloc slot exactly and, on
64-bit, the memory taken by units halves, for about one unit more in
BITS_PER_LONG.
round_up() in expand_shrinker_info() needs a power-of-two step and
becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
modulos and multiplications that do not care. Assert the unit size at
build time, since the layout depends on it.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/shrinker.h | 9 ++++++++-
 mm/shrinker.c            | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a9..c250ab68d346c 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -7,7 +7,11 @@
 #include <linux/refcount.h>
 #include <linux/completion.h>
 
-#define SHRINKER_UNIT_BITS	BITS_PER_LONG
+/*
+ * One id less than a word holds, so that nr_deferred[] and the map word add
+ * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc slot.
+ */
+#define SHRINKER_UNIT_BITS	(BITS_PER_LONG - 1)
 
 /*
  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
@@ -18,6 +22,9 @@ struct shrinker_info_unit {
 	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
 };
 
+static_assert(!(sizeof(struct shrinker_info_unit) &
+		(sizeof(struct shrinker_info_unit) - 1)));
+
 struct shrinker_info {
 	struct rcu_head rcu;
 	int map_nr_max;
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f2..a9418072a509e 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -159,7 +159,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
-	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
+	int new_nr_max = roundup(new_id + 1, SHRINKER_UNIT_BITS);
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 

-- 
2.43.0


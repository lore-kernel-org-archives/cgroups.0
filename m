Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659861;
	b=xGn762+ClRU1nF9sN6LlSPjEb1gdfkO4ggSPHvodUK5cKphN/sZ0qqGLNxDzdAZ5y0nt
	 H3CuqFrgXyZs/26pwbVb8RiMXl/RMHXz2xxGLn6w7XCI8wRNDXqzF7e5z55Pzf2NaWYQR
	 2eSk+7Eto8zXUxUWBXUyBe58Z6hizQ4pZOVlMOnxB2MyugxURVmusC7MeqgoowWpPUy35
	 42yfhTfK4TUbuECliHYz/F5R1YFJejcI854GbDeovInXgb90MOb3HytFnsJepz69A7goj
	 WSDC9F9irJqekGS1f7ZcgUaHOpLIGb8ipQO7QLeHndMRIPhx/S50QWHJbMxyj5nn4gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659861;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
	b=J7e7lHpwRTGEkI1Sw5Mp+OKvBJMnhbLQXb1idvkRn49RfWEcxs2hAKtEKdwX3DrjuxBf
	 ihaHVIzhmjnkACh7c5UCyTI+YzQ11a561sxee8ryZpqdm5CH40HO3qCY3AbmCkuCs6YGR
	 s0UBAhu22FOBRURMwA0chYVmVE28Let2Kyt2YxmOnLH0dwKOvDmxG3UnS6EuC/EyVdngX
	 1lI/wA68SYtw4uCs6N68zoT4istxPYCUaHI0ZXDuWG5bfhGIjNPF+hydg6SwF3pCj2gil
	 xkWmXfX8bytMZnfEmkRvtPWepbPWmw5xlQcXQQukqN+ow18telmzfwyveW28EITETbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GHKkFYCB;
	arc=none smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B158D606A327
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 22:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B158D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GHKkFYCB
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ab432273c5so32609337b3.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 14:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659860; x=1794264660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
        b=GHKkFYCB4k8jL4IHRkTJB0xSh7DOXuGdr8+0E21B3q55fBwTCRffY9ABMbz/ZtAygv
         pF7G9JIz2olWBg5BqxJ7B7bfDLgBFmf5lU1Xcz0tFoQ/sEVklvlI+Pk+X46odywdzhN2
         CEVkk+29V0w2qbQZpX1PNY2X/zeri6bGG9zQzPqcOqXjU3rldy75hYN0ci29FNpDGwIO
         Ziqr/+IDR9E1wbc+wWO4LVyYSkC4K+wy07LpJq+pYLlL3ewxtqjCtiLUV2ngGfFd7DfD
         vhfje4+GuKMaAYpaodyrqMnbsWbJ2HQG2jtw6U54srXBw6AHpgxcyEGy7DvQbJaBmAFy
         ARWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659860; x=1794264660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EN7S1V6hsPYuJ8/hHPqk/DKDGgJqqDJKvPrCgDVd4b8=;
        b=kBS3sBgwT8SZsdnNtJS0z0xbDQR72Te/8K7QmnDDAq+XtnomVcb/WdFl9eLzfnuq9a
         9I+q8xALiM8/bfTj8QUGpQsAc+jS1qAhkpQL09gDsRi6MppEwZb5Olmz4J4vp37sUnTZ
         UobXXawiKzX9bG8TvDzzf6HzwSFlOrNXnU4S51oemFvjuGlpSJ+Wyu0iHKec5DVfd+86
         UU8nuNbt6pwgbBKPn7QJKWYKwhARvDh52WqBZzdBACjWtbxBKhvLtEccE1oKOwZDqp8s
         GvSk9DUqOieqtRwooHFrKNEIZutSdnm2Tyc4PLtSGS1hO8V96E6pQqhbO4LW8ooqUu1n
         Epbg==
X-Forwarded-Encrypted: i=1; AKwUvBynlQJVu/kkimrNPamlB4xRSzz/nbI+ISvrNilpCbNiLUVzlD+c/bCv3kuLaGYVQSmLzoo9dNTH@vger.kernel.org
X-Gm-Message-State: APuU4Z+cb4wnEPnwwrx+yQaUgti26C6ieiTVc5XZUB5AH08MhHjZK1CS
	8Fmfo3Ywwnd9ceno4iTl7azE3Rsu2o5noa0w1aYGLOZUc/E0oWy23xjX
X-Gm-Gg: AYBFou1klhgKkUTwOySN4imwAkPsU85LBbJvt9hZyCN4zLYtj6+iBmsFI4Bayuk3977
	q/YBonrmSruQJwd3xqqlEwgiT+YxWllaSOXizGj+qz56urQ/Wh+Bc6NkLRlz4gXh+C9Vw9Wwoka
	/tjbe6DoCL5j91pJS8+J79Tk90n6+0UAEu5hR/Kd9oEDxJsB2iC7oSJk7By9MQDHreci9cNAR2U
	Y4SWAnZeljGXRmAMHqPJsvVcBHMlMQ1R5Z2q257AOaqDxFOMWc+MEhQkjysAjcukFg1eIPBbaUW
	1xVPX0ZFnHfXlGC3jBQTtc07FTNZxvHd7Xdplr4Pd5l/BUQjgNCApYSs6uFdshnsn0exavWLqsp
	n7xdHIpkLtmuBNzq0oOvfsWKziPToZCX+UIwVaSc4DnyKBuIUq5IM53Y3kFQi/8bq3Xqll9Bz71
	o2Zbm+MO2q5TZRYIKRCiUHRABBF5VSImbxZFMTwE8hSXSh9hBrb1l+272W6MDUnXub2cBSSSHi7
	e42E4yQF8Hmn0SHorVUntYfDjOFEGVJxQ63ZKdS1R8xcdoqU+Q3dqXYW1d6imXmj47jFolbjDXk
	VvMhw0t5S9+WskXtGtO3/gG8bwKJfX0c8bCbUppdkG49VX2qD8spSipR7Gx0vsv8raLD7gcrFnE
	LN6WmHQ==
X-Received: by 2002:a05:690c:dd5:b0:8b1:7072:a61b with SMTP id 00721157ae682-8b2b67323c3mr92119087b3.22.1793659859510;
        Mon, 02 Nov 2026 14:50:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b714bdafsm61225847b3.19.2026.11.02.14.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:50:58 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  2 Nov 2026 14:50:28 -0800
Message-ID: <20261102225030.2743129-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
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

zswap_shrinker_count() scales the number of freeable entries on a
memcg's zswap LRU by the memcg's compression ratio. That compression
ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
stats.

However, for the root memcg, the zswap entries owned by the root memcg
itself are never accounted for in the stats (obj_cgroup_charge_zswap()
skips the root objcg, and before the root memcg had an objcg, its
entries weren't charged at all). The stats only reflect the entries
owned by the root memcg's descendants. When the root memcg's descendants
have no zswap entries (eg when the whole workload runs in the root
cgroup), the shrinker reports nothing to reclaim for the root memcg, and
its zswap entries are never written back by the shrinker. When its
descendants do have entries, the root memcg's entries are scaled by the
descendants' compression ratio instead of a ratio that includes them.

Fix this by using the zswap pool-wide counters for the root memcg
instead. The zswap pool-wide counters cover every zswap entry, including
those owned by the root memcg.

This also gets rid of having to flush the root memcg's stats, which
flushes every cgroup in the system.

In a VM running a reclaim-heavy workload in the root cgroup with the
zswap shrinker enabled, the shrinker wrote back no pages before this
change (zswpwb stayed at 0) and 1016 pages with it.

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37d217860a6b..c11cd2a6e24e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1332,9 +1332,12 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 * runtime-disabled: we can get sc->memcg == NULL, which is ok
 	 * for the lruvec, but not for memcg_page_state().
 	 *
-	 * Without memcg, use the zswap pool-wide metrics.
+	 * Without memcg, or for the root memcg, use the zswap pool-wide
+	 * metrics. The root memcg's stats don't count the entries it owns
+	 * itself (obj_cgroup_charge_zswap() skips the root objcg), whereas the
+	 * pool-wide metrics cover every entry and don't need a flush.
 	 */
-	if (!mem_cgroup_disabled()) {
+	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg)) {
 		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
-- 
2.52.0


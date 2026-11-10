Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275633;
	b=OAwt0TQbCu3UHKZyba5qLiCBbPBMOAn24qAzFipgczgteovTXke3bA0N624Dfrz+rGPT
	 /IIxTU0Fb2qOYxNa7qNGqewr6spOK/6hYR0eUl9aiA+I4EGzQjnvRLAFPlye03Wu3rEX+
	 uDCz75zOpaQdZb8QRQ/VqWMkKp0L2699E7zKMmJeqQLg/WogWoDgQ7ZDvI3SLb6bfZciU
	 j6voQRqZQvcP6fhZy7bD9iWVmp6dXXa0mFogkwzKa8FyQbECWPo6fo8bh2YebRTwlCUEn
	 hnPIpg0wPEP2D1teWQq9sWk/0tbUQL+P52vzX7UbwKqf9g8De0EMmb4ViWb6jiA7rew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
	b=F8oELyHEK2ZxZhSpHcil8dIOwcxMP8a7sfDae8UIdQxhsaaJmDWXVqHteMAlk7gcnuQ1
	 gM5ndvQFj2kvE8npPIkc6BoEWTaY0wlUMkjbJKx0iipoxWcJIW2nTodKbXBPZ2IqAmp9v
	 aPuBlB5LYaVd3bcr7LqSFbaugq2b35kGCFgQxcR22WQCehmcXKVmQf1Oi23iVjV+OnxZq
	 Ra61aopITtt7wz1SBOK2XyyE2+MTKZo6lbhS0UlFvUnOA8RZn2CYYSEBeqGoVL3C0BjLO
	 Mp4A/LluQPfOjLlBt3+XG3QtzwFuJKclawUjEMaboTdjY9es8Q4dQ6z4XJLTzbS/gUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MMp2czio;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2DF606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 01:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A2DF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MMp2czio
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso779471a91.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 17:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275632; x=1794880432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
        b=MMp2czio1mmyfW+X12s/9F6SDx2pMsmwmKbM9lxHPqf7gN7fhk8oRj6xezaeMgZXCU
         sZnhN6H7fADhJmckvQAwIFmzLBndOBkeyGafXCDpknLgqtquG2Ja3mrHxIUQ0wqIeeW2
         2mqu69NKZa30KDGZqhR3oWguOgFKVjgKc+eNovkHIuXx/Kd47oi1vS/hLVu+DvGCQh9F
         DBcAFIUDV6fS+au6kQ1VaaRghR8Djn9ryMFzMt/vyxObX6sWD8KxaEHUa2FWc8jj4cYy
         jtpFchFXroEL1Jwi0LhlByIuS/FpBd/X2Y1L7y7AeDBOOy9Zt0VXNc4BeX72lSHfTESS
         LuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275632; x=1794880432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GdLDSDC+vsdZUjVsXlUGs2pDDNs9Duz5UHyhjDf0AK8=;
        b=oACdHwQqpCqWKrpTgtCpxzYl8tXKG3tvScKClCgmDee/hkI68uNMp0LRefat1j06CR
         QiMWnimRdIDlZioE1qBlS8pZAydl/sJb6neICZlSfIka001PWUITZoNTbn1L8h3Ne45G
         VcmQRYVAZBsMNMdL8J0Su4wHNjXi8ph8943Chv9K93dO1EQQplKLq//E8nHXb7CC/vBC
         TgkViQfKcCa7aVuXdudYoE7qQx2F91PnE6Zz3myScD9oLtfgg9yCfe++OpfF3PKJq/t/
         BoWsp8Uzd8ntkKpHtWoE/cTwdT3jGeDIXIFiLwJFEJ2VN7fBvh3AH0S6r+lltlt5IgA5
         wrDA==
X-Forwarded-Encrypted: i=1; AL+hErG9nUjFqbONeB7KrvDyiM0buB3zdPcf6A2wE4VnANTlN9rerTAoP5rWen1xd+spH63yK14LvyXU@vger.kernel.org
X-Gm-Message-State: APuU4Z9KefAiwHSCixWnbgFbIMPjMyRspmDexJE7pVJaTgHeOiSLtym6
	ZUQVp+TFFSmtbfFaS5DP+viJVoENqwssNIcBrDiCh0bBQ9RTrXaKUfqy
X-Gm-Gg: AYBFou18wVNrOsaIN/6SFV4mmAHCFHRUnKjsKsRlrkZF1rThaIgKVOTZUXUM0JFLpdW
	w+vxhHlHnGPwaBy9UY3oYj7gVb/CYq7y4wbT83emcq1rNIRjsvBCoqqX2MPMqOdElnQF0IifBOD
	4Idx1oYwg97+wDkDM7JSbtLj6HR9zYSo1dvOKBEH95gzxuW8eZX1OXec443JtqA+qxylG9kAik9
	CtslsDMVYbA/5Wv/yWHt9CpUDnD62DQ+DlN9yEe8YI9oeQEpkTdpnRiSGzp3uKaZ81D6AUoC6nF
	XxDIY4ZmXeWgQq+c89SJ9GTwm8rr9051ZZFdLub63RkHcpHJShh+ezeispG6aF36wN6GT/dnI1m
	yafoxyRQ9SQ2Q//6Nx4YehRWjTag+IQFibVF2LPAGvsMacH7bJkeY30XzcB6KlokooYTOr2VYA7
	tjwW1MYAtszs+SPu+nqZzAKzvOl90fdcLRdnrqeodZgODWDgTE7lF6kc7OxOdyVv7Dm1MKP1tL7
	9fOq22145RC5Z7VO0pO9IBYCNGqAkcFF9exRn0c7+UsiqT7953BTQMn4BPHvVr5AtJLlVi4PUwX
	1gBH/KjQcHcZkwMQ2Nxox9sbnhHN1DrNOSlyyxFEvhUHq9yEDVSVc5mh6tOh18kj9F6WfjWj67s
	X8sNRfQ==
X-Received: by 2002:a17:90a:ec83:b0:3a7:b260:9ced with SMTP id 98e67ed59e1d1-3b166cecc28mr1377225a91.58.1794275631979;
        Mon, 09 Nov 2026 17:53:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b167970669sm1564096a91.13.2026.11.09.17.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:51 -0800 (PST)
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
Subject: [PATCH v2 1/4] mm: zswap: fix shrinker count for the root memcg
Date: Mon,  9 Nov 2026 17:53:18 -0800
Message-ID: <20261110015321.611093-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
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
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
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


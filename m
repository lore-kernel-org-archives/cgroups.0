Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616197;
	b=PvNqW/EuqdRLU9blBJZ8lCvCiellnDL4ArL9jpufk6iL6bEn5SHZpF+jI9U+URPXvEFE
	 e/azCVQVc6pi5n5BLxtS9x9xexT0wlYEkyNNtwRBZrCk3ROal/vtHpDmYu5RNn/10WHDj
	 qRh0WigLmTpPVQ6jaWqgLpHCl71pD87pXWpPPZrsL+B6f5fSwzQO3H/Av+U2vsqdJn94Q
	 fCDkmm9P50tearrQ7ff4+Q9smv03T3YZVpn1O7AA014V+pHWY2pxTuU4DPCGd+oMrBbo8
	 jZIiZLdq7+pH9kXbZ5l0+vzTZEPG181j8+Zrla5/Wx71RMdr8ciWf1lRZfHzAO1TN4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
	b=bRU9GUINeaenSMoQVXRSaekjooEwvZUVXkKRfwXah4WX/6cgvO3nobIUBF65eOUCQ2L/
	 9zcvb5eV19YaJbSFVw7i0TescAMIbxfFdc4YiCTr/8D+yt4tJiKpHJqpRlTFJW79Uqy4O
	 LrbtUSxfrfPGd1EVnlcLMa3eV/8FiHUC2hiCZlatiVD5gPTDTy/jriEg1pKlwkR1eQsL0
	 ymirvpBqZGmvAE3PXcT7QSIHWFCRXEe7Ujv3bDjBRAbTGZ/jmK7f3IBodnMXOGzmEDhJC
	 S5KyxrKUyE+bGx0DHbh0aRdr2WRoj5pEc79ayM/qjaw+RWNg9f9YTXvOh2KPXmzMS1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vWgmT+v3;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E525606A332
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 00:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E525606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vWgmT+v3
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b336de3d38so11866137b3.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616195; x=1795220995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
        b=vWgmT+v34TE5L9ctDX5RHlA8LCzVzRsCESBN5Syg2LzyFveXezd76NbCvfo9tMQI8l
         63B9UmZs+vrp4RW6fSfq2pKN93HPcjVqfRETrjW74bs3I9b75tQipkLCdSK2O3ZF5OTw
         Oay6/5JwSavgYprxlAg5GkL+5RrfaVQkRpKPnNPKFWzuxfrABmsmoHR8WxH6KUK1Ru7Q
         BruMXYQqt122YlqpAivCL4t0LuLeWmX0bxxbIAPDC6hJzgGYe4SJ+KG8V2fficzMQHSi
         454jtw52W2Aw1eUujQnMlGeSeF0/QFE7G3c21Hthf33umMr/TUUDpIqKso50ohgpoyLG
         rZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616195; x=1795220995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5FJmlfLnnVicFf7gaLIa4+dhDlQzv/f7mdEhi2RvUz0=;
        b=QwKWEwfFhQuK+L2LPfU+ZQQHFzm/pW5+zCkv528kE/bod3xTe1QgU8LkxuxZvIpBnq
         oz77yodE3Py8woxZbj1JnV60YJD3AsDFJowKtpB6inlvLFDWRbGDGV6bKSJVlHDytM7U
         lkCqzw09pvb6T6z7JegxGfl+LTtCHtzlMnc+kg1LYVhS2iu6FuvZfr9KcK8UHe7jNPR8
         KcFiUwfTxft9MO/YP0WZ1mPzYl4oRbsXam8pfRh0FWsm+nJwGPAlymbgQJj/WngFyCR1
         BCDUV+Np+EKIFh4UW/R3VZdBulzxgwfFxb8UjVkFqycBhdpWUZU9RylgSowbpahH8Pkw
         oX+Q==
X-Forwarded-Encrypted: i=1; AL+hErGZBtt/Ww5V4lgOJtQmHs4WHZpkmJOKBVU0VHJ5OjPzeklBtIvq1qmznOO8UbqzoYM6Xc43BThG@vger.kernel.org
X-Gm-Message-State: APuU4Z8IXaEcyiGtnUx6NYOfSPfkM0o5Wim7MLfJ+r8DVQPQzbqsHxtZ
	bBRXf8gH6tn/nRs1mloIjgWDdKYZHArUOzvq8pXVJ8ml7Aa4jnUueYU8
X-Gm-Gg: AYBFou2EUPpyKvy93MF//Q2Qdxj0/zXo5qAertuhJ4HkERiT8ZygHzvOYg4pDdIShDz
	PkD8mlphyKaZ2AREZyHYHuXkTt0E2JJBJOdqPYosG9ECplOYrACzczwK9v0wIZr6gS0Mj5U8FK0
	vhgwNrsvGklRFmODhUIGNqzE5VrXCTaHO64963qg+tYmtKQbyNAGkMymCq4dMBIRM8BQOYZ7BjU
	oYX/s9g9prp/B3MHyOxDwQtUqsL6JsqlE2BUhoE5ZyY2YJrNmLkwsLxnyfDW83WNMnxli8/ZmA1
	IOckjG7WMfHiWjBVRZzyk2FDQtWyoC3z+bDXjfZtXx9F1AjdE6Pl8bIItfmaibChJAMj/pkU37t
	dP1/fpjs1a6T4pnduuUHOfCRL6o3QX/vqfyiTpAFEftepYPwWZq+l3HGpjISNdcGgC378xu2IjS
	vr3zdg7DIgTC06roEnAGxemhiVepSf2UYsNPEN/CXjCBtKko7H2KFFLf8h7kvlz2nw3kH1KILf3
	VxiSi/ka0AzeZw2rSLD8ZQJpax3GZeQrU3ZLOWDIIUcoNeFOQQ498I1wZKQGkM9l14l8vc/dCW4
	NDlp56ep8bcjQ8/JadczqkG+vlAPIeR7FXiTstOiifp1qyVhvr+RbSF5gs7L3oCLipf3/5ibHMC
	gSA4EVg==
X-Received: by 2002:a05:690c:3181:b0:8ae:1acc:ad33 with SMTP id 00721157ae682-8b4aa305fd1mr20901977b3.58.1794616195554;
        Fri, 13 Nov 2026 16:29:55 -0800 (PST)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa958d0asm33763867b3.22.2026.11.13.16.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:54 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 1/4] mm: zswap: fix shrinker count for the root memcg
Date: Fri, 13 Nov 2026 16:28:19 -0800
Message-ID: <20261114002822.1043378-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
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
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index a2e0314db1cf..6e1cd3e482f7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1330,9 +1330,12 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
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
2.52.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616199;
	b=03ItLZyZ9auplDpUDYeQLRfb6v7CaVvvNzsa+SwC0H3D7lD0/bQr1+dognd7qsJPHaHH
	 yW23SzG93gbpnHpj82955aYlTRtNZZUF/BNhGO+NHyMCpF6OJ0c2g9gOJR5LoM4es11Re
	 imcbdoZdwp9skjshCFc42IsPB7qSzxb+BHCM+o7EL3N4PaXKDIUP7dOu6ST7h2GGSvhD2
	 E5detp646k7G7Jyg93pEPH8GlnWnZ4NsMmC5DB8Sh6OFDNaWUiy2Jty5TyBb1XAicwFIe
	 MKUQ7wl52j/ktr9kc1Qu+H+SdziV0lwbrGL8BMUUC+tG5u1gUc+O1z++to0JYdyItoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616199;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
	b=i9t+cbRP0nNYjSypZmL84TQGXE/V3xZhfSpFO4WvD7oN/RtAZ9GcVAwFwnwm1v3HKjsX
	 2wLzENst3eYZmWY8dqPJzfhB2IPYDovOszvhkzSYdbrqM3md0Ua3u0/FzQY2UE3tJ2AmC
	 fQWssws/YZgagbSpM01MlQtEWMTuN64xDsbWQwEhyxxhRgGyKlX45jxXNWN0ZwxXmjjnA
	 UKE36rZSD/D2iw0j6kwKDhd1TTlKg94vssDAOKcF1mAsVPAHQjvVqd9xIyqO3OLZF86Nu
	 RsTBb1I/MMAhFExifErDT5edZMB8kKnKj1FSIsIm8Me0K+nfkF/5mNguy7fXtfNPK4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jsurt91e;
	arc=none smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D2606A327
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 00:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B9D2606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jsurt91e
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6767d92cde6so1721252d50.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616198; x=1795220998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
        b=Jsurt91eFpuHGvtpenq/0wyhLtSFYNPZaL0adjNjuohRpjBhClAE/FvwnZ+4x6EDyH
         htKhsADDA07w2/4uvxO2M9Mmy2IqNkw47po9JKGQj9lfPijGMPQVyd+mW04RL8Cw2v6j
         a6EwlUeE0L8lFNNt1k7JZFop1z4I1gTS6DuVhVljnSxl4kKNjhBqjC194DsQuX98Szwf
         Y5oRVCmfgxMm5J8f1DtYTNlrfVkVf29STTROJoE65qsknng/tK/YXt1DZ9aIHAbrhpN5
         HKuXJ6yFHPukwQQLOo/8Eb6a5TXJaKCIiYeIr9NbciVM/2bFeO6UOlRTctoi5ND0vonq
         JgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616198; x=1795220998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJgQdHN5NLYxxbOCpexwWsSr9IBzYZ+JufSPNjQMV9s=;
        b=NUfCxMRGZ5+zYXW36bkp3F1tWeKEIc6dlakUjloq9Tv9KVkQsNr3TYlKJkKSjwVrA9
         wN37VPL98J4vqvLGyvEEjzXsyX0UF3XdXxaU0cQpk2YFO6+sOkSgxCaqqIzHswiNedeE
         kyGbLCwGRVUUWyehteX/o7/kpxvDyWlwuA1cOmBKhLjBPHkY9ipMnRuVebhovXXhKn9E
         tLun18o7CVcbiG+pZfs9C5LchKOzZAi6rsuyWtwmRc84XBODKgdOvgFwf2NzZUEMSlGc
         N7gHGUlBnHyKm+zH6q/u0fkNsgwliEXHN/f6pKDD2YZJIeN6OjM2VH6E1jl5RAG8RqFX
         LbSw==
X-Forwarded-Encrypted: i=1; AL+hErF2c3Mn7oznJEjcYaQbUaCuhJfvZHPxlyhdVNI1GnGK8ttNL0jXW3ZhcdBt+9ejJYO9HMxMMk9U@vger.kernel.org
X-Gm-Message-State: APuU4Z9qE0kBVCTqbbo2hy0hNcMG1wjaI62g2bGNGTTD25Ql9d08Fk1W
	XUwvtdjy/dyGS63Gmi77XgOa2ebDApi4Q4LBt7DWb/639hvzj3yBbcF4
X-Gm-Gg: AYBFou3ggutLhk+xNkZSSGnSQH0DU4g96fz4bP/lxSaPdr7K/j1QM2Hr/FW61wwgnGx
	bB9bJOPtC/BaycIzVcnTOs4cqXFV5Fwk8jtBkxcJqdPOcv5QuFBao4S65ShJbiGKAYT/1ogWY9b
	ze+cCSKdt2qhC1/+7EPCMgAqhnQ5Fb0CKoVLAuWLvUYmYOB4vGiImzFH5nBLO5iHF1/KSyjj19X
	mRMbHhcq+6FcThF1j8R3myOlXUDqHhEXFG9EjW1vBtENWkKM7LOXjgu5c7vYuYJ8T6WzRkQ/aSl
	ze1HWngKXYAPFiMMgnl6gTO/fO8doO/DdrQCYqXwVJw15viEXDvf5QDXwFCX3592yMO0qDPTudk
	cAIhiFq51Tq1KYETGf74ilE1WgdTOxh/aU/WZRWMUnVg11pW7pinDZDoRlHbYVJtcQsXP1aw8x4
	7pbFjNr+LqoXdBAooy3SDVCsUK6RLJuOKtekMR923VBk6jJsdsX27xjZ3x2FgprPff7VMMvLMYm
	LlJljVk9vDFaVwvcqY0sEu0z8AdcR8jPVEfrXn99A3LmrPy5MJ42NWw+puO7V3h+eTwaAs5ejS0
	wxPmHLBeS6MKinylN5C5Vi0GGNweWtl4smkx4cGQfOc0f6B7D1DaEJHZsrqNqyrDTt71cbWqxQY
	8X/NF/Q==
X-Received: by 2002:a05:690e:144d:b0:67c:1fba:b42c with SMTP id 956f58d0204a3-67d896508efmr2961856d50.45.1794616197983;
        Fri, 13 Nov 2026 16:29:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a555cf0sm3448893d50.5.2026.11.13.16.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:57 -0800 (PST)
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
Subject: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node counters
Date: Fri, 13 Nov 2026 16:28:20 -0800
Message-ID: <20261114002822.1043378-3-joannelkoong@gmail.com>
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

For the root memcg, lruvec_page_state() returns the rstat value, which
needs a flush to be up to date. Flushing the root memcg is expensive, as
it flushes every memcg in the system.

Most memcg node stats only track memory charged to a memcg, so the root
memcg's hierarchical value equals the node counter, which is always up
to date and doesn't need a flush. For those stats, have
lruvec_page_state() and lruvec_page_state_monotonic() read the node
counter for the root memcg, as they already do when memcg is disabled.
Callers that only read the root memcg's own lruvec then no longer need
to flush it, which the following patches take advantage of. It also
makes the root memcg's stats more accurate, as callers that ratelimit
the flush can otherwise read values that are seconds old.

The exceptions are the kernel memory stats (slab, kernel stack, page
tables, secondary page tables and vmalloc), hugetlb, and
WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
objects). Their node counters also count memory that isn't charged to a
memcg, which falls into two categories:

a) the allocation isn't accounted to any memcg (eg kernel page tables,
   or hugetlb when hugetlb accounting is off)
b) the allocation is accounted, but it comes from a task running in the
   root cgroup, and the root memcg isn't charged for it

As such, these stats still need to read the rstat value, since the node
counter value can be higher than the rstat value.

One user-visible change is that the root memcg's memory.numa_stat (and
the hierarchical_* entries of the cgroup v1 memory.numa_stat) now
reports the node counters for the non-excluded stats, as it reads
lruvec_page_state(). This is more accurate, but as a result, it may not
exactly match the root memcg's memory.stat, which still reads the rstat
values.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..196c0382181b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -504,13 +504,67 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
+/*
+ * Whether to read the node counter for @idx instead of @lruvec's rstat value.
+ * This is only done for the root memcg for stats where every update also
+ * updates a memcg's stats, so the root memcg's hierarchical value equals the
+ * node counter. The node counter is preferred since it is always up to date,
+ * and avoids an rstat flush which for the root memcg flushes every cgroup in
+ * the system.
+ */
+static bool lruvec_use_node_stat(const struct lruvec *lruvec,
+				 enum node_stat_item idx)
+{
+	if (!mem_cgroup_is_root(lruvec_memcg(lruvec)))
+		return false;
+
+	switch (idx) {
+	case NR_INACTIVE_ANON:
+	case NR_ACTIVE_ANON:
+	case NR_INACTIVE_FILE:
+	case NR_ACTIVE_FILE:
+	case NR_UNEVICTABLE:
+	case WORKINGSET_REFAULT_ANON:
+	case WORKINGSET_REFAULT_FILE:
+	case WORKINGSET_ACTIVATE_ANON:
+	case WORKINGSET_ACTIVATE_FILE:
+	case WORKINGSET_RESTORE_ANON:
+	case WORKINGSET_RESTORE_FILE:
+#ifdef CONFIG_NUMA_BALANCING
+	case PGPROMOTE_SUCCESS:
+#endif
+	case PGDEMOTE_KSWAPD:
+	case PGDEMOTE_DIRECT:
+	case PGDEMOTE_KHUGEPAGED:
+	case PGDEMOTE_PROACTIVE:
+	case PGSTEAL_KSWAPD:
+	case PGSTEAL_DIRECT:
+	case PGSTEAL_KHUGEPAGED:
+	case PGSTEAL_PROACTIVE:
+	case PGSTEAL_ANON:
+	case PGSTEAL_FILE:
+	case PGSCAN_KSWAPD:
+	case PGSCAN_DIRECT:
+	case PGSCAN_KHUGEPAGED:
+	case PGSCAN_PROACTIVE:
+	case PGSCAN_ANON:
+	case PGSCAN_FILE:
+	case PGROTATE_ANON:
+	case PGROTATE_FILE:
+	case PGREFILL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
@@ -551,7 +605,7 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	const struct mem_cgroup_per_node *pn;
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || lruvec_use_node_stat(lruvec, idx))
 		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 
 	i = memcg_stats_index(idx);
-- 
2.52.1


Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCF631987D
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372517; cv=none; b=uLK97/Re+IeqYsvOr23p7lb+EHZC4qrwa7iqhidNZxR5tNZ1SwKIz14j2LXkVBtxJLU/ObhhIBTimcSz0EvFLFhsjzxjb6gzwvEYrIwWJQGBRUqoxRaVHvCnOHH0KF3BWsUaVR9rpCGmMxz/ZPnUw+0Gm1AhIAx7WwZoAwedLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372517; c=relaxed/simple;
	bh=M+aWo1bNUtBXa0iJw7BepeuHkg009I7RgHNhk2kwzaY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFi/tf9nw86yz+3LweTnzhoBMuTjfJDTadW6gucymI53+KCjsYUhYd7RCEf4pCSabA4ZqAR59Ig9AX80JxURWSJEV2J6gY7Wt4B/b73QLOXMb+p0cCilv4DfPm457FvwjHcmx7sFLnSwqEV7ZdyyxFTSbuTVV8tCW31wxH/S6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=fTsz+K4X; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="fTsz+K4X"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5eac4855401so220881e0c.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372509; x=1792977309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k1COhzPK8MoPAOVKkuVJ9yCDV5Zgubw3w5lCCc8/uFo=;
        b=fTsz+K4XducjfO7G+pZhB/SL2ERmh3XE4pfeRNFWG6xTg8k79ifTJqE289ttmIrtRu
         cDTCYD84Wk2FDWGEElm7QlNZIov/wl81MoQGpfM3xElM3Z6RrITyksu/62fxzSh3Z5zA
         AYrG6k3TVSc+HGck0L60aWCEB1JsFuYo+hSCr6OsDj4X5Dn6ovLWZxuXQuLlHOHgVr2y
         J3hSE5EvE27bjYJGExvcsEVEwGt2QGarC+fRrDfUvVc8gexKrAYhYrM7GPs06/3PRT3a
         SvLHCMZdjdEBeWhMTWxUI7RmA7TwbTIe2am3infO1dDiYFGZmJnHMei2wHBKX7LYy6N8
         oyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372509; x=1792977309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k1COhzPK8MoPAOVKkuVJ9yCDV5Zgubw3w5lCCc8/uFo=;
        b=r8oW3RwmsemV9KZs16hPDQUddOlkL60qsZLiWj0KeVuk+24U7m7GzKKcbzY5Bzpez3
         nVRbR5tdxLQOa8LgF7O0K1u1tZgty0gWjz7zAgagfjtpqwahwbauxLQ8RYzrOXPACvz5
         YqNc5R96L+LjQBVaWppwWFuDLut9tEeeYUIQ8grVfJ+DlraCMUel8XHHvzGnGDMPAMde
         S9jcXFWEh2Og50176D7aC0vdLIhXPMgevHbWf5Fdl/bpURmcPShEZaSaZAKY6QZIAa8l
         yrKaw1LMWPtrnO4BwuCQc0iIqXJ5IVBU6oda9wmiIOq95spVjs3Z6bVvO8bb4M+Yozs+
         iHqQ==
X-Forwarded-Encrypted: i=1; AKwUvBzW3F/FWZFM3WZYpE+WH0v4jjHBrH+2Qr7qrEjx+WeGbpRiPKA3kAzlB6Q3/DD8z1CrAlfVgPdO@vger.kernel.org
X-Gm-Message-State: AFq9FYJUNyr9pQkSiROOYfozGRltgF7QXbQi+ceMp5XPA+SsWmk9x63S
	p6ww5QVKuWHCBc0UKP5lewutf1MRvMFMm0GEKfQbBDMTcsAQsl5SILNqaQqeSqMRT04=
X-Gm-Gg: AYBFou0ruwEowwVYd4+uL5gj5Y5U7cuA3tp1yeP5A9b3nmHraWOKccueQHnAgdhEMJG
	4wRflLFfnfCmp4ocVuwILURoVkEre2gRnvC6BbXg+MCwHrInw5f3EKjw9jeAn+sr4OvatEz86lX
	06SuJjEWAOrTIBNBk6PAfX8X/TPgb0Bh8FURIqcnHWlAs51G5ro8sL++vDRDHDiTUahG5iWr/O8
	N+Ya7zueZbFbbCY7WDxwlaTQQdp+2oXc1h65Qri82caI0i7HZZVQY1Pl67MJRZAdUscS+k1ylWT
	nAATi/dblwBIDtiQG8ZJMQda8+76/1q7dZIrCrLGTrRwxrd8ZT3nHvFz0tb5kmxp0ZHQsG/fnDK
	qizyebULK0Mhq6zVZ6bkbGxXopFSPiCEVr5nxUjcGmgZTjdFP/eXHChpS1eanzq3VtpfJQMZl2w
	4qhgdE/oy3/9jz6jOMiBq9GbxiZ/aGtjeNJzFyTRVNwKlqNY6gRIMENQlbwjI2WIe1U/ZNOfZkq
	HXNnVhV4ouIIAC5GrrZhyZP2oKcdZbZg4EIZn/v1zgdIfC/H9wW2Zt7JAmDeh67O9co7+LgW6zd
	9msEL1kz4ZT2QOUhMPPGUg/7rWgKfbw=
X-Received: by 2002:a05:6122:e14e:b0:5c8:46e3:ec57 with SMTP id 71dfb90a1353d-5eaaa0ba603mr2227545e0c.1.1792372508911;
        Sun, 18 Oct 2026 18:15:08 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:07 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 8/8] mm/vmstat: Avoid redundant per-CPU stat_threshold writes in refresh_zone_stat_thresholds()
Date: Sun, 18 Oct 2026 21:14:46 -0400
Message-ID: <20261019011446.834487-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During CPU hotplug, vmstat_cpu_online() and vmstat_cpu_dead() invoke
refresh_zone_stat_thresholds() on every CPU transition. Currently,
refresh_zone_stat_thresholds() first zeroes
per_cpu_nodestats->stat_threshold across all online CPUs and all online
nodes, and then unconditionally writes per_cpu_zonestats->stat_threshold
and per_cpu_nodestats->stat_threshold inside the zone loop for every
populated zone and every online CPU.

However, calculate_normal_threshold(zone) only changes when
fls(num_online_cpus()) changes (at powers of 2) and is clamped at 125
for large normal zones (>= 16 GB) once num_online_cpus() >= 64.
Unconditionally zeroing and rewriting every CPU's per-CPU stat_threshold
on every hotplug step repeatedly dirties remote per-CPU cachelines with
identical values (and briefly exposes stat_threshold == 0 on live CPUs).

Compute pgdat_threshold across each node's populated zones first, hoist
the per_cpu_nodestats->stat_threshold update out of the zone loop, and
only write stat_threshold when the value actually changes.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   3.37 s ->  3.09 s (-8.3%)
  Online:    2.06 s ->  1.98 s (-3.9%)
  Total:     5.43 s ->  5.07 s (-6.6%)
  refresh_zone_stat_thresholds() (cpu479 offline / online):
    1,158.9 us -> 135.3 us (-88.3%) / 1,468.2 us -> 128.6 us (-91.2%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   2.34 s ->  2.30 s (-1.7%)
  Online:    1.12 s ->  1.08 s (-3.6%)
  Total:     3.46 s ->  3.38 s (-2.3%)
  refresh_zone_stat_thresholds() (cpu511 offline / online):
    104.6 us -> 50.7 us (-51.6%) / 109.3 us -> 53.5 us (-51.1%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/vmstat.c | 58 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb..c671e9669b43 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -280,41 +280,45 @@ void refresh_zone_stat_thresholds(void)
 	int cpu;
 	int threshold;
 
-	/* Zero current pgdat thresholds */
 	for_each_online_pgdat(pgdat) {
-		for_each_online_cpu(cpu) {
-			per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold = 0;
-		}
-	}
+		int pgdat_threshold = 0;
 
-	for_each_populated_zone(zone) {
-		struct pglist_data *pgdat = zone->zone_pgdat;
-		unsigned long max_drift, tolerate_drift;
+		for (int z = 0; z < MAX_NR_ZONES; z++) {
+			unsigned long max_drift, tolerate_drift;
 
-		threshold = calculate_normal_threshold(zone);
+			zone = &pgdat->node_zones[z];
+			if (!populated_zone(zone))
+				continue;
 
-		for_each_online_cpu(cpu) {
-			int pgdat_threshold;
+			threshold = calculate_normal_threshold(zone);
+			/* Base nodestat threshold on the largest populated zone. */
+			pgdat_threshold = max(threshold, pgdat_threshold);
 
-			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold
-							= threshold;
+			for_each_online_cpu(cpu) {
+				s8 *pz = &per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold;
 
-			/* Base nodestat threshold on the largest populated zone. */
-			pgdat_threshold = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold;
-			per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold
-				= max(threshold, pgdat_threshold);
+				if (*pz != threshold)
+					*pz = threshold;
+			}
+
+			/*
+			 * Only set percpu_drift_mark if there is a danger that
+			 * NR_FREE_PAGES reports the low watermark is ok when in fact
+			 * the min watermark could be breached by an allocation
+			 */
+			tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
+			max_drift = num_online_cpus() * threshold;
+			if (max_drift > tolerate_drift)
+				zone->percpu_drift_mark = high_wmark_pages(zone) +
+						max_drift;
 		}
 
-		/*
-		 * Only set percpu_drift_mark if there is a danger that
-		 * NR_FREE_PAGES reports the low watermark is ok when in fact
-		 * the min watermark could be breached by an allocation
-		 */
-		tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
-		max_drift = num_online_cpus() * threshold;
-		if (max_drift > tolerate_drift)
-			zone->percpu_drift_mark = high_wmark_pages(zone) +
-					max_drift;
+		for_each_online_cpu(cpu) {
+			s8 *pn = &per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold;
+
+			if (*pn != pgdat_threshold)
+				*pn = pgdat_threshold;
+		}
 	}
 }
 
-- 
2.56.0.176.g3575e65682-goog


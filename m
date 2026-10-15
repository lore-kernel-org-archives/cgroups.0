Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8623B71AC
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078448; cv=none; b=mOwzHoFDDXOUAp1DrZMAfh+3LH/t2UaOSNb3imF75+Eqb11L0cDHYYv9kzWJ+TRrtZCeWZS3QM33uEUAQENbpYnKxDN20bGyR7+h/Bn5rUut3yqgxr9kSIbbxJ7C+dP39J0twjZj4JdE80YUP4G8qypZdpyZoFi58yr2dlvdXig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078448; c=relaxed/simple;
	bh=rpHWd7x4GPO1rBWYSWmWRVD+UwYDOxXOvGNDhCFJcSU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8yzi9INYxITmqGYDU33hnJW6PFcErwjRZaQVeeoWaf6p63tuma9x14LJ+oE7yLetN0nDOv85p7Ng2Oa3Mz62PRqWEDBkWeMYo9+zRuYtp7fmKltfgYe+iHYHyynFJ2BvD1e2Ert6478QtqlANYlkEGS04FSjk1IX9ywCtCwKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=FGaaKggm; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="FGaaKggm"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5e941201928so1086288e0c.0
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 08:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078427; x=1792683227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XxAI2LBfmW3xr29v/N2DJy+DieVEUynw79jHC0KaBOY=;
        b=FGaaKggmtfWY2qCEm8/CvUXJf2mXgzuIg7vRKkvmJlQTH6XETemz8Cd7FfvXss6x+y
         Yi57G1gxbknjcqEsfDPKRGdHmwzxS2Y5uh4J3AY2KlmGj8VaasuGe1+Cegpi7Rvsi8Io
         LsO98hX71TaehI+r3zaq8ISGmUnz+I8nvP6/hhNd/K7aERhaN+ure1tk8jegP2RtTvNK
         hOfRLJ/karCFb1WdLAS09fuUOzRsDK59rhE5XpkTiZLaw9z1rQD0C6Wz+uksjq+CuAFD
         iJ2Af4XeSSBHu3xYYVjSbQOxztlo6KSydyS5e8lpp5XXkUpmuwIlGZJF2EV9Z6MOhbFG
         X/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078427; x=1792683227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XxAI2LBfmW3xr29v/N2DJy+DieVEUynw79jHC0KaBOY=;
        b=UBYkrUv4aAjhhheD35vFDH0WfyJRUnAHrgtHjuRQlFwUqNyI1Z0R9nfFYsQZdSqdQM
         We2ovEXpW/qEKnohSW+9nq5AKNR9I+7r1lLMdB78epj8JeDqqjqWDnjhk/yXnbXo0RID
         ucnF1bJWsra/Dl7HI/Qz30T6llZM6tCWVYkguyk4P5M1jUlYZ8HlkNyyDWZ0Roh5RsFQ
         9ZxVE6P2B/A9GS8gFBRHd3aosWJav4kdKNFjVg5atTtk4XXolhpHTuUVgcNHQ65WYI8r
         9slVvPYF1OZspOpyA0EEbKwQsdVDgiCaglMLRcipd43uepm1QyK+GB+Z7W8ERMi6uMmR
         10QQ==
X-Forwarded-Encrypted: i=1; AKwUvBxpeAB4Fb7Un+fzYOioglUQEP+Ki3Ir7D+iP23eV7z34oWqK3wxO8e+PH8jaKnE06Puq0trpm3J@vger.kernel.org
X-Gm-Message-State: AFq9FYLfeQW692DbE/k7/vaHllWZORecJJrZGdCzMO9kU9vDxQ4CWHdn
	I06Fd86pWvSD/Czi8nmgibQ6QFx6gIJmPzymHjWUjKub0JYhekuwMncaMPO9Dm3HSmg=
X-Gm-Gg: AYBFou2r+uTzHNAPbCFE815w7YI7D6TyavICdqi64AXTOnnyIrHXmxpsKXbjFoN+hDc
	jAvc8IS01hDXV3ebNjaHlBb3ediuEpt1S2z0XttxzN9r2PS1GEJbViR074zrztvFUlMeQWskHWa
	dXFePl9L6kR7YCuLUQ+sqvHLKyVva2qUDmbgp70Rk4GNOZH+WUYCBbAGCmnNOoh9weDsSRtWeKy
	h+DpLqO8ISXyxKnZELwnOgfjRkB6AJySshvN6IAMRsb4jA5vBBo/Gqg64GGixIfiohuo4MKTMYP
	bNaPPKxW/CM9PKHqumzwtjgM5ph7GHdtZ0VlD6ylYQosatdTmfOKM0evaaiyO0kgEpEV4cMc5jQ
	qA49tBcioFpkUVgmmSX/QPJjZ1TUkmdkX5ENBX9g6lxi14oSysRskp2dKEr1sWMZMeRbrNdy8ff
	hDckfcsWy9HmfROI9UFbAKML84cTcywjMPo2TDoKok6/oc16JMTtrweh/coJkxsAVsHz5/qX7NW
	/e165vhzopBw5es2mwa8VDuW8qxC3IEexBLn8cENs3OyG0M6KJr+MqbhqBxzYoj827FE88LhU/f
	j7gAnpM+vXtVTR+JuLQ=
X-Received: by 2002:a05:6102:3f12:b0:7c3:b15:a981 with SMTP id ada2fe7eead31-7cc17cf0534mr339488137.15.1792078427302;
        Thu, 15 Oct 2026 08:33:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:46 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 8/8] mm/vmstat: Avoid redundant per-CPU stat_threshold writes in refresh_zone_stat_thresholds()
Date: Thu, 15 Oct 2026 11:33:31 -0400
Message-ID: <20261015153331.1872641-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
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
index cb57714539fb5..c671e9669b43b 100644
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
2.56.0.385.gd3acb90ef8-goog


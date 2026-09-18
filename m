Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8A519E16
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750584; cv=none; b=KUeHx9NqPV82opAc/zxbsaJTF+Lz8zaISgXoNI2Bk7d8NDRNKO3DPSr9l1H12xpVXP9A0yqMa4rqbjfZNPUSyCGtEydPxV/Hgfy2gF8YQ9TYJbhDaTVQr2UOlBPyVfgI/eiYTsc+LDHsvDBCBr/PcfEoj+DlqIGKEStbgyTGtSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750584; c=relaxed/simple;
	bh=H+ukdmwXP+tMkaQEpJ23doFZ9tvP/S4l/tdO9wntvVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKwcST69lqPsdwmxld8spYCBe3TIF8TabHGgVcpuAx43JLblxIta25QU+AUorC+ljK+aKWprdnIXmyui5LpBbLS2QNGZSrHDJ1k0KaaYugLNlahi91SFxd7tCaLMO3JwSrgtRy/CRIi9ZAioya0Ms2fxtmI9wqy4SUq1ZSxwPdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=don+vCZz; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="don+vCZz"
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddb44ad1c1so10264645ad.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789750581; x=1790355381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZ4B6fQ0OaE27qFChHjfflbajHqzh3JOUdhhP8Vrl9E=;
        b=don+vCZzE4jWR0Cuyc8swx8r/1ZzCoKa2h3pQqwyut2J8K/74Lyj7Y5mHNqNwF8O3/
         E2yJjdTyKEMfbWukcSXwsMAYuk3zhHQI90EHwCcS7Xmp8pr2WQr9uuMjb4S1UwmXJDK/
         HY/ceq1fhT5FTqzEhP1B9YlqqGMNOmrRRrbsDUMkNA9yt5Ofw7Z1sXKhJLKa91mejKn6
         DxoAgp8bgdq4XLEqzPCR/DYXV4q0OJnM/VFdarKiY6dWs5tbZowRiiwkMNHWr9wpZD32
         3LcUbVEUwqU6nEIr2AUBKs5KO7BOIQapGv34UlZbTTgllgtdgOs8ZJdKD9GIYRsKDRbj
         JLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750581; x=1790355381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZ4B6fQ0OaE27qFChHjfflbajHqzh3JOUdhhP8Vrl9E=;
        b=iBggr+IwkgMHEUyxTCZa/nqKh7zEjgYYOq4jF7XUerpVLwrTKS0wbh/WlvKfBOLBTj
         /dT+g/QDgS0fCGx0j2J60L2M7xVNCdz++9jVeGL1onnXRaQlLV8pA4VY9Vor93NTXgZq
         Uw2IUf5z4XXHjVqoEYjI4+MNc7Ma6Ae95D2HOpQtzLLZuYfgjLIbGTrMoNgfF2SM8NHi
         ivVj9KXT/nFunV8qSv4rwkccQFtz1kRZP33YZkfiaeCnMc0RBpcnhPUV0SmNaxpWqVon
         ScKNlVdotRIisCPuvxZc70i56YXOVcd0e+16/YkVuZ7TkPEFcEa+3Fb2GHA4+OsZWhhc
         2gPw==
X-Gm-Message-State: AFuF++nHAT732eSW+N/nBfWEvkZfr1XcNslrmPy/KPlDeY7owtpSJ+ba
	CG5UKdzJXyfnOTwqQzyrP78LBxfY8t7wBA8ZEh2NIykq24w6Gw8A+jx/
X-Gm-Gg: AYBFou1C1vMoEqmL1Yvxw77k3y3EnJKcSGSm0seFLNEchM/CTvgomuKiXOMYC4FmZge
	3jmcF8TjPZeXlGnqbe+WlcW6SsHO07pMx9bmLkFMx+HTaIcQCVB+SGdc/sNyPGmwVTjA0Vjtqmd
	0PLF0kft8N99r7l9dTUbfAiptcfFkk8P1GONE5LetPXuhESAgpG3n+0Mue384xKQ4cTE9b8BzKV
	dX+h+xc5T1lnUFG8c1845vhYwQuxB77D5jJgwdDN1jNOL+PXyb/KbwKt5F4h2nZ2h7y4AT9NpaN
	cuiIImYJoSWYAkinbE1UUt+SljSnjyZU1hdBdDE37jT4MVF1JSCVwTC9LyxD7tNr5F8hLBjyT/Z
	8Ee0Yqrlt613HxxOzlVB9gaNlZ6DtpC1hmKBAeEWe/i19lW3hrAgSCje4Tx3ZsigjwRYaS0t5Kh
	iYOxf2wRDw8vTPftj3HaBdb56pKI1goV/D5KdtkOTlOStH1Fl0U5D7zQdKEAdmRWzcT0u/SiQmE
	Q4=
X-Received: by 2002:a17:902:d2cc:b0:2dd:ad73:c982 with SMTP id d9443c01a7336-2ddb1ba0faamr58779045ad.26.1789750580884;
        Fri, 18 Sep 2026 09:56:20 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75bfe10sm11409685ad.64.2026.09.18.09.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:56:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
Date: Sat, 19 Sep 2026 01:55:58 +0900
Message-ID: <20260918165601.1014666-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
vmstat counter"), mod_memcg_page_state() has no callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/memcontrol.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b57a74617b0b..c0557e1e3d21 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -949,21 +949,6 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
@@ -1396,11 +1381,6 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-}
-
 static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
-- 
2.43.0


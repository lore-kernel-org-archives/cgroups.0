Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8EB48822F
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671986; cv=none; b=nOx28GGX1eI8c1lK3zQ9wxg35KBxg7Ee12vLqeRj9MMNbH3wnNMq/G4jmfayvgOSWR1xXWOz6OgZi7J0XxxG45ZQK63hwH7WUiJQE7rhAKM8S9Z3lfzHYBiuZppYAuSIoStavA0s7eGRnEwctEB0mwLIL1CSbsRBmQnVBXr1jEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671986; c=relaxed/simple;
	bh=7RdfGNwJGIhjQira6vfwXUtsmsJVS3QW6ObOGHjEZac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebgTb7c5otFRvy82FmZvFlT/miT0RVHNL/my1YPwR7PbbJ74Pr+cpUP3n2HAPuYYB3e/sh6m6G375BJdOeykmVLO/K9vsZq+dK4+giQTFpLfmP1YoGfJpROzf0jeANAFn6WBWL8+AY4mKeSbxL8N7aqI7u/cmeGPAKePGlkpOiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUeJopBE; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUeJopBE"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-451a49abd8aso4260710fac.3
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671976; x=1788276776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rRVrRpujJcoHdsF0W6IfC5VyfQfzFj4+BdlWYD2xQfM=;
        b=JUeJopBEk2oDKXIstUSpBzgQvbrlelqGvN4OwaZc9kIkXLXenGx2VBEBckocKtHjDT
         efbXIqnTecWRPIA40NF+phHEbBpWwMTOiyBUyRa/3y5lLzUZ/0rZ434dv9LPio6dBj0N
         ldWW9MhAHESkcEB5ECWvdBsgPdvSy2XQn/UFJldTsQ1ixOjvUqGdsm+4SeQySYIJlgyH
         5mKOZb99+ReXXdyoVmvYlKbDZrACgkP8HOgQbbg+MljbBv5W5JDWEM2sSUca4tQqI6qe
         6sphLU4Fq1nG1ifHHtCdspwDgAePkssPid7/VGOW37UTWUXN2kVzho0DACm9U3SLMNd0
         XyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671976; x=1788276776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rRVrRpujJcoHdsF0W6IfC5VyfQfzFj4+BdlWYD2xQfM=;
        b=deWRH+rrEPHVk8+ryCH1RbiK4nc0N5dLoALpTi1M46ETgkp4u5Y4HOkcFfOyKwhnqB
         voPXkkC6zMxosVnnpMNoBp3vb4Alm/xu8GRgzsqw7BS0DZ+i4mF2FV4+hqaNcBDiikku
         4ZrFqoo3pYsKq24T38eAfP7cbWhJcmrSvA3YxdndC9DZ0inM2OI3rK7sma6z2WwbZWd/
         zbomkzEVYS5V4SDIZT7TsKexXjptKV184Ks1m3N6IYro+0ZygQcNe9ibIeZg6O4cj2L+
         xgDRySoOOmnvmieY+Xgtks3oxMjSYhjb1UlnBNOQbfn85wqhYYD8WRjRjjdM5t+BFXgh
         rwLw==
X-Forwarded-Encrypted: i=1; AHgh+RoRfeTLZo6+Cc9u52DcCuebB6PQjiuro6OZ0ogqxmsKuLj822gTLE3DsmJRgPOKH4P1qcQNN/y5@vger.kernel.org
X-Gm-Message-State: AFuF++mDshoi0NpAPOlEpwImGwp49thTvu6S5UGyoVV4XqS/8MFpkilx
	R+jSud2SWYL4ZeoFd43xxdd/Ag2ydaJouCu53E3S8lBWv+3RAKoVGwAH
X-Gm-Gg: AR+sD10AvGXU+FeRbHBPwNnVQO3sGJqWHTwwh1yWcwQT0NFnYwnaJ8kYGsFHJGkvtba
	KC+w9HedA21D1j6JiGKZ2yJOMdUmv8iWA0KzN/69h+CnJGkyWSy1zT8i75nWFAWGiSU4x/O8gyH
	yluVorcUC0T2hX2IMLjcgPSqu+hH16iZruNwFsEmSwX6EQcX4h1R8ngdGQKBS3XW30ya2w8r0kQ
	AOj4b9ozoLoDxKaJiTup9RxTeJbqwucH6PDdOjExeQQrWJ01fTpynOfxs0o47LUUUrk4Y3x88ac
	3lIS3WDifAqaxLsVw3a3ia7UcMR9cL1Ec9dbkJEOJgGJ9yE8loq2tC97jZECbqETVwuZUc5fyrz
	pahw82Q+Pp3PiDcwIeGXk3+PM7LDN2Mh/CO7WW2tKSli9pJ8+2OToyZQ6/6e7oz3i8zbu+9glDE
	MZtGBuBYaw2iwL883yo3Tpe9UZduauO9dpNZqzhonNTh3u8KPuGkAZFpbE7yJBfYBihLE9BtxqI
	JsuOuhq8weDmTjZjrHOtA==
X-Received: by 2002:a05:6820:8106:b0:6ae:5250:dd1c with SMTP id 006d021491bc7-6b1904fd029mr6471337eaf.29.1787671975541;
        Tue, 25 Aug 2026 08:32:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4638353a37asm7759186fac.15.2026.08.25.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:54 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 09/11] mm, swap: add debugfs counters for vswap
Date: Tue, 25 Aug 2026 08:32:35 -0700
Message-ID: <20260825153238.2695446-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add /sys/kernel/debug/vswap/ with two counters:

* used: virtual swap slots (pages) currently allocated
* alloc_reject: cumulative pages that failed to get a vswap slot

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 517fa58f8022..3b10173cddc3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -142,6 +143,8 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
+
 static bool vswap_alloc(struct folio *folio);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
@@ -1983,6 +1986,7 @@ static bool vswap_alloc(struct folio *folio)
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_long_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 
@@ -4795,9 +4799,25 @@ early_param("vswap", early_vswap);
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+static int vswap_used_get(void *data, u64 *val)
+{
+	*val = swap_usage_in_pages(vswap_si);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_used_fops, vswap_used_get, NULL, "%llu\n");
+
+static int vswap_alloc_reject_get(void *data, u64 *val)
+{
+	*val = atomic_long_read(&vswap_alloc_reject);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_alloc_reject_fops, vswap_alloc_reject_get, NULL,
+			 "%llu\n");
+
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4841,6 +4861,12 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_file("used", 0444, root, NULL, &vswap_used_fops);
+	debugfs_create_file("alloc_reject", 0444, root, NULL,
+			    &vswap_alloc_reject_fops);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 
 	/* Last: everything above must be visible before routing starts. */
-- 
2.53.0-Meta


Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B3951CF7D
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754584; cv=none; b=QXqPOS912yXwD6UQZzaFC1w2cXNJUpNvJeB2yYPZKwZ6ja0UPSWhpy3BzyfIz0604FViBnr0q5OawkfUk+C+3DHsP88FG1HJyCDqqPE6EdU5674artnQzGiOs5X1kegjoL48l5tHpGlCeJturPj3WqEbpELA2bV9+USE7CdjnZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754584; c=relaxed/simple;
	bh=DKrV8Dk2Xf7+0f4DO4cy+Nlg5v572tfl82Ug1Z8WZHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbXotB3wo++dmRA5dGfJnXJormoijEtICQ+0PLPFtAaYa3rQk/R8Y4tKMBYHo0mwcR4mZEUYa/gMZvBjbNl/9IqHSJewcmD2pQWUwcZU+WQbU/bVQUXThncl6+6L4Wx68ppaC30MqFnRrZRwOoEjwyW4U2WNg97EKDq56Bgn5ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NKrZdAbX; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKrZdAbX"
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7fcb425fb68so575806a34.0
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754578; x=1790359378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WkWDXoev3ue4855J8KR8M6HtT2XHzciSRhLql9R/iaw=;
        b=NKrZdAbX37tFFps5wJG4gDwuD+7Amk62HrEVxFb/x1qyabY3KErXXE+KjUcrEOyYmL
         K4OwhcMHOEeh+DxWeefb/D0MzN/Tkp4CezgeyEEXrSRlKXIOCLI2xN9GZ+EIEVVwEa7p
         GJ/p0t8SrCvbbixIM+pkLNA20Vkh6DiJdCp/xYd2FTdukvboriPIQU1toHND7YOwAvhh
         kDAabakX9n/RP4yzyoR5YnGsD5tXBCXAlLfk/msencEMtGQxxQwahA3rlzpIlPkU67zt
         QEczZjrWWPzmHWBS8lWuCRi93i6JJil4KnMTv96lYSbMWkoXeXvBkWz3ID8x7fo46Yl5
         FyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754578; x=1790359378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WkWDXoev3ue4855J8KR8M6HtT2XHzciSRhLql9R/iaw=;
        b=12vvdL/aPyhyVPu4Eo141hQAgc8tT8IKJRNdIzxi7eCfWfc42RBmIC8wtqXeH1cA+R
         B4IXLCV3VV8GiFwbZT/Jh2o07XM4LANfE+j6MuMWBLFWAzwljn/qoyhj1hUj6d1NDSdP
         KQZx3DJecmhcyiTT/Tef6rr/xvFZnO3qcgUxGkENg3nE38GLU5n8pi7WBrxhgjCX/cRI
         sxTUM/n6zr7OAteKGoaDitljeXl37L+22Eobs+eFnks6PoGlMR6uU4fJoWzwmkntMs0P
         jv5Pn13w/+j6MFbOrNAlKnkbCWCQ2W/kc4CrNnijYbT+4ND5hatNZLnqHpfFJ+ZIHn/X
         oLBQ==
X-Forwarded-Encrypted: i=1; AKwUvByrDKzyZL0YApbucKdK0ZOPGTiZVQsNbh1Qnk5K6dautUb0VLuAfKEvUoJ+Cyz02dE6MxKxo9SF@vger.kernel.org
X-Gm-Message-State: AFuF++l4ReWNYIUn6pgRHvBiWpdzypVszH3RwQfnfylMzr2EuGeWzD5i
	1hU6DDHxhY9kQ4cvDqyo4IDvv5QQzZrmE3Un+k+zfS7NVyG4PsW8yd02
X-Gm-Gg: AYBFou0Co16VDmK+IWu7ChnupBv7aL4Sq8cAxObYTF13L/KGS/AxjoeWWRUWuZfbyBW
	rTiinBobaFakIQ19I9MrCHRNyZRrgQ0h7hMZ01pUpcCqBsbpo9xoPSddzNbMX0DT2zgbqylZKep
	bTwnD4PJXv1Ww1GlKOarNuzxSTMTA42A9ECdSD8Of5Uu3d4yxzTdky30EFpGzRl+p/v1OP3YVjD
	VwRRC2ZbEpCJRBisrfScUzmAsMRsWBBwBHdhtXDKQyJP8cjoBv9Op5T+675mfVXb2w+y8V2pOfG
	0L5D7kicLl2aoeSgXDDOe7g5oBvtgAYtBEUNuglxaKiWVOjcbKJYqL1Cl35z+bAKvGyeOklP6Cf
	dHIgyjn3OA5DBthB8kcVwFd2zsokQcuH/CyxKJfN/DQV06DCSH9LicDZt4zoSF1CFxOZ6uRIgmQ
	3sxNOyScH0A+ARK8GC54MUixyjyOVzGYH6rzeCfK8ewNv2sK7sJ7Ht2zLbVBoc2HKMVpKibQ556
	VgQwQUONeeg5UvkB983rg==
X-Received: by 2002:a05:6820:81c2:b0:6c3:38ca:c9c0 with SMTP id 006d021491bc7-6ca9ca59232mr3229844eaf.53.1789754578532;
        Fri, 18 Sep 2026 11:02:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6cd3591d0b6sm565715eaf.12.2026.09.18.11.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:57 -0700 (PDT)
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
Subject: [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
Date: Fri, 18 Sep 2026 11:02:39 -0700
Message-ID: <20260918180241.3424851-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
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
 mm/swapfile.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3c3fc3b87b9b..cf07d87d2301 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -142,6 +143,7 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
 static void vswap_clear_cache_only(struct swap_cluster_info *ci,
@@ -1996,6 +1998,7 @@ static bool vswap_alloc(struct folio *folio)
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_long_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 
@@ -4827,9 +4830,25 @@ early_param("vswap", early_vswap);
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
 
@@ -4881,6 +4900,12 @@ static int __init vswap_init(void)
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


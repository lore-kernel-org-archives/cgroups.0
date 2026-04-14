Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109C3D8135;
	Tue, 14 Apr 2026 11:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776164828; cv=none; b=VUwVW66vUe5jZ1hOeilSgIqDXMTw8Gq1OVNKM8GKlMKclCIP96CIaAAJE9udZ6SqegTW0OAa1CdgJ7XwDSltJBJZp/DhoGTfm1JhB9LfNEeg6p32ygyVUzJhTFkhzOs2hIPoN5zcTXxV+skHRiZbrtlTuopTmSfi+aqtT2Ng4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776164828; c=relaxed/simple;
	bh=odbw2zHxq1iG4fbOnoXpUiNRcYVeB/XVY1YKKBUEn7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmCPyrh0yeB3GN6a1IFEt/HsqEcvbio2LWYbOqusgUPYA/21JjrQ83aWA7oE8Nlp7uBMsAjjfGBDWeeyjKqAP+a53QooRg5qT9cA2vSTx2gNRpzREksI1ZYRYPqPHvtXyn6uuZJy/aDpH2/qOpulyHb+R0UnssYE4qxlwqkmjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bx0+lO4e; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bx0+lO4e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Su
	xd8W/enAVPZbmnsORtZjfIS+87GmyYpLzs7e2B95M=; b=bx0+lO4eyFbzp6awnD
	yhrErhvDNKDeg4ebQx5borCoIug08hdFF43r5RQCTk1rBo7Tsf1hTI++S5wdrVlu
	ReAoRSxR++C0WFI7msr8FC11BNR6E4IAJp0zjXDx+6xQ51MuByRUPQae1xt8Ilbl
	ErpqFYqbabtZ05BVHrSgoY/b0=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBnrLh2H95pqLbvEg--.46126S3;
	Tue, 14 Apr 2026 19:05:30 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	kuba@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 1/2] kselftests: cgroup: update kmem test tolerance for multi-memcg stock
Date: Tue, 14 Apr 2026 11:05:23 +0000
Message-ID: <20260414110524.2414-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414110524.2414-1-ranxiaokai627@163.com>
References: <20260414110524.2414-1-ranxiaokai627@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnrLh2H95pqLbvEg--.46126S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFWxWry7Xw1UGw15urWxWFg_yoW8uF43pa
	s3AFyjywnagFsxAa1Yv3s2gFWfua97XF4UAw1Sqw1fCw13tw1IqF1akFW3Jr95AFZayr4f
	Z3Z3t3yrW3WjvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziwiSJUUUUU=
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRr3RGneH3p3ugAA3z

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Commit f735eebe55f8 ("memcg: multi-memcg percpu charge cache") changed
the percpu charge cache to support multiple memory cgroups
(NR_MEMCG_STOCK) instead of a single memcg per CPU.

Prior to the multi-memcg stock change, the tolerance was calculated as:
  PAGE_SIZE * MEMCG_CHARGE_BATCH * num_cpus

With NR_MEMCG_STOCK slots per CPU, the worst-case discrepancy is now:
  PAGE_SIZE * MEMCG_CHARGE_BATCH * NR_MEMCG_STOCK * num_cpus

Update the test tolerance to include the NR_MEMCG_STOCK factor to
prevent false positive test failures.

Fixes: f735eebe55f8 ("memcg: multi-memcg percpu charge cache")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index eeabd34bf083..15b8bb424cb5 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -19,12 +19,19 @@
 
 
 /*
- * Memory cgroup charging is performed using percpu batches 64 pages
- * big (look at MEMCG_CHARGE_BATCH), whereas memory.stat is exact. So
- * the maximum discrepancy between charge and vmstat entries is number
- * of cpus multiplied by 64 pages.
+ * Memory cgroup charging is performed using per-CPU batches to reduce
+ * accounting overhead. Each cache slot can hold up to MEMCG_CHARGE_BATCH
+ * pages for a specific memcg. The per-CPU charge cache supports multiple
+ * memcgs simultaneously (NR_MEMCG_STOCK slots).
+ *
+ * While memory.stat reports exact usage, per-CPU charges are pending
+ * until flushed. Therefore, the maximum discrepancy between charge and
+ * vmstat entries is:
+ *
+ *   PAGE_SIZE * MEMCG_CHARGE_BATCH * NR_MEMCG_STOCK * num_cpus
  */
-#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
+#define NR_MEMCG_STOCK 7
+#define MAX_VMSTAT_ERROR (4096 * 64 * NR_MEMCG_STOCK * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
-- 
2.25.1



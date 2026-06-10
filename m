Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21D1349CE7
	for <cgroups@vger.kernel.org>; Wed, 10 Jun 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781115213; cv=none; b=UvM26YbDbyvnFiZ8cA5bZYZwVgAILcYYSGmHQs8NpLx0pxgUrgvTWE05ghqc8HNwPWnzuuRlPkcTZD4ZLFLhUya3dn8Y3Y7jzwBw9se8EHs+3DTSKXOubOaUd+BAsXEfNkt5Edh3eK/VhEYbFJSvBVen7Hzg6Uo4Meehr6LbEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781115213; c=relaxed/simple;
	bh=sYtALYXPG+HZKJaDBiG6iTOdsRI8vp4tB/2k5T+08sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YY7K0uRN3lTPI3F3vpL78a7+QWa2nmQDpjUVykYh3LrTVC4DwtbaoDoo9PM6hHJw/KgttZhnDt4swabAWxZjCl3cpEeRlQ3hpTVrJ6BYQpUrlCE28FtwmWO2V+S7ssovRWAWWg9Qe1wp7FW4Qc6HijqKjjjNgq78nXd9LYLSygU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADH3rhBqSlqiDx4AA--.37339S3;
	Thu, 11 Jun 2026 02:13:24 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: cgroups@vger.kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	pandit.parav@gmail.com,
	yuantan098@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	tr0jan@lzu.edu.cn,
	d4n.for.sec@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] cgroup: rdma: free idle pools during cgroup teardown
Date: Thu, 11 Jun 2026 02:13:16 +0800
Message-ID: <9eb365a37ab83f38686007f8a61a656759d39bd7.1781092143.git.d4n.for.sec@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1781092143.git.d4n.for.sec@gmail.com>
References: <cover.1781092143.git.d4n.for.sec@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADH3rhBqSlqiDx4AA--.37339S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar47GFWxJw17tw18AFW7CFg_yoW5JrWUpF
	Z7Cr43K3s0vr1xJrs8Jw1xua4vga1kJa1UKa9xG34xu3ZaqrWSqrnFyrW5Zr98XFy2kr45
	tF1YvrZ8ZFWUAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEOCWopHlEJkgAAsQ

From: Daming Li <d4n.for.sec@gmail.com>

rdmacg_css_offline() converts each pool to all-max limits so the
existing reclaim path can free it after the last uncharge. However,
zero-usage pools are already reclaimable at that point and leaving them
linked until rdmacg_css_free() lets later device teardown hit a
use-after-free when free_cg_rpool_locked() deletes cg_node from a freed
cgroup list head.

Free zero-usage pools directly from rdmacg_css_offline() while holding
rdmacg_mutex. This keeps the existing reclaim rule, avoids new lifetime
states, and ensures a cgroup cannot be freed with reclaimable rdmacg
pools still attached.

Fixes: 39d3e7584a68 ("rdmacg: Added rdma cgroup controller")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Daming Li <d4n.for.sec@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 kernel/cgroup/rdma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 9967fb25c563..10ae628d91a7 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -587,18 +587,22 @@ static void rdmacg_css_free(struct cgroup_subsys_state *css)
  *
  * This function is called when @css is about to go away and responsible
  * for shooting down all rdmacg associated with @css. As part of that it
- * marks all the resource pool entries to max value, so that when resources are
- * uncharged, associated resource pool can be freed as well.
+ * marks all the resource pool entries to max value, so that active pools can
+ * be freed when resources are uncharged and idle pools can be freed
+ * immediately.
  */
 static void rdmacg_css_offline(struct cgroup_subsys_state *css)
 {
 	struct rdma_cgroup *cg = css_rdmacg(css);
-	struct rdmacg_resource_pool *rpool;
+	struct rdmacg_resource_pool *rpool, *tmp;
 
 	mutex_lock(&rdmacg_mutex);
 
-	list_for_each_entry(rpool, &cg->rpools, cg_node)
+	list_for_each_entry_safe(rpool, tmp, &cg->rpools, cg_node) {
 		set_all_resource_max_limit(rpool);
+		if (rpool->usage_sum == 0)
+			free_cg_rpool_locked(rpool);
+	}
 
 	mutex_unlock(&rdmacg_mutex);
 }
-- 
2.34.1


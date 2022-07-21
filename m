From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH 5/9] sched/psi: don't create cgroup PSI files when psi_disabled
Date: Thu, 21 Jul 2022 12:04:35 +0800
Message-ID: <20220721040439.2651-6-zhouchengming@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTBK+C00vRPG4JDueYyv7EqFsWvxIqsN3waJE+O/isA=;
        b=QHIvOf/vF7cxWQOSppu23p6vElDHp0+ZqYuQj3IE6sYMS6UGWgb8VpdRJEDv/3fmgK
         EBsyNAQs2eSnCL8T+CYX5Ge6nLSOCZhoT7717mCb3PYoGzDPZvxo0RttCkMybvV+RiqR
         7lSJrgu7/rcXtElobuMaOqMSQk4MZHbvh0tkYM8/N8UBVTGiNPK+sk0l0Q1No0nSuCne
         +ICLWxXj78VcKThofLCbfIwAuz7LBngg0/wfa0zSvrleB7AUxs7BkQP92oCOqUvaFR9q
         96tnMKzLbOOur2qTlrlpvcq9bAVMyNMH61VFRD89X5LBADuZX1NXdhUgyrLX/EYl/Du0
         N72g==
In-Reply-To: <20220721040439.2651-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
make PSI can be configured to skip per-cgroup stall accounting. And
doesn't expose PSI files in cgroup hierarchy.

This patch do the same thing when psi_disabled.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 kernel/cgroup/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..1424da7ed2c4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3700,6 +3700,9 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 
 bool cgroup_psi_enabled(void)
 {
+	if (static_branch_likely(&psi_disabled))
+		return false;
+
 	return (cgroup_feature_disable_mask & (1 << OPT_FEATURE_PRESSURE)) == 0;
 }
 
-- 
2.36.1


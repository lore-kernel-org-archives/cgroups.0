From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v4 02/10] sched/psi: don't create cgroup PSI files when psi_disabled
Date: Fri, 26 Aug 2022 00:41:03 +0800
Message-ID: <20220825164111.29534-3-zhouchengming@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HEbBlNE74XAOeDaqxFIrSXJjdeTVN4APARuNyd0Kkrc=;
        b=cIO/d1BGqL6fFstMorhflZg+vJ9obx8pMQqBtB2zXIPXvMogHPeMsu0jrMv3o/VTJZ
         IBkJf62+3rnapmZ4QtajmqxNiCKCoJpFUWP5Aj+4N2faq+JVYEs0jc7ZNWjuyG1nRM4X
         bG+zNO+sE24Jhpk3TgvTfkthoBCFGUujC2Zb58e5p7FLK/XotEpTJEWCcKgLCmbqgujF
         2omehs8EXzqBUnztnRg0Tg4+J3IhJW7PuV1Uhz8xpCunXu90C2TIFPpCGuP+8zZtnPgn
         eqzv/Ei/WX+oIjQ+VhIURYRrhU3nKqOCCdinlLLYeuDtRbLKy3hIv9MJ/xYh3I+q5Cwx
         epJA==
In-Reply-To: <20220825164111.29534-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, surenb@google.com
Cc: mingo@redhat.com, peterz@infradead.org, gregkh@linuxfoundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Chengming Zhou <zhouchengming@bytedance.com>

commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
make PSI can be configured to skip per-cgroup stall accounting. And
doesn't expose PSI files in cgroup hierarchy.

This patch do the same thing when psi_disabled.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 03dbbf8a8c28..2f79ddf9a85d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3748,6 +3748,9 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 
 bool cgroup_psi_enabled(void)
 {
+	if (static_branch_likely(&psi_disabled))
+		return false;
+
 	return (cgroup_feature_disable_mask & (1 << OPT_FEATURE_PRESSURE)) == 0;
 }
 
-- 
2.37.2


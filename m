From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 05/10] sched/psi: don't create cgroup PSI files when psi_disabled
Date: Mon,  8 Aug 2022 19:03:36 +0800
Message-ID: <20220808110341.15799-6-zhouchengming@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHJHLaCoDzV5QUtZAIutwfB8iOBAVflqU47uK3W3CxI=;
        b=frlElavzwzibQasm6LTTz+dwYLm/7rqeeNLg0mE9N8JxS4JAEYhTzxo0uKrELF+WKw
         7BEevAELdtUIHm0Xky0Bw2JYBA+kR11snSOYCiz4VncyE9W7aGBlRw2P8z8s1sBeNKde
         SERqentIU6/0Zn0YuMv5jlTA2bvPz9zxhgB94RoAwxf0qr3Ndpnr0fzN8t1VPXX7wrq0
         SCJPtJNDDahbjM+oOF4wd1meW2kU/S192uFI594ytliYDDWzCTsxma71FB+4OSu2g87C
         qJeAIanKsgf1HweklW8pGokQtQ8q878zeCuJwj3ttpS3Z+CgYOC8CCfQyrRLDjIOR0ZN
         c+xw==
In-Reply-To: <20220808110341.15799-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Chengming Zhou <zhouchengming@bytedance.com>

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
index 13c8e91d7862..5f88117fc81e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3709,6 +3709,9 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 
 bool cgroup_psi_enabled(void)
 {
+	if (static_branch_likely(&psi_disabled))
+		return false;
+
 	return (cgroup_feature_disable_mask & (1 << OPT_FEATURE_PRESSURE)) == 0;
 }
 
-- 
2.36.1


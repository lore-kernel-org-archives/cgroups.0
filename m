From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: minor tweak for logic to get cgroup css
Date: Wed,  3 Jul 2019 10:07:49 +0800
Message-ID: <20190703020749.22988-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

We could only handle the case that css exists
and css_try_get_online() fails.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bf9dbffd46b1..a988d77f6c6d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -488,7 +488,7 @@ static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
 
 	rcu_read_lock();
 	css = cgroup_css(cgrp, ss);
-	if (!css || !css_tryget_online(css))
+	if (css && !css_tryget_online(css))
 		css = NULL;
 	rcu_read_unlock();
 
-- 
2.19.1


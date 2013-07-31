From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/7] cgroup: remove sparse tags from offline_css()
Date: Wed, 31 Jul 2013 16:16:40 +0800
Message-ID: <51F8C7E8.1080909@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

This should have been removed in commit d7eeac1913ff
("cgroup: hold cgroup_mutex before calling css_offline").

While at it, update the comments.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e60eba2..916a699 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4164,7 +4164,7 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	INIT_WORK(&css->dput_work, css_dput_fn);
 }
 
-/* invoke ->post_create() on a new CSS and mark it online if successful */
+/* invoke ->css_online() on a new CSS and mark it online if successful */
 static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	int ret = 0;
@@ -4178,9 +4178,8 @@ static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return ret;
 }
 
-/* if the CSS is online, invoke ->pre_destory() on it and mark it offline */
+/* if the CSS is online, invoke ->css_offline() on it and mark it offline */
 static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
-	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 
-- 
1.8.0.2

From: Daniel Vacek <neelx@redhat.com>
Subject: [PATCH] cgroup/cpuset: no need to explicitly init a global static variable
Date: Tue, 20 Dec 2022 16:14:15 +0100
Message-ID: <20221220151415.856093-1-neelx@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671549265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bMwcEP88aaxPcKpXm4Jr7ZoA7j+pIF0TnJwOHWp6n0E=;
        b=eQNZVP7xmLmiQ/e6P+T5VsSm/WW8/GXyV3vHld0WvAuiOWx+IlWaMJkwWDET8wvpYYleAT
        90m8R67uHo8uhHUXGD7RvRZxXX2cdMln98TtES2fc/3291tNQqSbwiluaMne99ObUDi0kV
        JSU4ETvtQNLsjylbqFsFpRVjh8F+tDk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Daniel Vacek <neelx@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

cpuset_rwsem is a static variable. It's initialized at build time and so
there's no need for explicit runtime init leaking one percpu int.

Signed-off-by: Daniel Vacek <neelx@redhat.com>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a29c0b13706bb..87fe410361b3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3281,8 +3281,6 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 
 int __init cpuset_init(void)
 {
-	BUG_ON(percpu_init_rwsem(&cpuset_rwsem));
-
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL));
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&top_cpuset.subparts_cpus, GFP_KERNEL));
-- 
2.38.1


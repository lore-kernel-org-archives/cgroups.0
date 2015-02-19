From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH 1/2] cgroup: call cgroup_subsys->bind on cgroup subsys initialization
Date: Thu, 19 Feb 2015 17:34:46 +0300
Message-ID: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Currently, we call cgroup_subsys->bind only on unmount, remount, and
when creating a new root on mount. Since the default hierarchy root is
created in cgroup_init, we will not call cgroup_subsys->bind if the
default hierarchy is freshly mounted. As a result, some controllers will
behave incorrectly (most notably, the "memory" controller will not
enable hierarchy support). Fix this by calling cgroup_subsys->bind right
after initializing a cgroup subsystem.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2cc593e..21a4b6d61e21 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5040,6 +5040,9 @@ int __init cgroup_init(void)
 			WARN_ON(cgroup_add_dfl_cftypes(ss, ss->dfl_cftypes));
 			WARN_ON(cgroup_add_legacy_cftypes(ss, ss->legacy_cftypes));
 		}
+
+		if (ss->bind)
+			ss->bind(init_css_set.subsys[ssid]);
 	}
 
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
-- 
1.7.10.4

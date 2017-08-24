From: Waiman Long <longman@redhat.com>
Subject: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 10:40:11 -0400
Message-ID: <1503585611-13496-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>

Given the fact that thread mode is now queued for 4.14, it is now
time to enable cpuset to be used in the default hierarchy (cgroup v2)
as it is clearly threaded.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f3539a4..fb99d66 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2100,7 +2100,9 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.bind		= cpuset_bind,
 	.fork		= cpuset_fork,
 	.legacy_cftypes	= files,
+	.dfl_cftypes	= files,
 	.early_init	= true,
+	.threaded	= true,
 };
 
 /**
-- 
1.8.3.1


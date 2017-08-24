From: Waiman Long <longman@redhat.com>
Subject: [PATCH] cpuset: Fix incorrect memory_pressure control file mapping
Date: Thu, 24 Aug 2017 12:04:29 -0400
Message-ID: <1503590669-16601-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>

The memory_pressure control file was incorrectly set up without
a private value (0, by default). As a result, this control
file was treated like memory_migrate on read. By adding back the
FILE_MEMORY_PRESSURE private value, the correct memory pressure value
will be returned.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f3539a4..84ba237 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1898,6 +1898,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	{
 		.name = "memory_pressure",
 		.read_u64 = cpuset_read_u64,
+		.private = FILE_MEMORY_PRESSURE,
 	},
 
 	{
-- 
1.8.3.1


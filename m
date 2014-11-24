From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
Date: Tue, 25 Nov 2014 01:39:19 +0900
Message-ID: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=OlnRWF6Mfc7Awl1RgjupJ3aouBTEkUhsy1PUtVTxBxQ=;
        b=BqpGJI00LDAN3ZQOySngc1fPvDrPKiJ2JTqnjyouzwbQEjZzA8ROuVrpTamrG2Dshw
         r4yPimlwNnyJ0z8JHfCd2Erse+OxCOQDWxIKIcc3BY8v0hsAlRw7qEQI8+8Pnp8vjpxF
         b8mVFYwbmQqpwIV1X6BVKgkjPH4lvHgtVt6Y0glGXfcE5yTN2NPn7D9C/yoTILtH0pft
         EPvl+ZEA/7yF8tVGlN+50mznj/NQuDxzl1R0ByPOQyRz2EqNkWZilY7JCYeXPxL1+Y0j
         m+8IBoo8/N02yc+uG67aWvxwi29Izv22TYU/jXlebF/Tf8UU6/1QgDNvX+JcnlE+MZK8
         U4tQ==
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: lizefan@huawei.com, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>

Few paths used as example to describe cgroupfs usage have been wrong
from f6e07d38078e ("Documentation: update cgroupfs mount point") by
mistake. This patch fix those trivial wrong paths.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/cgroups/cgroups.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 10c949b..f935fac 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -312,10 +312,10 @@ the "cpuset" cgroup subsystem, the steps are something like:
  2) mkdir /sys/fs/cgroup/cpuset
  3) mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
  4) Create the new cgroup by doing mkdir's and write's (or echo's) in
-    the /sys/fs/cgroup virtual file system.
+    the /sys/fs/cgroup/cpuset virtual file system.
  5) Start a task that will be the "founding father" of the new job.
  6) Attach that task to the new cgroup by writing its PID to the
-    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
+    /sys/fs/cgroup/cpuset tasks file for that cgroup.
  7) fork, exec or clone the job tasks from this founding father task.
 
 For example, the following sequence of commands will setup a cgroup
-- 
1.9.1


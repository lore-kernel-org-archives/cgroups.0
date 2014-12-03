From: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cgroups: Documentation: fix wrong cgroupfs paths
Date: Wed,  3 Dec 2014 20:53:44 +0900
Message-ID: <1417607625-2775-1-git-send-email-sj38.park@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=OlnRWF6Mfc7Awl1RgjupJ3aouBTEkUhsy1PUtVTxBxQ=;
        b=dqjRd+ppIqhLGmiPFCBfOjcyXDk+8V7v50DQodJtMl2CTsy+Sa+oHyqiQrTPyvigAy
         nHda6XV5o2OyoWYPRepJH0b3B0FRyZ+kt69HhamZE5wT3zkk8ZmJ/bw1tfSuriGrJRQC
         k1ybHfUwuIPhCtcGrxvx0yVjYkLb42dt+fLzsLlMflON4QiRQEoIJVSsTifwvj+tcbSU
         ZOdJ7HO21GFKrb7YWDsvBKmDxrFWupPRxt7XlRT+kJZV+pIm32qdBeQrtbFg0s9FLWxn
         t6yAeKJDu+7W7cMvIs2Yf6La1724hQt4UN9GQQ7FR83BBNZsnatnGuAkBu4+71zQwoQn
         e86g==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Few paths used as example to describe cgroupfs usage have been wrong
from f6e07d38078e ("Documentation: update cgroupfs mount point") by
mistake. This patch fix those trivial wrong paths.

Signed-off-by: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

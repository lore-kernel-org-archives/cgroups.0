From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: [PATCH] Documentation: cpuset: Fix 'cpuset.tasks' -> 'tasks'
Date: Thu, 12 Jan 2017 14:24:27 -0800
Message-ID: <9dd9adef5fe4ae283d0510204f556b4390e5a897.1484259596.git.wking@tremily.us>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>

This looks like it was accidentally caught up in e21a05cb (doc:
cpuset: Update the cpuset flag file, 2010-02-24).

While I'm touching the line, also fix the posessive "cpusets" ->
"cpuset's".

Signed-off-by: W. Trevor King <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
---
 Documentation/cgroup-v1/cpusets.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

This patch is based on v4.9, but the lines I'm touching don't churn
much so it should apply to any recent version.

diff --git a/Documentation/cgroup-v1/cpusets.txt b/Documentation/cgroup-v1/cpusets.txt
index e5ac5da86..8402dd6 100644
--- a/Documentation/cgroup-v1/cpusets.txt
+++ b/Documentation/cgroup-v1/cpusets.txt
@@ -615,7 +615,7 @@ to allocate a page of memory for that task.
 
 If a cpuset has its 'cpuset.cpus' modified, then each task in that cpuset
 will have its allowed CPU placement changed immediately.  Similarly,
-if a task's pid is written to another cpusets 'cpuset.tasks' file, then its
+if a task's pid is written to another cpuset's 'tasks' file, then its
 allowed CPU placement is changed immediately.  If such a task had been
 bound to some subset of its cpuset using the sched_setaffinity() call,
 the task will be allowed to run on any CPU allowed in its new cpuset,
-- 
2.1.0.60.g85f0837

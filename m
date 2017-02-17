From: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Subject: [PATCH] cgroup: Fix indenting in PID controller documentation
Date: Fri, 17 Feb 2017 18:44:11 +0100
Message-ID: <20170217174411.8475-1-tklauser@distanz.ch>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Follow the common documentation style in the file and indent the
interface file description by a tab instead of just a space.

Signed-off-by: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
---
 Documentation/cgroup-v2.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 3b8449f8ac7e..49d7c997fa1e 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1142,16 +1142,17 @@ used by the kernel.
 
   pids.max
 
- A read-write single value file which exists on non-root cgroups.  The
- default is "max".
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
 
- Hard limit of number of processes.
+	Hard limit of number of processes.
 
   pids.current
 
- A read-only single value file which exists on all cgroups.
+	A read-only single value file which exists on all cgroups.
 
- The number of processes currently in the cgroup and its descendants.
+	The number of processes currently in the cgroup and its
+	descendants.
 
 Organisational operations are not blocked by cgroup policies, so it is
 possible to have pids.current > pids.max.  This can be done by either
-- 
2.11.0


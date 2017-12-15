From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Subject: [PATCH] cgroup, docs: document the root cgroup behavior of cpu and io
 controllers
Date: Fri, 15 Dec 2017 14:20:10 +0100
Message-ID: <93890a54-bbf5-ac0e-8ce0-61a0ff095854@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Currently, cgroups v2 documentation contains only a generic remark that
"How resource consumption in the root cgroup is governed is up to each
controller", which isn't really telling users much, who need to dig in the
code and / or commit messages to learn the exact behavior.

In cgroups v1 at least the blkio controller had its operation with respect
to competition between child threads and child cgroups documented in
blkio-controller.txt, with references to cfq-iosched.txt.
Also, cgroups v2 documentation describes v1 behavior of both cpu and
blkio controllers in an "Issues with v1" section.

Let's document this behavior also for cgroups v2 to make life easier for
users.

Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
---
 Documentation/cgroup-v2.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index d6efabb487e3..8ecefb4fa3fb 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -906,6 +906,13 @@ have placed RT processes into nonroot cgroups during the system boot
 process, and these processes may need to be moved to the root cgroup
 before the cpu controller can be enabled.
 
+When distributing CPU cycles in the root cgroup each thread in this
+cgroup is treated as if it was hosted in a separate child cgroup of the
+root cgroup. This child cgroup weight is dependent on its thread nice
+level.
+For details of this mapping see sched_prio_to_weight array in
+kernel/sched/core.c file (values from this array should be scaled
+appropriately so the neutral - nice 0 - value is 100 instead of 1024).
 
 CPU Interface Files
 ~~~~~~~~~~~~~~~~~~~
@@ -1247,6 +1254,10 @@ limit distribution; however, weight based distribution is available
 only if cfq-iosched is in use and neither scheme is available for
 blk-mq devices.
 
+Root cgroup processes are hosted in an implicit leaf child node.
+When distributing IO resources this implicit child node is taken into
+account as if it was a normal child cgroup of the root cgroup with a
+weight value of 200.
 
 IO Interface Files
 ~~~~~~~~~~~~~~~~~~

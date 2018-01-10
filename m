From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH v2] cgroup, docs: document the root cgroup behavior of cpu and
 io controllers
Date: Wed, 10 Jan 2018 23:33:19 +0100
Message-ID: <90ac05c0-8e84-0c0b-195a-4c1712e40f09@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

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

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
Changes from v1:
Move the root cgroup behavior description to a separate section,
clearly marking it as non-normative information which is subject to
change.

 Documentation/cgroup-v2.txt | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index c783bbb9d0fb..f942952686b2 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -58,6 +58,9 @@ v1 is available under Documentation/cgroup-v1/.
        5-6-1. RDMA Interface Files
      5-7. Misc
        5-7-1. perf_event
+     5-N. Non-normative information
+       5-N-1. CPU controller root cgroup process behaviour
+       5-N-2. IO controller root cgroup process behaviour
    6. Namespace
      6-1. Basics
      6-2. The Root and Views
@@ -421,7 +424,9 @@ The root cgroup is exempt from this restriction.  Root contains
 processes and anonymous resource consumption which can't be associated
 with any other cgroups and requires special treatment from most
 controllers.  How resource consumption in the root cgroup is governed
-is up to each controller.
+is up to each controller (for more information on this topic please
+refer to the Non-normative information section in the Controllers
+chapter).
 
 Note that the restriction doesn't get in the way if there is no
 enabled controller in the cgroup's "cgroup.subtree_control".  This is
@@ -1506,6 +1511,34 @@ always be filtered by cgroup v2 path.  The controller can still be
 moved to a legacy hierarchy after v2 hierarchy is populated.
 
 
+Non-normative information
+-------------------------
+
+This section contains information that isn't considered to be a part of
+the stable kernel API and so is subject to change.
+
+
+CPU controller root cgroup process behaviour
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+When distributing CPU cycles in the root cgroup each thread in this
+cgroup is treated as if it was hosted in a separate child cgroup of the
+root cgroup. This child cgroup weight is dependent on its thread nice
+level.
+For details of this mapping see sched_prio_to_weight array in
+kernel/sched/core.c file (values from this array should be scaled
+appropriately so the neutral - nice 0 - value is 100 instead of 1024).
+
+
+IO controller root cgroup process behaviour
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Root cgroup processes are hosted in an implicit leaf child node.
+When distributing IO resources this implicit child node is taken into
+account as if it was a normal child cgroup of the root cgroup with a
+weight value of 200.
+
+
 Namespace
 =========
 

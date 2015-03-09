From: riel@redhat.com
Subject: [PATCH 4/4] cpuset,isolcpus: document relationship between cpusets & isolcpus
Date: Mon,  9 Mar 2015 12:12:10 -0400
Message-ID: <1425917530-1771-5-git-send-email-riel@redhat.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425917530-1771-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, Rik van Riel <riel@redhat.com>

From: Rik van Riel <riel@redhat.com>

Document the subtly changed relationship between cpusets and isolcpus.
Turns out the old documentation did not match the code...

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/cgroups/cpusets.txt | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index f2235a162529..fdf7dff3f607 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -392,8 +392,10 @@ Put simply, it costs less to balance between two smaller sched domains
 than one big one, but doing so means that overloads in one of the
 two domains won't be load balanced to the other one.
 
-By default, there is one sched domain covering all CPUs, except those
-marked isolated using the kernel boot time "isolcpus=" argument.
+By default, there is one sched domain covering all CPUs, including those
+marked isolated using the kernel boot time "isolcpus=" argument. However,
+the isolated CPUs will not participate in load balancing, and will not
+have tasks running on them unless explicitly assigned.
 
 This default load balancing across all CPUs is not well suited for
 the following two situations:
@@ -465,6 +467,10 @@ such partially load balanced cpusets, as they may be artificially
 constrained to some subset of the CPUs allowed to them, for lack of
 load balancing to the other CPUs.
 
+CPUs in "cpuset.isolcpus" were excluded from load balancing by the
+isolcpus= kernel boot option, and will never be load balanced regardless
+of the value of "cpuset.sched_load_balance" in any cpuset.
+
 1.7.1 sched_load_balance implementation details.
 ------------------------------------------------
 
-- 
2.1.0

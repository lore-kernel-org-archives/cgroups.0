From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/2] cpusets,isolcpus: document relationship between cpusets
 & isolcpus
Date: Fri, 27 Feb 2015 12:08:03 -0500
Message-ID: <20150227120803.07db15fe@annuminas.surriel.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	<1424882288-2910-2-git-send-email-riel@redhat.com>
	<20150227093231.GG21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227093231.GG21418-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Document the subtly changed relationship between cpusets and isolcpus.
Turns out the old documentation did not quite match the code...

Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Suggested-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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
 

From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 7/7] Documentation: cgroup-v2: add information for cpu.headroom
Date: Mon, 8 Apr 2019 14:45:39 -0700
Message-ID: <20190408214539.2705660-8-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=o7WC2UlvTAvUeO79W7+2V8nqP7IPlMcT5D5D+dySPw8=;
 b=mYJY8vFuK2te6xBy3hUDF4h3SMOQhFpe+czVcXurdOoT15pn1044kduvVwijWGgwXrza
 0OYkvvHXPDtfoC8BOGaEHLAv4+/JnZVfLsPdnfnBP5IejjeqpvJ+7o083AYgk0OtDxIa
 qGs1k2wCRG5TZ1TDOexeMObpFkudbbFZRUk= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch adds simple explanation of the new cpu.headroom knob.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 20f92c16ffbf..5007076d6611 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -916,6 +916,10 @@ have placed RT processes into nonroot cgroups during the system boot
 process, and these processes may need to be moved to the root cgroup
 before the cpu controller can be enabled.
 
+Some latency sensitive applications experience high latency when the
+CPU is fully utilized. cpu.headroom knob provides mechanism to reserve
+CPU headroom that are only available to certain applications.
+
 
 CPU Interface Files
 ~~~~~~~~~~~~~~~~~~~
@@ -968,6 +972,20 @@ All time durations are in microseconds.
 	$PERIOD duration.  "max" for $MAX indicates no limit.  If only
 	one number is written, $MAX is updated.
 
+  cpu.headroom
+	A read-write two value file which exists on non-root cgroups.
+	The default is "0.00 max".
+
+	The idle CPU headroom claimed by the cgroup. It's is in the
+	following format::
+
+	  $HEADROOM $TOLERANCE
+
+	which indicates that other cgroups should be throttled to
+	yield $HEADROOM % idle CPU. If it is not possible to maintain
+	$HEADROOM % idle CPU, other cgroups will consume at most
+	$TOLERANCE % CPU.
+
   cpu.pressure
 	A read-only nested-key file which exists on non-root cgroups.
 
-- 
2.17.1


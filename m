From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] docs/scheduler/sched-bwc: note/link cgroup v2
Date: Tue, 19 Jan 2021 16:18:19 -0800
Message-ID: <20210120001824.385168-6-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BDt3dRzzxyMOUVS7eh8bQyHtp1JLCsZLHuvxlUpRuiQ=;
        b=nLjy6Gxfv1a4qY2nlC2Q1hEzRowvlssXmdDWcqH6bGPspja43Qfhxa7Ix0xWdumpK1
         fqRacr0Kb8R5o0QBYPdYxbrWysEjuAX/uKmvA4Jal5djhdVZr47c2PAAwFwExDJn8DGz
         sXn9eBhPSm1prO93M+BMkEIPoDoNgXceZJHFqmhyQGjhNLA71Nes4XsbcgtiKR6ue1fe
         dKYZDs7VLYArrmlc0IScF7j5Px+C1lCsTHo9AxRPf81PciVHvIWxUzqkI+SDs3Xr3i38
         R5Z6Y9+Uj0CFPdpS4LD960+wLMDwtkvbQ0UumajZGyMXdwb4y36b9QCkg5vinGXuWfvT
         9Igw==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 Documentation/scheduler/sched-bwc.rst   | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index e0f6ff7cfa93..b55362454886 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1,3 +1,5 @@
+.. _cgroup-v2:
+
 ================
 Control Group v2
 ================
@@ -954,6 +956,8 @@ All cgroup core files are prefixed with "cgroup."
 Controllers
 ===========
 
+.. _cgroup-v2-cpu:
+
 CPU
 ---
 
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index dcec7440c222..963fde3993dc 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -27,6 +27,11 @@ Management
 ----------
 Quota and period are managed within the cpu subsystem via cgroupfs.
 
+.. note::
+   The cgroupfs files described in this section are only applicable
+   to cgroup v1. For cgroup v2, see
+   :ref:`Documentation/admin-guide/cgroupv2.rst <cgroup-v2-cpu>`.
+
 - cpu.cfs_quota_us: the total available run-time within a period (in
   microseconds)
 - cpu.cfs_period_us: the length of a period (in microseconds)
-- 
2.29.2


From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/10] docs/scheduler/sched-bwc: add proper ref
Date: Tue, 19 Jan 2021 16:18:18 -0800
Message-ID: <20210120001824.385168-5-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tXzJgZeFW0MqXzTyG1CaFrbwaPZ1tQM/2q7+gv5S6M4=;
        b=mIXcBx3kExnFoF3rAgXg8Y0Wu3FiLWLpnEXS/UczJOdkeL0yC1hqypRtVpXgGacxkM
         jFXPPaebOVuteHEChay9KDmNeziCRTFDwPBe0G8qEWVc6Ajx6crLYnLLxo68GO6yg+op
         +ZQPcjIEheoIfceVbvtgM2rHoRQTgIAWWEOsSR4+VNmhA+MvKh3SVqkSe3CpsQVPs1MB
         ElUdO99Zv2hUhqifNRyDclRz0V/79CWbfIGu7qVORtMqlRfMz0R4QyjGf2E2hmDv425R
         SxAu+WEkc0bc8kdw4dGzwxmge1QMdYiKJ8GWP6IqhpGMnQzybv5bwGMCncMKSbwx/KpZ
         4snw==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add a proper reference instead of just using the file name.

Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/scheduler/sched-bwc.rst      | 3 ++-
 Documentation/scheduler/sched-rt-group.rst | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index a44860d33ffc..dcec7440c222 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -4,7 +4,8 @@ CFS Bandwidth Control
 
 .. note::
    This document only discusses CPU bandwidth control for SCHED_NORMAL.
-   The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst
+   The SCHED_RT case is covered in
+   :ref:`Documentation/scheduler/sched-rt-group.rst <sched-rt-group>`.
 
 CFS bandwidth control is a CONFIG_FAIR_GROUP_SCHED extension which allows the
 specification of the maximum CPU bandwidth available to a group or hierarchy.
diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
index 655a096ec8fb..a3b4aa51c271 100644
--- a/Documentation/scheduler/sched-rt-group.rst
+++ b/Documentation/scheduler/sched-rt-group.rst
@@ -1,3 +1,5 @@
+.. _sched-rt-group:
+
 ==========================
 Real-Time group scheduling
 ==========================
-- 
2.29.2


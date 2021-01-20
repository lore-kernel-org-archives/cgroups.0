From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] docs/scheduler/sched-bwc: formatting fix
Date: Tue, 19 Jan 2021 16:18:15 -0800
Message-ID: <20210120001824.385168-2-kolyshkin@gmail.com>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XkdryAomM5az2Ze2NYd09JWowO5YjJiadHr5mNXL5/M=;
        b=VP75uQaycjsESHMeLXbRrDjAb4Cqt4odG4boanj7vRVeuesb49E/ZOheLGtFdgZ6Pu
         UutaIeCpF3tfV5s4Unrs4qhoGgGw5i53G2fwKFquvwnELcK35WEbs9fgdW8Z+sBJs/9u
         5BjHCtcOu34bzeflTDxfKz6MItwT0b0RZIfSu4Vrs7r27ZS3NMTJkQczKfJEtXCui6o9
         wiZKGBq45p/Wg2Xr3EytZu4fCxpmcZC7n7e6QTCO8qkYY191T+j1XsyaMv1syZYJveOo
         lpORo4531azB5pI6wvGY5Q1+TN91vTf/dOCL+GnRy67TRZauS4tEBgcdj4+tH6rB9N06
         56vw==
In-Reply-To: <20210120001824.385168-1-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Since commit d6a3b247627a3 these three lines are merged into one by the
RST processor, making it hard to read. Use bullet points to separate
the entries, like it's done in other similar places.

Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/scheduler/sched-bwc.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index 9801d6b284b1..4af4ee1f3600 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -25,9 +25,10 @@ Management
 ----------
 Quota and period are managed within the cpu subsystem via cgroupfs.
 
-cpu.cfs_quota_us: the total available run-time within a period (in microseconds)
-cpu.cfs_period_us: the length of a period (in microseconds)
-cpu.stat: exports throttling statistics [explained further below]
+- cpu.cfs_quota_us: the total available run-time within a period (in
+  microseconds)
+- cpu.cfs_period_us: the length of a period (in microseconds)
+- cpu.stat: exports throttling statistics [explained further below]
 
 The default values are::
 
-- 
2.29.2


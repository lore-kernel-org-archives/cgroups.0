From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/3] docs/cgroup: add entry for misc.events and misc.events.local
Date: Mon, 13 Sep 2021 13:01:01 +0800
Message-ID: <8dd0636659c55fe9db16f8d19af745c185cc4fdb.1631504710.git.brookxu@tencent.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=No9Cu1y2zqzL5EFePgwVsxeseV9YVFbZD57If/1JFIs=;
        b=QPhkIP4EuaDwd0g0Cpi2Seb9O+M/uDEpUGfJLKmy39jucLuWEfQDYmlS6DG7m6hkYm
         QoECCAR3Kz8hTTgbNuquGD8HoegtSz1wuf0f4aml11Tpo4TF611EyFcfPsriGFFvP2aS
         ViYSNGgC/ZSwQLA7rPf1tibRH9yDPn21ZKVbBVEvbKKlTBIHnaepEJxNYNJmXCNy90pj
         zgnlJWcGE/Mt0aQzyaiFoMuYybsgBosa7cLKFjGnW67YUIHlRNhnXduV0Xs7pVXK1GNE
         OHsfLKp6ywHxtz91bqbXeGPlQNyLiTdidtr1d8vRyrBOcaOBrGjtcfcpLXlNE8i0vr8Z
         Wd4A==
In-Reply-To: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Added descriptions of misc.events and misc.events.local.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index babbe04..90a36ae 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2310,6 +2310,25 @@ Miscellaneous controller provides 3 interface files. If two misc resources (res_
         Limits can be set higher than the capacity value in the misc.capacity
         file.
 
+  misc.events
+	A read-only flat-keyed file which exists on non-root cgroups.
+	The following entries are defined.  Unless specified otherwise,
+	a value change in this file generates a file modified event.
+
+	Note that all fields in this file are hierarchical and the
+	file modified event can be generated due to an event down the
+	hierarchy. For the local events at the cgroup level see
+	misc.events.local.
+
+	  max
+		The number of times the cgroup's resource usage was
+		about to go over the max boundary.
+
+  misc.events.local
+	Similar to misc.events but the fields in the file are local
+	to the cgroup i.e. not hierarchical. The file modified event
+	generated on this file reflects only the local events.
+
 Migration and Ownership
 ~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
1.8.3.1


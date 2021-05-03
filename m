From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/5] docs/cgroup: add entry for cgroup.kill
Date: Mon,  3 May 2021 16:39:20 +0200
Message-ID: <20210503143922.3093755-2-brauner@kernel.org>
References: <20210503143922.3093755-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620052821;
        bh=M4EXOTfvJcdiJj/6VcTRH46aBcRh/Z514kkpJDLLnpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOPUaVmV7dXMqP/eXQfQruUy5nZLWkamI+xh/KER6jdUiKF/sqT9lllnwmkeoV99M
         PjmuSrZWIJTLqLxXJQqSWFFFS9fnxxxLKwMctaFLO1fp0WKGZ2POLtaRvv0D1tKtu0
         mN4uKC1qlWbrgEff0Jy44ov8s2h0ETyBa4eDIxewN41dlcqLtMFpXDCYkClHLBK8d4
         d4VwNQxcllqyiHuMStQ7BnuC30KKuPhUWQy9343Qg1zlV5WJU5/gmA8L+rDY9/v/st
         915nJx+S2U4m0o7O3scjrR8Ut44itZCsspnpp6Nkd58p2ZAy2LPpKMuOWXC8xtKuPS
         HWdw7AwC5GdLA==
In-Reply-To: <20210503143922.3093755-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Give a brief overview of the cgroup.kill functionality.

Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v2 */
- Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
  - Drop sentence that mentions combined useage of cgroup.kill and
    cgroup.freezer.
---
 Documentation/admin-guide/cgroup-v2.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 64c62b979f2f..6adc749d863e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -949,6 +949,21 @@ All cgroup core files are prefixed with "cgroup."
 	it's possible to delete a frozen (and empty) cgroup, as well as
 	create new sub-cgroups.
 
+  cgroup.kill
+	A write-only single value file which exists in non-root cgroups.
+	The only allowed value is "1".
+
+	Writing "1" to the file causes the cgroup and all descendant cgroups to
+	be killed. This means that all processes located in the affected cgroup
+	tree will be killed via SIGKILL.
+
+	Killing a cgroup tree will deal with concurrent forks appropriately and
+	is protected against migrations.
+
+	In a threaded cgroup, writing this file fails with EOPNOTSUPP as
+	killing cgroups is a process directed operation, i.e. it affects
+	the whole thread-group.
+
 Controllers
 ===========
 
-- 
2.27.0


From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 2/5] docs/cgroup: add entry for cgroup.kill
Date: Sat,  8 May 2021 14:15:39 +0200
Message-ID: <20210508121542.1269256-2-brauner@kernel.org>
References: <20210508121542.1269256-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620476155;
        bh=Z3np8vRR6Fe/+PrLZCrWi/n6U1UYxoqdr9Au8VeyDl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKCG7guD+GJ4pJvZCC7qAcNUTiikvbcWJEM/6HwdG0UqSf8PaVtC/hhRp9J7rCXoD
         BNuSFJXgdL9qcKPkz+rO/5a5jtPLPmkqitnK6IUof7iM7EM6qfEwTboEKPIS4A4cuJ
         P+4ZwZ0X72QZHsOgFgEuUf9rkdHkvlryoGSB9hKoyzHW+mvvmgEG2CQqX9HEKq6bH1
         iZq0DozKQYj46tG8wUD00hM1RtHMIlVorW3OVclJ+GPno1N444rnqqfkIvckNl06h0
         dvIGTSAYsF76e0HoVbAdOPpVpukFidr1H/8vuRHfClqvc9uA1Ml+SyqUAG0/wqbMrF
         V1jDyDxgWUQbw==
In-Reply-To: <20210508121542.1269256-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Give a brief overview of the cgroup.kill functionality.

Link: https://lore.kernel.org/r/20210503143922.3093755-2-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v2 */
- Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
  - Drop sentence that mentions combined useage of cgroup.kill and
    cgroup.freezer.

/* v3 */
unchanged
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


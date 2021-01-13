From: Li Feng <lifeng2221dd1-ytc+IHgoah3M1kAEIRd3EQ@public.gmane.org>
Subject: [PATCH] cgroup: Remove stale comments
Date: Wed, 13 Jan 2021 14:29:29 +0800
Message-ID: <20210113062929.303858-1-lifeng2221dd1@zoho.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Feng <lifeng2221dd1-ytc+IHgoah3M1kAEIRd3EQ@public.gmane.org>

The function "cgroup_mount" had beed removed, remove related comments
to prevent confusion.

Related commit:90129625d9203a917f(cgroup: start switching to fs_context)

Signed-off-by: Li Feng <lifeng2221dd1-ytc+IHgoah3M1kAEIRd3EQ@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 613845769103..493547b4941c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2139,7 +2139,6 @@ static void cgroup_kill_sb(struct super_block *sb)
 	/*
 	 * If @root doesn't have any children, start killing it.
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
-	 * cgroup_mount() may wait for @root's release.
 	 *
 	 * And don't kill the default root.
 	 */
-- 
2.25.1



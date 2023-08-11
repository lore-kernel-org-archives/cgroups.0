From: Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>
Subject: [PATCH] =?UTF-8?q?cgroup:=20cgroup:=20Remove=20unnecessary=20?= =?UTF-8?q?=E2=80=98NULL=E2=80=99=20values=20from=20res?=
Date: Fri, 11 Aug 2023 09:20:44 -0000 (UTC)
Message-ID: <20230813015142.3095-1-kunyu@nfschina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Sun, 13 Aug 2023 09:51:42 +0800
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>

res is assigned first, so it does not need to initialize the assignment.

Signed-off-by: Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cdda2a147d6b..3a8802921bcb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1419,7 +1419,7 @@ static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
 static struct cgroup *
 current_cgns_cgroup_from_root(struct cgroup_root *root)
 {
-	struct cgroup *res = NULL;
+	struct cgroup *res;
 	struct css_set *cset;
 
 	lockdep_assert_held(&css_set_lock);
-- 
2.18.2


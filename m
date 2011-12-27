From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: add sparse annotation to cgroup_iter_start() and cgroup_iter_end()
Date: Tue, 27 Dec 2011 07:46:26 +0200
Message-ID: <1324964786-19052-2-git-send-email-kirill@shutemov.name>
References: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324964786-19052-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
---
 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 98990dd..cbbc61d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2854,6 +2854,7 @@ static void cgroup_enable_task_cg_lists(void)
 }
 
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
+	__acquires(css_set_lock)
 {
 	/*
 	 * The first time anyone tries to iterate across a cgroup,
@@ -2893,6 +2894,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 }
 
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it)
+	__releases(css_set_lock)
 {
 	read_unlock(&css_set_lock);
 }
-- 
1.7.7.3

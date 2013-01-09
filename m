From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3.4 2/2] cgroup: Fix use after free of cgrp (cgrp->css_sets)
Date: Wed,  9 Jan 2013 13:11:26 +0100
Message-ID: <1357733486-1742-3-git-send-email-hdegoede@redhat.com>
References: <1357733486-1742-1-git-send-email-hdegoede@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357733486-1742-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Running a 3.4 kernel + Fedora-18 (systemd) userland on my Allwinner A10
(arm cortex a8), I'm seeing repeated, reproducable list_del list corruption
errors when build with CONFIG_DEBUG_LIST, and the backtrace always shows
free_css_set_work as the function making the problematic list_del call.

I've tracked this doen to a use after free of the cgrp struct, specifically
of the cgrp->css_sets list_head, which gets cleared by free_css_set_work.

Since free_css_set_work runs form a workqueue, it is possible for it to not be
done with clearing the list when the cgrp gets free-ed. To avoid this the code
adding the links increases cgrp->count, and the freeing code running from the
workqueue decreases cgrp->count *after* doing list_del, and then if the count
goes to 0 calls cgroup_wakeup_rmdir_waiter().

However cgroup_rmdir() is missing a check for cgrp->count != 0, causing it
to still continue with the rmdir (which leads to the free-ing of the cgrp),
before free_css_set_work is done. Sometimes the free-ed memory is re-used
before free_css_set_work gets around to unlinking link->cgrp_link_list,
triggering the list_del list corruption messages.

This patch fixes this by properly checking for cgrp->count != 0 and waiting
for the cgroup_rmdir_waitq in that case.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 59e711a..78c7a6f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4022,7 +4022,7 @@ again:
 		return -EBUSY;
 	}
 	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
-	if (!cgroup_clear_css_refs(cgrp)) {
+	if (!cgroup_clear_css_refs(cgrp) || atomic_read(&cgrp->count) != 0) {
 		mutex_unlock(&cgroup_mutex);
 		/*
 		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
-- 
1.8.0.2

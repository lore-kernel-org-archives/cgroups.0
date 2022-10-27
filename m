From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: [RFC][PATCH v2 21/31] timers: cgroup: Use del_timer_shutdown() before freeing timer
Date: Thu, 27 Oct 2022 11:05:46 -0400
Message-ID: <20221027150929.173042402@goodmis.org>
References: <20221027150525.753064657@goodmis.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: "Steven Rostedt (Google)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

Before a timer is freed, del_timer_shutdown() must be called.

Link: https://lore.kernel.org/all/20220407161745.7d6754b3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org/

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steven Rostedt (Google) <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7f486677ab1f..4b15a481ca2c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1669,7 +1669,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		cfile->kn = NULL;
 		spin_unlock_irq(&cgroup_file_kn_lock);
 
-		del_timer_sync(&cfile->notify_timer);
+		del_timer_shutdown(&cfile->notify_timer);
 	}
 
 	kernfs_remove_by_name(cgrp->kn, cgroup_file_name(cgrp, cft, name));
-- 
2.35.1

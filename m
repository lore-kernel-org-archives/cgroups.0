From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could return
 -errno after success
Date: Thu, 29 Mar 2012 09:26:20 -0700
Message-ID: <20120329162620.GD28941@google.com>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
 <20120329160433.GC28941@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TKti6UNZknNxGqGtUCWL9LbI+E7XyhqySl9fzd8Cz+I=;
        b=Qz4NXdjl+YeQVy28SmqcImDdobklFZL4FBsctzprApM5h1eWFkoR0jp817uPBRAvzi
         Kr1OPH5lG50Xsxz4sgfoupMkBavUgZ7TPmGr+u9mjwKY/g6INiQSTV6toV7QD+dW8b5/
         cKcR+NOh2lFgQZ66mLKuYIkS4+3f73eABtv2vHu/zw7YTMU1qLM7OgGuPkUhVYBfab0t
         v6OlZGjcV3drtsGk6x/CGmw7Ah4de9Agi2wpvMJhgxEjMf/fItb6X3/DZ5hAwzIjT8qr
         6JP4NpiFXTo0Fsgus6yrR5J0WAtZQcFSKGTKEc+vYo0mXqdTJxlk3+2xhoFCbsJfwPc3
         Sxlg==
Content-Disposition: inline
In-Reply-To: <20120329160433.GC28941-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

61d1d219c4 "cgroup: remove extra calls to find_existing_css_set" made
cgroup_task_migrate() return void.  An unfortunate side effect was
that cgroup_attach_task() was depending on that function's return
value to clear its @retval on the success path.  On cgroup mounts
without any subsystem with ->can_attach() callback,
cgroup_attach_task() ended up returning @retval without initializing
it on success.

For some reason, gcc failed to warn about it and it didn't cause
cgroup_attach_task() to return non-zero value in many cases, probably
due to difference in register allocation.  When the problem
materializes, systemd fails to populate /systemd cgroup mount and
fails to boot.

Fix it by initializing @retval to zero on declaration.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
LKML-Reference: <alpine.LNX.2.00.1203282354440.25526-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
---
Jiri, can you please confirm the fix?

Thanks.

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f4ea4b6..ed64cca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1883,7 +1883,7 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
  */
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
-	int retval;
+	int retval = 0;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;

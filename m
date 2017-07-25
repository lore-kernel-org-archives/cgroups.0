From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.14] cgroup: add comment to
 cgroup_enable_threaded()
Date: Tue, 25 Jul 2017 13:22:26 -0400
Message-ID: <20170725172226.GD3216015@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-2-git-send-email-longman@redhat.com>
 <20170722134358.GB3329631@devbig577.frc2.facebook.com>
 <20170723121826.GC1498614@devbig577.frc2.facebook.com>
 <c2637f47-3e90-a322-f84b-0c913da14977@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qFBveH/j68bIonXU0y718IbDmMhkPf/TiMtlE+R/7dU=;
        b=q8MEROTaMesxbwnOYez2Dfo7DsHqrhTaCz9I3J1ovX8FXIhPf2798KAiZm0070CAo3
         9mGVRhvkYBedaVrCcEFgh9X/zprmlMTnvBypmt73vjWKbdqDnBO5ZB28um1PgL+0ZTiU
         iEJxJFJ3zOhH5NhrZ6TjU7lc7nyOgk7SeP/hV0stOFUH1r/1Hu8b6jvghdPz1SuS9Ai1
         P03/l4ZwdPzJIyc6iVD3NBdZIlQuVc0dAAm5EIq1KnYww+fDtbZ7tlQTltHE2UTY6WIU
         W3jhvr9RujGWF7WZRc30uUzxvJ6J4le1kCydHKBBYoKipinpwUTEX+Ow8tatbZnmPwID
         8t+Q==
Content-Disposition: inline
In-Reply-To: <c2637f47-3e90-a322-f84b-0c913da14977-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

From c705a00d77457b44ba3790fdf0627ecb8593a254 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 25 Jul 2017 13:20:18 -0400

Explain cgroup_enable_threaded() and note that the function can never
be called on the root cgroup.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Hello, Waiman.

Good point.  Added comment explaining what's going on.  Applying the
patch to cgroup/for-4.14.

Thanks.

 kernel/cgroup/cgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e0a558c..85f6a11 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3129,6 +3129,15 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+/**
+ * cgroup_enable_threaded - make @cgrp threaded
+ * @cgrp: the target cgroup
+ *
+ * Called when "threaded" is written to the cgroup.type interface file and
+ * tries to make @cgrp threaded and join the parent's resource domain.
+ * This function is never called on the root cgroup as cgroup.type doesn't
+ * exist on it.
+ */
 static int cgroup_enable_threaded(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-- 
2.9.3

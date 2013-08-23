From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL RESEND] cgroup fixes for v3.11-rc6
Date: Fri, 23 Aug 2013 11:51:15 -0400
Message-ID: <20130823155115.GF3277@htj.dyndns.org>
References: <20130823154813.GE3277@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0eOldhIe6o0jOc5hFpqLm1yGQHHFQYvgGLiWooJ4ytk=;
        b=Zx4xYaB3F330SrQmz9A9xL7vLJueg7rsBcCG0JK5ywuX1aTqpUuuxPeAJ22n56yD+z
         dthqRsSOggog0eRV3tA+HM9/QAnlzZL9HES53Ix/9pA7mwV1XoOMY7VpyDHx1WPIgRya
         THClQLyI9PKWaaXuatd0PhRzc/riONsFfIZEs1wSWwfo6zOtgRJmj8j8B9b8jDnFqxzA
         U9vOQG5Uqg5bLF+/bhtToagKQLbE4eNqI+L2dz6ZTT1oQmoWyh3il/q9O2CC5aME3IqS
         /2zuJA05CCToiXUIqk4wG6v6NO6hC5ErLCfd5ZTtJEIiSoe1haHzI2/InmFcLA63KfwC
         oOww==
Content-Disposition: inline
In-Reply-To: <20130823154813.GE3277-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(forgot to cc lkml, resending, no content change)

Hello, Linus.

A late fix for cgroup.  This fixes a behavior regression visible to
userland which was created by a commit merged during -rc1.  While the
behavior change isn't too likely to be noticeable, the fix is
relatively low risk and we'll need to backport it through -stable
anyway if the bug gets released.

The fix is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-fixes

for you to fetch changes up to 1c09b195d37fa459844036f429a0f378e70c3db6:

  cpuset: fix a regression in validating config change (2013-08-21 08:40:27 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cpuset: fix a regression in validating config change

 kernel/cpuset.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 010a008..ea1966d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -475,13 +475,17 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
-		goto out;
+	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress)) {
+		if (!cpumask_empty(cur->cpus_allowed) &&
+		    cpumask_empty(trial->cpus_allowed))
+			goto out;
+		if (!nodes_empty(cur->mems_allowed) &&
+		    nodes_empty(trial->mems_allowed))
+			goto out;
+	}
 
 	ret = 0;
 out:

--
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.14] cgroup: short-circuit
 cset_cgroup_from_root() on the default hierarchy
Date: Wed, 2 Aug 2017 15:39:00 -0700
Message-ID: <20170802223900.GN2311718@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=aqhZFrIKDhGY3MbLN/ga7AtQXBNHREjl/J9v8vey4zE=;
        b=LegtKVAGOuBPzqqFZfOiITgY0P5Pl9+1Pk0H572axbI7HSCXA269+R9Mz/2dcYBrTJ
         WrlKriKo1AN/yYFC7ebi7tqDeczyVFwjSe0jlfvpnHlojtmww3IkWrIPJ0fc6QJb+VSf
         LuXARdnG7RS5BtKBE4nV+XRX13UhvQdG2fNObMjHaLwK+ngGreUc1iMRcKl13t+JYSNO
         OX5G6IpdrXoSLmO7LyXl/11FDqncS2bWSFslLXFrbCrpXxS9CDY3r+orEEwzygY1CxHs
         9XUec5YVFq/LwhtkZHBWZfK83CL4xZmctbdftn9FOxqyVwTCtN0qOzjOFGFCU3pXgm1m
         4sIg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Each css_set directly points to the default cgroup it belongs to, so
there's no reason to walk the cgrp_links list on the default
hierarchy.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Minor optimization.  Applying to cgroup/for-4.14.

Thanks.

 kernel/cgroup/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1311,6 +1311,8 @@ static struct cgroup *cset_cgroup_from_r
 
 	if (cset == &init_css_set) {
 		res = &root->cgrp;
+	} else if (root == &cgrp_dfl_root) {
+		res = cset->dfl_cgrp;
 	} else {
 		struct cgrp_cset_link *link;
 

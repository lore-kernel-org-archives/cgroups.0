From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3 cgroup/for-3.19] cgroup: add
 cgroup_subsys->css_e_css_changed()
Date: Mon, 17 Nov 2014 15:57:34 -0500
Message-ID: <20141117205734.GB23126@htj.dyndns.org>
References: <20141117205652.GA23126@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5BjUCTRz6RuqYWq/2fxzhEOkXyKqZJrF7NB90FYbfEA=;
        b=SzZIxEzUAfcqWqMEQzvrZr9JFGAT8/dO6+of250qZfjKYZzBuvtb+0b+7zYfeVhkNm
         8eJFFy97O3Lk8GigOi6ePfeovFkN2EcHZ3m6tzk/2TLDA6OrsKTBgh/zmOmI0dlLroiP
         m36D8xOc12NR9aDuGK4riJktgrwmKwc34pNQhDafm8bAbZi4sYP3J/jAmDH5qukzVHzg
         53gAjETp4BSp/OdJ3SWgKSu3tCJhRmfjY3lFlvfqndWEqCCdePkPRc/oO+5FvbZ7WUJd
         hBHl1fUYhNfN5VXbiz9bfAEnMffcYixnaWBQQUlTmt0Xl5y1X78NT0LxRh3o0pqiXxW+
         6JWQ==
Content-Disposition: inline
In-Reply-To: <20141117205652.GA23126-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Add a new cgroup_subsys operatoin ->css_e_css_changed().  This is
invoked if any of the effective csses seen from the css's cgroup may
have changed.  This will be used to implement cgroup writeback
support.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -615,6 +615,7 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_subsys_state *css,
 			  struct cgroup_taskset *tset);
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2836,6 +2836,24 @@ static ssize_t cgroup_subtree_control_wr
 		}
 	}
 
+	/*
+	 * The effective csses of all the descendants (excluding @cgrp) may
+	 * have changed.  Subsystems can optionally subscribe to this event
+	 * by implementing ->css_e_css_changed() which is invoked if any of
+	 * the effective csses seen from the css's cgroup may have changed.
+	 */
+	for_each_subsys(ss, ssid) {
+		struct cgroup_subsys_state *this_css = cgroup_css(cgrp, ss);
+		struct cgroup_subsys_state *css;
+
+		if (!ss->css_e_css_changed || !this_css)
+			continue;
+
+		css_for_each_descendant_pre(css, this_css)
+			if (css != this_css)
+				ss->css_e_css_changed(css);
+	}
+
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:

From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: Skip subtree root in cgroup_update_dfl_csses()
Date: Wed, 27 Jul 2022 20:58:15 -0400
Message-ID: <20220728005815.1715522-2-longman@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658969922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaSdAy4qMc+i3X3/uhcqoqHr76wuTtjP8hQcmc/LmaQ=;
        b=FKN4GWOSqWib36POdqvBs3gH49rj+NhT+EO1w2ECm0ckvNf1h70b2McF2sqzdC+C4wM5C4
        IfiL3wuzWTIUNGs8jgaEipyETAIb8JXdDU+DOwNVR6yQYGxDTRz8oyjGNj5jG9UnohzVLr
        aBxcp7H9XLEj6FSH2iP3tBEkcFhmGps=
In-Reply-To: <20220728005815.1715522-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The cgroup_update_dfl_csses() function updates css associations when a
cgroup's subtree_control file is modified. Any changes made to a cgroup's
subtree_control file, however, will only affect its descendants but not
the cgroup itself. So there is no point in migrating csses associated
with that cgroup. We can skip them instead.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 13c8e91d7862..1151ff44d578 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2960,6 +2960,15 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		struct cgrp_cset_link *link;
 
+		/*
+		 * As cgroup_update_dfl_csses() is only called by
+		 * cgroup_apply_control(). The csses associated with the
+		 * given cgrp will not be affected by changes made to
+		 * its subtree_control file. We can skip them.
+		 */
+		if (dsct == cgrp)
+			continue;
+
 		list_for_each_entry(link, &dsct->cset_links, cset_link)
 			cgroup_migrate_add_src(link->cset, dsct, &mgctx);
 	}
-- 
2.31.1


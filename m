From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 2/2] cgroup: reset css on destruction
Date: Tue, 1 Mar 2016 14:13:13 +0300
Message-ID: <92b11b89791412df49e73597b87912e8f143a3f7.1456830735.git.vdavydov@virtuozzo.com>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

An associated css can be around for quite a while after a cgroup
directory has been removed. In general, it makes sense to reset it to
defaults so as not to worry about any remnants. For instance, memory
cgroup needs to reset memory.low, otherwise pages charged to a dead
cgroup might never get reclaimed. There's ->css_reset callback, which
would fit perfectly for the purpose. Currently, it's only called when a
subsystem is disabled in the unified hierarchy and there are other
subsystems dependant on it. Let's call it on css destruction as well.

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cc40463e7b69..2ef78912c996 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5138,6 +5138,8 @@ static void kill_css(struct cgroup_subsys_state *css)
 	 * See seq_css() for details.
 	 */
 	css_clear_dir(css, NULL);
+	if (css->ss->css_reset)
+		css->ss->css_reset(css);
 
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
-- 
2.1.4

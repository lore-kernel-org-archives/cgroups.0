From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 11:25:30 -0400
Message-ID: <1440775530-18630-5-git-send-email-tj@kernel.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QGp+P8VLo0qnjQrYLPNuRn0rYr5XJnr70Kh6j2+Kq0Q=;
        b=GEOmUmMc2BZ8B+2YNEgPWAWy1Du926N1wz0HVvTdtuOhmfX4GNzWCcMvXkPM8Xovq2
         HIYHX/05yZ0WhnLqLuS1M+PfCDJ3F1ezIe+SC9ivPidm+ruj/ebg9NL+Crd/ztE17smJ
         xztxKRgikcMPWitcJwUAJBGGPqYEuYchXlh+Qy8z61r3tD3x3oMpKxaAm7xHvwxliE4t
         YL/cqp8bIXJKEVCvk5zzfnh8PHMZBJnNAQ0CFoPWLk225glbIUP22YY4+Frc7Zu44ta/
         Uz0wqdQSMiUVo+V7gM/vTbqOcXMMmITUwvYqN5dz2SpOrtFwAhkHGW+PsjJo1Op5mT21
         AkCA==
In-Reply-To: <1440775530-18630-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On the default hierarchy, all memory consumption will be accounted
together and controlled by the same set of limits.  Always enable
kmemcg on the default hierarchy.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c94b686..8a5dd01 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,13 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (ret)
 		return ret;
 
+	/* kmem is always accounted together on the default hierarchy */
+	if (cgroup_on_dfl(css->cgroup)) {
+		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Make sure the memcg is initialized: mem_cgroup_iter()
 	 * orders reading memcg->initialized against its callers
-- 
2.4.3

From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 1/5] make steal time's to-tick routine generic
Date: Thu,  2 Feb 2012 18:19:28 +0400
Message-ID: <1328192372-9551-2-git-send-email-glommer@parallels.com>
References: <1328192372-9551-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328192372-9551-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

In this patchset, I am exposing other data as ticks as well,
that are originally nanoseconds. Whether or not I should do it,
it is open for debate, and I am happy to drop this patch if we
decide not to. But right now this exists to support the
further patch that uses it.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/sched/core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b9be4ba..455810f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -850,13 +850,18 @@ EXPORT_SYMBOL_GPL(account_system_vtime);
 
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+static inline u64 nsec_to_tick(u64 nsec)
+{
+	if (unlikely(nsec > NSEC_PER_SEC))
+		return div_u64(nsec, TICK_NSEC);
+
+	return __iter_div_u64_rem(nsec, TICK_NSEC, &nsec);
+}
+
 #ifdef CONFIG_PARAVIRT
 static inline u64 steal_ticks(u64 steal)
 {
-	if (unlikely(steal > NSEC_PER_SEC))
-		return div_u64(steal, TICK_NSEC);
-
-	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
+	return nsec_to_tick(steal);
 }
 #endif
 
-- 
1.7.7.4

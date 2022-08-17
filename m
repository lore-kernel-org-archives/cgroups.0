From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH 6/9] mm/memcontrol: Replace the PREEMPT_RT conditionals
Date: Wed, 17 Aug 2022 18:27:00 +0200
Message-ID: <20220817162703.728679-7-bigeasy@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660753657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icKYkzOEkU10wqYj/AO1hlieqfsCO6opQIYue93MICc=;
        b=WUwxVW+uGIaO0szg7BxOu1wCzapAwDdXZYNPFf3kiI2xBtu8Es480fO/5T71TMYiQKTjL2
        Y5lWxIQqJ7x7BoSnhKaFZCzRhG7+8yHeQ5/tmMMThFpP2L1agJ4szHQY5JVMPUakod0IbE
        yIc6Gl3i758gJbuMjFnB7KmeyFMZ5xJ0mfQb/Ikck/iVjEeodnOdRlmZ/pr1p0eX5sgM4R
        M4paCBlURfexAPIOmkPU+fjGxjbUG3Dnqp+YkiX1A4mHylwtylhelH9PtNbQGgVaw0NytL
        acYvZri+GlxU9tb6ucjTkjxdrXJYjietaE0V6tqA4Eq9vmaflVkD4q9k8U95TQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660753657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icKYkzOEkU10wqYj/AO1hlieqfsCO6opQIYue93MICc=;
        b=500tFezzQJcGWrboXp6CHY0SHvmE+zDVA//pAXoHOs0Jh0IxU+Aa1gSbSy/Lv6WZU3qbC3
        94vz4DsO75E0UxCQ==
In-Reply-To: <20220817162703.728679-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Use VM_WARN_ON_IRQS_ENABLED() and preempt_disable/enable_nested() to
replace the CONFIG_PREEMPT_RT #ifdeffery.

Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5c..d35b6fa560f0a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -597,25 +597,18 @@ static u64 flush_next_time;
  */
 static void memcg_stats_lock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_disable();
-#else
-      VM_BUG_ON(!irqs_disabled());
-#endif
+	preempt_disable_nested();
+	VM_WARN_ON_IRQS_ENABLED();
 }
=20
 static void __memcg_stats_lock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_disable();
-#endif
+	preempt_disable_nested();
 }
=20
 static void memcg_stats_unlock(void)
 {
-#ifdef CONFIG_PREEMPT_RT
-      preempt_enable();
-#endif
+	preempt_enable_nested();
 }
=20
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
@@ -715,7 +708,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, en=
um node_stat_item idx,
 	 * interrupt context while other caller need to have disabled interrupt.
 	 */
 	__memcg_stats_lock();
-	if (IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
 		switch (idx) {
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
@@ -725,7 +718,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, en=
um node_stat_item idx,
 			WARN_ON_ONCE(!in_task());
 			break;
 		default:
-			WARN_ON_ONCE(!irqs_disabled());
+			VM_WARN_ON_IRQS_ENABLED();
 		}
 	}
=20
--=20
2.37.2


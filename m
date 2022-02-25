From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] mm/memcg: Only perform the debug checks on !PREEMPT_RT
Date: Sat, 26 Feb 2022 00:01:47 +0100
Message-ID: <Yhlf29/HqyNMOvGb@linutronix.de>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-4-bigeasy@linutronix.de>
 <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g@mail.gmail.com>
 <YhjzE/8LgbULbj/C@linutronix.de>
 <CALvZod48Tp7i_BbA4Um57m989iuFU5kSvbzLhSOUt23_CiWmjw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645830109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eLa2DAYUTcrHbqT9bu1hfoW/mNp9mXnBGQU+a1wSrFo=;
        b=HhsLwetpyGJFs2/zxUDRAIa9PNAY1BbeDq4Evc1MkFnyHxdsK9dPIGZ5i5aOL/PMFUKjcf
        xD98AWfMqYC4sVIM0nS2UWlgfRWFUBXx1ZiXNhbpk/zgbnSh2R1Z4uxpaqPorZdUW3xZLe
        5pZ5qdjKjGXuC8DcSaZFPEI6x30V3gqq1W7ACNSKObCrRYztOR4Nc/5oQFb/0Xy08JfL9r
        tGNADO9A++ZGKr3o27100KF1QLAqfdpLFTqKFaIfU/qwkTmyifIjzGlhCe7BK7fKUvChM4
        giy/Z1CmicL/cNNwdvrLbIVN0Ik56EGLc61frE66jHcxamyBurt3hhZWjsY1fA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645830109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eLa2DAYUTcrHbqT9bu1hfoW/mNp9mXnBGQU+a1wSrFo=;
        b=AsKrXs5arxs4uQjRegtTn8SRZAH3B1ZW9zg7LO4+o3PsHyiYRVcHitgVNhuY9ybY7Cuu9a
        OiRIivkR/0QEkzCg==
Content-Disposition: inline
In-Reply-To: <CALvZod48Tp7i_BbA4Um57m989iuFU5kSvbzLhSOUt23_CiWmjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On PREEMPT_RT interrupts and preemption is always enabled. The locking
function __memcg_stats_lock() always disabled preemptions. The recently
added checks need to performed only on !PREEMPT_RT where preemption and
disabled interrupts are used.

Please fold into:
	"Protect per-CPU counter by disabling preemption on PREEMPT_RT"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---

Andrew, if this getting to confused at some point, I can fold it myself
and repost the whole lot. Whatever works best for your.

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73832cd1e9da4..63287fd03250b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -741,7 +741,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	 * interrupt context while other caller need to have disabled interrupt.
 	 */
 	__memcg_stats_lock();
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
 		switch (idx) {
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
-- 
2.35.1

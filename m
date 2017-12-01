From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling
Date: Fri, 1 Dec 2017 22:26:23 +0900
Message-ID: <201712012226.JAC87573.FLtJVOOOFFSMQH@I-love.SAKURA.ne.jp>
References: <20171130152824.1591-1-guro@fb.com>
        <20171201091425.ekrpxsmkwcusozua@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20171201091425.ekrpxsmkwcusozua@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko@kernel.org, guro@fb.com
Cc: linux-mm@vger.kernel.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, rientjes@google.com, akpm@linux-foundation.org, tj@kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Michal Hocko wrote:
> Recently added alloc_pages_before_oomkill gained new caller with this
> patchset and I think it just grown to deserve a simpler code flow.
> What do you think about this on top of the series?

I'm planning to post below patch in order to mitigate OOM lockup problem
caused by scheduling priority. But I'm OK with your patch because your patch
will not conflict with below patch.

----------
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2746a7..ef6e951 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3332,13 +3332,14 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 	*did_some_progress = 0;
 
 	/*
-	 * Acquire the oom lock.  If that fails, somebody else is
-	 * making progress for us.
+	 * Acquire the oom lock. If that fails, give enough CPU time to the
+	 * owner of the oom lock in order to help reclaiming memory.
 	 */
-	if (!mutex_trylock(&oom_lock)) {
-		*did_some_progress = 1;
+	while (!mutex_trylock(&oom_lock)) {
+		page = alloc_pages_before_oomkill(oc);
+		if (page)
+			return page;
 		schedule_timeout_uninterruptible(1);
-		return NULL;
 	}
 
 	/* Coredumps can quickly deplete all memory reserves */
----------

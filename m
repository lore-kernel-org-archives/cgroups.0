From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] sched/cputime: Expose cputime_adjust()
Date: Fri, 11 Aug 2017 09:37:52 -0700
Message-ID: <20170811163754.3939102-2-tj@kernel.org>
References: <20170811163754.3939102-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gySxqW+O+QGN22drLDu+FofXWirZzfKNPg/PA4ozvEc=;
        b=ZMXQxxeOyYqtxyiTJw8z2uls4+p8/pIxz0y5pk0IJXHwEbhCIFG9Z6dl+lFa2An//2
         E95rBrT5qYLYxT1yvRVIMfMzZ6pmmSFC9q66tW+wj5x8CRgUhp+h9bULaO0mTsETOlXH
         MLgr0O63s8Fe0IKt8j1d6cM56/E94j4KLbFo1RASwYtd+EADBQznRoJa2bYIfz4vNW+M
         4SWAXi5o/EpqMUJgpVS2/lfNYBIzTgD6IQ3dCDfZVy/W4Kw6fJf3fJdYMT+k2jGMcRl9
         tX2TvtZJR7o/ThyHyPPRsmkiU+xBjLLvCi3uERR9zDBcUco9UPo8Uprvm7H3c/AGzPxB
         Kp1w==
In-Reply-To: <20170811163754.3939102-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

Will be used by basic cgroup resource stat reporting later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/sched/cputime.h | 3 ++-
 kernel/sched/cputime.c        | 5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched/cputime.h b/include/linux/sched/cputime.h
index 4c5b973..9251044 100644
--- a/include/linux/sched/cputime.h
+++ b/include/linux/sched/cputime.h
@@ -53,7 +53,8 @@ static inline void task_cputime_scaled(struct task_struct *t,
 
 extern void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
-
+extern void cputime_adjust(struct task_cputime *curr, struct prev_cputime *prev,
+			   u64 *ut, u64 *st);
 
 /*
  * Thread group CPU time accounting.
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 6e3ea4a..3a8bfcc 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -585,9 +585,8 @@ static u64 scale_stime(u64 stime, u64 rtime, u64 total)
  *
  * Assuming that rtime_i+1 >= rtime_i.
  */
-static void cputime_adjust(struct task_cputime *curr,
-			   struct prev_cputime *prev,
-			   u64 *ut, u64 *st)
+void cputime_adjust(struct task_cputime *curr, struct prev_cputime *prev,
+		    u64 *ut, u64 *st)
 {
 	u64 rtime, stime, utime;
 	unsigned long flags;
-- 
2.9.3


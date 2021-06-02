From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/6] sched: Add get_current_state()
Date: Wed, 02 Jun 2021 15:12:29 +0200
Message-ID: <20210602133040.461908001@infradead.org>
References: <20210602131225.336600299@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=Sj4Xan1+3aJ6Po5iAXxX9E8AwNGjzz5eYxQ6hRhen0g=; b=hMlj520jMnvNI6O5tUqcyzOgHW
        EHiJoaUSJQ6hVJ7Wpebgbxf98jjwH5xRoh67t9mLVd2A/HfLxY2Yx4h5lqvgKDYtgGojEvu4IefSN
        3DS6NOM57KiQOuJ7YRpVuKxZsMsiHqnRArRHs23pjdvHMQBl6lq9QREaZLgYa75oH3MWB+gJ1tC1J
        +wH4gCxswnyNBmjCumjXo1vOZE8FBxAebh/yrQhXJi8Y54MOt/nDCRBdOX3lrbMZSfd4Wjc7Ev0IX
        oIeI/gLN/0oqtU5QOuXfbcGteiSWIxBhDz2ucFEF9xi8LFZyzr9Fj0M1df6hbsxkqYJsywFl4l0AK
        rwAquI9Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>

Remove yet another few p->state accesses.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 block/blk-mq.c        |    2 +-
 include/linux/sched.h |    2 ++
 kernel/freezer.c      |    2 +-
 kernel/sched/core.c   |    6 +++---
 4 files changed, 7 insertions(+), 5 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3891,7 +3891,7 @@ int blk_poll(struct request_queue *q, bl
 
 	hctx->poll_considered++;
 
-	state = current->state;
+	state = get_current_state();
 	do {
 		int ret;
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -212,6 +212,8 @@ struct task_group;
 
 #endif
 
+#define get_current_state()	READ_ONCE(current->state)
+
 /* Task command name length: */
 #define TASK_COMM_LEN			16
 
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -58,7 +58,7 @@ bool __refrigerator(bool check_kthr_stop
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	bool was_frozen = false;
-	long save = current->state;
+	unsigned int save = get_current_state();
 
 	pr_debug("%s entered refrigerator\n", current->comm);
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8273,15 +8273,15 @@ static inline int preempt_count_equals(i
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
+	unsigned int state = get_current_state();
 	/*
 	 * Blocking primitives will set (and therefore destroy) current->state,
 	 * since we will exit with TASK_RUNNING make sure we enter with it,
 	 * otherwise we will destroy state.
 	 */
-	WARN_ONCE(current->state != TASK_RUNNING && current->task_state_change,
+	WARN_ONCE(state != TASK_RUNNING && current->task_state_change,
 			"do not call blocking ops when !TASK_RUNNING; "
-			"state=%lx set at [<%p>] %pS\n",
-			current->state,
+			"state=%x set at [<%p>] %pS\n", state,
 			(void *)current->task_state_change,
 			(void *)current->task_state_change);
 



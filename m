From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
Date: Wed, 02 Jun 2021 15:12:28 +0200
Message-ID: <20210602133040.398289363@infradead.org>
References: <20210602131225.336600299@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=MWif++fv4mdk5pz9anYuixYupfO2/j1D7alWDQJKz5g=; b=PZEfx4wzuQSJBf0ChNzA/G63R0
        ZKT9gZ2ZXo46GZP12y+35WNUglFSn/+AsIoDlhUVJ4OA1knBv8GxnoX6r35r9TYFOwQXJL+GT6zqj
        SOiJTsA8fxnoYg1WbLdmvcLGA1dLmZTTlA6NUI5k9SypIOpnw/3KanuE9xZiqf24DN1LYkv3thoZZ
        TOLfdLugvC21E0bMM0KcU8XTsq29FNKGa/HQqwPNyCBSH1GG57AC43Gy2r+1Q1k7EJ2B2GUumvy3R
        Vq7/OmNCDOXlizjZ/Z/XESgbXt+WYhqjvxT/7AszT4TsZ+S498S8ahrTlfsB4TSLuHAElzGfYYYdx
        v7lZNMZw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>

When ran from the sched-out path (preempt_notifier or perf_event),
p->state is irrelevant to determine preemption. You can get preempted
with !task_is_running() just fine.

The right indicator for preemption is if the task is still on the
runqueue in the sched-out path.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/events/core.c |    7 +++----
 virt/kvm/kvm_main.c  |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
 		},
 	};
 
-	if (!sched_in && task->state == TASK_RUNNING)
+	if (!sched_in && current->on_rq) {
 		switch_event.event_id.header.misc |=
 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
+	}
 
-	perf_iterate_sb(perf_event_switch_output,
-		       &switch_event,
-		       NULL);
+	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
 }
 
 /*
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4869,7 +4869,7 @@ static void kvm_sched_out(struct preempt
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->state == TASK_RUNNING) {
+	if (current->on_rq) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}



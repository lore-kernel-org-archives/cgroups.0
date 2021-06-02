From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/6] sched,timer: Use __set_current_state()
Date: Wed, 02 Jun 2021 15:12:30 +0200
Message-ID: <20210602133040.524487671@infradead.org>
References: <20210602131225.336600299@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=ZM/OZzCTna+H0NVHgaZG9RysfqZrZbVctmrXuvKDhRg=; b=Y4KjVcAVs++u5aWG8t3gz7Zmdm
        2GCCs43oozUZx+EtBSVivOvona+vh800bFDlXP3+vZhGLq9LHKpyLPPoBAn1rRYCCcALnq2iBn3qi
        MaERsXXM6+x7+/J8899O1kiYvL9TAxD6Zljthg0HfcVxNIohePy8ytwNYVprNkPCZjTMttAfDdM5g
        5KwiCrJMDzwRbGhdMjmXxhzxS1ITsVDM6G31nZqJOA7KWsEk8nkmFZWwCwuPLepKXuKwII1/UGGIB
        +DR2n/OyDqazhheBKOtqI7M+p0fenDjIhPGAkcT4D/YDi1MNXCIEjbsoIuoh4Bzi5lhHvKvOR/Ja3
        YhspdwAA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/time/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1879,7 +1879,7 @@ signed long __sched schedule_timeout(sig
 			printk(KERN_ERR "schedule_timeout: wrong timeout "
 				"value %lx\n", timeout);
 			dump_stack();
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			goto out;
 		}
 	}



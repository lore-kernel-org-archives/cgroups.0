From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 03/10] sched/psi: move private helpers to sched/stats.h
Date: Mon,  8 Aug 2022 19:03:34 +0800
Message-ID: <20220808110341.15799-4-zhouchengming@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MhJX1xAuM+Dg2Au0JlwK8MVyZU4paj2H+YmQz1widm8=;
        b=ro7oTcXZNHFFdtiUu9akcDqIYcDZ2EV9Uc3qPLMtS5Nl3RGs9c/V+BXWCTw5CB33NH
         p8t5GdSJp+fWDaviDxFY1DCL23G1RudgkuGLQ9R8ib5w0nGwEVV3GtmqLlU6sCPtpXLD
         CWp/kZSPIXAA1zSVquXQAk9Ffs6pBsUXl5xlaRjfGXPyTgF/0i1fB4/TdwsnAdug2d9H
         H2iAB3R435PO5U8v7vj7FBU2C5HMp/HjttoeT+EnfkpwVTD2sF+4y2pcqjXi+MId6YjK
         gJDxMbw+Tz69NYobCSvgE+kxSVvJG/pLk6HmoX19v7yq18h4rKwXA87JUA9X1QNlPeqf
         jcZQ==
In-Reply-To: <20220808110341.15799-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Chengming Zhou <zhouchengming@bytedance.com>

This patch move psi_task_change/psi_task_switch declarations out of
PSI public header, since they are only needed for implementing the
PSI stats tracking in sched/stats.h

psi_task_switch is obvious, psi_task_change can't be public helper
since it doesn't check psi_disabled static key. And there is no
any user now, so put it in sched/stats.h too.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/psi.h  | 4 ----
 kernel/sched/stats.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index 89784763d19e..aa168a038242 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -18,10 +18,6 @@ extern struct psi_group psi_system;
 
 void psi_init(void);
 
-void psi_task_change(struct task_struct *task, int clear, int set);
-void psi_task_switch(struct task_struct *prev, struct task_struct *next,
-		     bool sleep);
-
 void psi_memstall_enter(unsigned long *flags);
 void psi_memstall_leave(unsigned long *flags);
 
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index baa839c1ba96..c39b467ece43 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -107,6 +107,10 @@ __schedstats_from_se(struct sched_entity *se)
 }
 
 #ifdef CONFIG_PSI
+void psi_task_change(struct task_struct *task, int clear, int set);
+void psi_task_switch(struct task_struct *prev, struct task_struct *next,
+		     bool sleep);
+
 /*
  * PSI tracks state that persists across sleeps, such as iowaits and
  * memory stalls. As a result, it has to distinguish between sleeps,
-- 
2.36.1


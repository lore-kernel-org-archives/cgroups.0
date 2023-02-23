From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v11 7/8] sched/core: Support latency priority with sched core
Date: Thu, 23 Feb 2023 20:10:40 +0100
Message-ID: <20230223191041.577305-8-vincent.guittot@linaro.org>
References: <20230223191041.577305-1-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFfq5teius6pAK1nmf1oSiYVaS3V8Wiqx9qF8KZNMCQ=;
        b=MJINS6Ehzxb0sA/shHfydBxkVARhkb5euAB6EGVMRuXxdAsAG6pDXdb4flSMzFT+yY
         PRjYJgKcy2c1kAx+kPy8dM5434vOLqdKjuKNeHCfiB8RKQbmGwyIuo4Ot0oXQb7muZ+l
         ZWC/DmvpqT63kO80J2s1A6myyM17DfUAmx3G55JMJo00DO8RkBo79sMzI6rv3ETm/bSg
         MZA8gNYLVzi9ZMwaLPg4IFzSrFXLkNnJk18xeVlUlJLothZxzfx19MCHKH5vD1Xot+6E
         jEnLaGltetRClluH4JSZ/6EniN60YkdoFAN5xk4I3XztP6jpTyMUAPpAM8IJgGi3E8Kx
         DmXQ==
In-Reply-To: <20230223191041.577305-1-vincent.guittot@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, parth@linux.ibm.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org
Cc: tj@kernel.org, qyousef@layalina.io, chris.hyser@oracle.com, patrick.bellasi@matbug.net, David.Laight@aculab.com, pjt@google.com, pavel@ucw.cz, qperret@google.com, tim.c.chen@linux.intel.com, joshdon@google.com, timj@gnu.org, kprateek.nayak@amd.com, yu.c.chen@intel.com, youssefesmat@chromium.org, joel@joelfernandes.org, Vincent Guittot <vincent.guittot@linaro.org>

Take into account wakeup_latency_gran() when ordering the cfs threads.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dc7570f43ebe..125a6ff53378 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11949,6 +11949,9 @@ bool cfs_prio_less(const struct task_struct *a, const struct task_struct *b,
 	delta = (s64)(sea->vruntime - seb->vruntime) +
 		(s64)(cfs_rqb->min_vruntime_fi - cfs_rqa->min_vruntime_fi);
 
+	/* Take into account latency offset */
+	delta -= wakeup_latency_gran(sea, seb);
+
 	return delta > 0;
 }
 #else
-- 
2.34.1


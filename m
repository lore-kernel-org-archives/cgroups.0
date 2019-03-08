From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v5 5/7] psi: track changed states
Date: Fri,  8 Mar 2019 10:43:09 -0800
Message-ID: <20190308184311.144521-6-surenb@google.com>
References: <20190308184311.144521-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=il6G9EezI/fMlmphYMEu+28c9gYVmi2vxGNvZesouDw=;
        b=tjwDUtiobdfgKZIH++c88OYAAvRoSWJh7qHVhtehwxLEwOeHNDrMa9pD/txBuYov3w
         tpzrN9TjmUTADYocTrzDBUrTEzZMD5HxdOt2a9GMDUUyolNa+9tkNacxhzz4BzCGherl
         syRewsKwbdO+CjBTIM8eUiUdE6wz2kpm1eSAGLgIQgktEKLIThfLDv6pApzc1QI2qg2G
         klbVSbS32HsJq1EW8loyLsAGIsXoVyECiiHpJGdzMYVVZC+CFimkx6LQx5a+oPhpNKl8
         ig2xUUTSab4ro2ljYGE9dES4jtTPH+8mmUAJ60foFbGMnp0WadQ2fjLC/SzkO0K98Oj8
         DU1A==
In-Reply-To: <20190308184311.144521-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

Introduce changed_states parameter into collect_percpu_times to track
the states changed since the last update.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 kernel/sched/psi.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 337a445aefa3..59e4e1f8bc02 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -210,7 +210,8 @@ static bool test_state(unsigned int *tasks, enum psi_states state)
 	}
 }
 
-static void get_recent_times(struct psi_group *group, int cpu, u32 *times)
+static void get_recent_times(struct psi_group *group, int cpu, u32 *times,
+			     u32 *pchanged_states)
 {
 	struct psi_group_cpu *groupc = per_cpu_ptr(group->pcpu, cpu);
 	u64 now, state_start;
@@ -218,6 +219,8 @@ static void get_recent_times(struct psi_group *group, int cpu, u32 *times)
 	unsigned int seq;
 	u32 state_mask;
 
+	*pchanged_states = 0;
+
 	/* Snapshot a coherent view of the CPU state */
 	do {
 		seq = read_seqcount_begin(&groupc->seq);
@@ -246,6 +249,8 @@ static void get_recent_times(struct psi_group *group, int cpu, u32 *times)
 		groupc->times_prev[s] = times[s];
 
 		times[s] = delta;
+		if (delta)
+			*pchanged_states |= (1 << s);
 	}
 }
 
@@ -269,10 +274,11 @@ static void calc_avgs(unsigned long avg[3], int missed_periods,
 	avg[2] = calc_load(avg[2], EXP_300s, pct);
 }
 
-static bool collect_percpu_times(struct psi_group *group)
+static void collect_percpu_times(struct psi_group *group, u32 *pchanged_states)
 {
 	u64 deltas[NR_PSI_STATES - 1] = { 0, };
 	unsigned long nonidle_total = 0;
+	u32 changed_states = 0;
 	int cpu;
 	int s;
 
@@ -287,8 +293,11 @@ static bool collect_percpu_times(struct psi_group *group)
 	for_each_possible_cpu(cpu) {
 		u32 times[NR_PSI_STATES];
 		u32 nonidle;
+		u32 cpu_changed_states;
 
-		get_recent_times(group, cpu, times);
+		get_recent_times(group, cpu, times,
+				&cpu_changed_states);
+		changed_states |= cpu_changed_states;
 
 		nonidle = nsecs_to_jiffies(times[PSI_NONIDLE]);
 		nonidle_total += nonidle;
@@ -313,7 +322,8 @@ static bool collect_percpu_times(struct psi_group *group)
 	for (s = 0; s < NR_PSI_STATES - 1; s++)
 		group->total[s] += div_u64(deltas[s], max(nonidle_total, 1UL));
 
-	return nonidle_total;
+	if (pchanged_states)
+		*pchanged_states = changed_states;
 }
 
 static u64 update_averages(struct psi_group *group, u64 now)
@@ -373,6 +383,7 @@ static void psi_avgs_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct psi_group *group;
+	u32 changed_states;
 	bool nonidle;
 	u64 now;
 
@@ -383,7 +394,8 @@ static void psi_avgs_work(struct work_struct *work)
 
 	now = sched_clock();
 
-	nonidle = collect_percpu_times(group);
+	collect_percpu_times(group, &changed_states);
+	nonidle = changed_states & (1 << PSI_NONIDLE);
 	/*
 	 * If there is task activity, periodically fold the per-cpu
 	 * times and feed samples into the running averages. If things
@@ -718,7 +730,7 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 
 	/* Update averages before reporting them */
 	mutex_lock(&group->avgs_lock);
-	collect_percpu_times(group);
+	collect_percpu_times(group, NULL);
 	update_averages(group, sched_clock());
 	mutex_unlock(&group->avgs_lock);
 
-- 
2.21.0.360.g471c308f928-goog


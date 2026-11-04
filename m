Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826739;
	b=xs1m33H77rkMB7XlYxKP4/tIy0R+ng66GKhxVS+T4cWmRxve5GMHNn/dV3HDDpQyuXGj
	 nbTjy/hOrSebWBVmIe9jHJaJ+W3+oPbrSz0FwCpH+ArfMctEDVhIPyG+C8vW6gh86L36E
	 QgFkiTbOHXjZNL1fcjSab1m6iMh9D1GLIdoh76/nG1maGFqaX18AJxdij0Pkk7oeBZF/z
	 9ztK7KWmH/yC9R0sg1XEgnPGVc5nqkYGYtgH1nQOvaZlQ94ZIQ8+r7bFMMrvUwmyn3gyP
	 wyg7BOslG55FfsAN2LXDdW0aQIWV/foENPMpCR+TogFAVGNDDM/SZSGQYd2BW5le/oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826739;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qxv6vM8ryUzruPuzUk++Focq1fvnTSAXs+Y18jC8YBA=;
	b=cC15PemNnYCyW9L07XwAjM2wMoyzriI/ns01zXt1+1QM9rtvexlHg/ufs7bxr0U+1eZv
	 4ZFrsoxihISZKBg0STRzEcEo8I01zkuQK3NnENiOAyhp8S5TKjalpLQJdOKTVfN0/lig5
	 PQVeh/0wL0brhLbqi4PNEPZgQ4JybY6ppEl7Ok9OCI5alOHWKytkSMrj0SadgjR0mM7am
	 zdp+0j5D+oGeOZP1rEgjg6Ej9Na0taYdQuq3ss/c7u3ZQGpxsqdVuxdHCXROOz7i3I6qJ
	 jZypc7bZNuPAxW1BMJ26AjsQH2LE6jIxYZerAsSMtueWpIG+R7x8rWKrf/e1/BgqPeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=jaUNrmkJ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D276082BD0;
	Wed,  4 Nov 2026 21:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1D276082BD0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=jaUNrmkJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826735;
	bh=qxv6vM8ryUzruPuzUk++Focq1fvnTSAXs+Y18jC8YBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaUNrmkJXGdqy1bURUkynr6mXoEPaiOC811I32D0iEeb+NB3e4VTDL/KdhAYFZztJ
	 3Ii7pW6li653j0y0e28TQja6rN/IrO0XxUI63aWaJT6rXCgN70SddnE69MglSXTFjY
	 M2DytjsXIC+Wjau02dFfCDowNzPad4pyxOjNS+X/1eCnK3yUJd+beFmHfHS9W7/kU9
	 ZmPSBQBPDX9fonfR0n1yZyGcQf9fFLDa/YpsgSwnN0TtI8E5HfxWg6RDnTaRRV2hyX
	 mHbqox/Jy8zgK+ufb38huE/aaTUudnOUqPfOZFT38whesPsJ6QUQurQBQy+rVrUXhN
	 skBe1X/3WwafA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRz2FZ1zLXh;
	Wed, 04 Nov 2026 16:12:15 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 17/21] cgroup/cpuset: Give back the bandwidth an attach did not move
Date: Wed,  4 Nov 2026 16:12:03 -0500
Message-Id: <20261104211207.1392343-18-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cpuset_can_attach() counts the bandwidth of every migrating deadline
task in sum_migrate_dl_bw, and cpuset_reserve_dl_bw() sets that sum
aside in the destination's root domain. The attach that follows moves
the bandwidth of each task that is still a deadline task, and nothing
answers for the reservation of one that is not: a task that left
SCHED_DEADLINE, or died, since it was counted moves none of it, and what
was set aside for it stays in the destination's total_bw. The root
domain then admits that much less, until the next rebuild of the
accounting.

A task that flips between SCHED_DEADLINE and SCHED_OTHER every
millisecond while it is moved in and out of a one-CPU partition root
leaves, in 200 moves, hundreds of thousands of units of a CPU behind, in
8-CPU VMs of v7.4-rc1 with the four deadline fixes of sched/urgent:
total_bw of the partition 52428 (its fair server) before, 367000 and
681572 after, in 2 VMs of 4.

Keep the tally of what the attach moves, and give the rest back once it
is through. The move says what it moved: cpuset_attach_task() reads the
root domain recorded for a task without the runqueue lock that
set_cpus_allowed_dl() decides under, so CPU hotplug moving the task to
another root domain in between, in dl_task_offline_migration(), would
leave the tally counting a move that did not happen and a reservation
standing for bandwidth no task of the destination holds.
set_cpus_allowed_dl() writes the bandwidth it hands to the root domain
of the new mask into the affinity context, and the tally takes it from
there: the offer of the reservation rests on the unlocked read, the
count on what the move did. With this change and the previous patch,
total_bw of the partition is 52428 after those 200 moves, in 6 VMs of 6.

Found by the randomized case of the selftest added earlier in this
series, which caught a fair server it could no longer lower in a
partition root with no room left.

Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           |  3 ++-
 kernel/cgroup/cpuset-internal.h |  2 ++
 kernel/cgroup/cpuset.c          | 39 ++++++++++++++++++++++++++-------
 kernel/sched/core.c             | 11 +++++++---
 kernel/sched/deadline.c         |  5 ++++-
 kernel/sched/sched.h            |  2 ++
 6 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 52b450d212c6..24e28f2819d9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1961,7 +1961,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
  */
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
-					const struct cpumask *new_mask);
+					const struct cpumask *new_mask,
+					u64 *moved);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 1ba94ffaff9d..52fc09f905c3 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -174,6 +174,8 @@ struct cpuset {
 	int nr_migrate_dl_tasks;
 	/* DL bandwidth that needs destination reservation for this attach. */
 	u64 sum_migrate_dl_bw;
+	/* Of that bandwidth, what the attach moved: the rest is given back. */
+	u64 sum_moved_dl_bw;
 	/*
 	 * CPU used for temporary DL bandwidth allocation during attach;
 	 * -1 if no DL bandwidth was allocated in the current attach.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5b8f1d9552a6..263db5c4c662 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3183,10 +3183,24 @@ static void clear_attach_data(struct llist_head *head, bool cancel)
 		if (cs->nr_migrate_dl_tasks) {
 			if (!cancel)
 				atomic_add(cs->nr_migrate_dl_tasks, &cs->nr_deadline_tasks);
-			else if (cs->dl_bw_cpu >= 0) /* && cancel */
-				dl_bw_free(cs->dl_bw_cpu, cs->sum_migrate_dl_bw);
+			/*
+			 * Give back the bandwidth the attach did not move:
+			 * all of the reservation when it is cancelled, and
+			 * what was set aside for the tasks that are no
+			 * longer deadline tasks otherwise. Theirs is
+			 * released by the class they left, from the root
+			 * domain that counts it.
+			 */
+			if (cs->dl_bw_cpu >= 0) {
+				u64 bw = cancel ? cs->sum_migrate_dl_bw :
+					 cs->sum_migrate_dl_bw - cs->sum_moved_dl_bw;
+
+				if (bw)
+					dl_bw_free(cs->dl_bw_cpu, bw);
+			}
 			cs->nr_migrate_dl_tasks = 0;
 			cs->sum_migrate_dl_bw = 0;
+			cs->sum_moved_dl_bw = 0;
 			cs->dl_bw_cpu = -1;
 		}
 	}
@@ -3338,19 +3352,28 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 			       subpartitions_cpus);
 	/*
 	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
-	 * deadline tasks cpuset_can_attach() counted: say so, so that this
-	 * task's bandwidth moves there with it.
+	 * deadline tasks cpuset_can_attach() counted: offer it, so that this
+	 * task's bandwidth moves there with it. A task that became a
+	 * deadline task since has nothing set aside, so it moves its
+	 * bandwidth only where the rest of the reservation covers it.
 	 */
-	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus))
+	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus) &&
+	    cs->sum_moved_dl_bw + task->dl.dl_bw <= cs->sum_migrate_dl_bw)
 		reserved = true;
 	/*
 	 * can_attach beforehand should guarantee that this doesn't
 	 * fail.  TODO: have a better way to handle failure here
 	 */
-	if (reserved)
-		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach));
-	else
+	if (reserved) {
+		u64 moved;
+
+		/* The move decides: the tally counts what it moved. */
+		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach,
+							  &moved));
+		cs->sum_moved_dl_bw += moved;
+	} else {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+	}
 
 	if (cpuset_v2() && !attach_ctx.mems_updated)
 		return;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0ff07258cf0c..120128032c15 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3271,16 +3271,21 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
  * The same, for a caller that has made room in the root domain of @new_mask
- * for the deadline bandwidth of @p: that bandwidth moves there with it.
+ * for the deadline bandwidth of @p: that bandwidth moves there with it, and
+ * @moved takes what the move counts there, 0 where it moved none.
  */
-int set_cpus_allowed_bw_reserved(struct task_struct *p, const struct cpumask *new_mask)
+int set_cpus_allowed_bw_reserved(struct task_struct *p,
+				 const struct cpumask *new_mask, u64 *moved)
 {
 	struct affinity_context ac = {
 		.new_mask  = new_mask,
 		.flags     = SCA_DL_BW_RESERVED,
 	};
+	int ret;
 
-	return __set_cpus_allowed_ptr(p, &ac);
+	ret = __set_cpus_allowed_ptr(p, &ac);
+	*moved = ac.dl_bw_moved;
+	return ret;
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7a58e78ac5ce..029ec2ba5a66 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3512,7 +3512,9 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * The bandwidth of a task whose move no one made room for stays
 	 * where it is counted, for the next rebuild of the accounting to
 	 * attribute, rather than leaving the root domain it moves to short
-	 * of what its tasks hold.
+	 * of what its tasks hold. @ctx tells the caller what moved: the
+	 * record of a task is read here, under its runqueue lock, and the
+	 * caller cannot keep a reservation for a move this decides against.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
 	    dl_task_needs_bw_move(p, ctx->new_mask)) {
@@ -3540,6 +3542,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
 		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
 		p->dl.dl_bw_gen = dl_bw_gen;
+		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
 
 	set_cpus_allowed_common(p, ctx);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3e5bc8b6f887..0d5908f58594 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2659,6 +2659,8 @@ extern const u32		sched_prio_to_wmult[40];
 struct affinity_context {
 	const struct cpumask	*new_mask;
 	struct cpumask		*user_mask;
+	/* Out: the deadline bandwidth the move counts in the new root domain. */
+	u64			dl_bw_moved;
 	unsigned int		flags;
 };
 
-- 
2.47.3


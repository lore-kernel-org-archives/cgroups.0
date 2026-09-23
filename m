Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDFB3F1640
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139720; cv=none; b=BkF8ICpJsOF8slv0j3XjljTpPtdsQvTpW8ERJbErlGlZTYixfWbs58N5HP/OxJEp9dz/Z55Ww3sA0X0wN32vUxyabL4NpvCkmZvVh5me3M7BfIb2V+cq6dYLn3wyt3hix7uAMg+OyWmSChUGOrVYcIN+1oFyEDqaQRLje/Ol2Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139720; c=relaxed/simple;
	bh=lpQPKCnPQl6ljeMVZXOHFfvX7z1b0IqJGif01Q01Pdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ij7XE5HOX0i62rcTEPvPuHOejvLcwPxolEvmj53hEL3aQPjRmCoDdlqthylfR0jXs+LwsxFNwCa21w5wZL9ZF89RIs8ENWdv8bBgsJsSI+M67bqhG/VIebOT37f5TSoQcGvxCJ/Ch0Tdm02W2HbKMro1HjUJGvzFW856QZlV0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=shi8VNgR; arc=none smtp.client-ip=91.218.175.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="shi8VNgR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lpQPKCnPQl6ljeMVZXOHFfvX7z1b0IqJGif01Q01Pdw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790139714; v=1; x=1790744514;
 b=shi8VNgR+hgut47IF/WKbkGGJZyf8THYX+M2LDnbR2Zykio5QPZuYpbsJoVwtHEogIGy+aj9
 0ZSg6QPL73q72HYzuki9p49YLA+dFS0j46lt7C3TrpkNhtllC4D/q1uF9Axo5BbIkT9p4WTQAli
 DtgriqRv9joffATTAmaPIu30=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 688fd8a9e9dc672e;
	Wed, 23 Sep 2026 05:01:54 +0000
X-Mizu-Trace-ID: 688fd8a9e9dc672e
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] locking/selftests: add KUnit tests for lock holder tracking
Date: Tue, 22 Sep 2026 22:01:22 -0700
Message-ID: <320446364440ae5fa150f855afa2f0357eafb784.1790139577.git.shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790139577.git.shakeel.butt@linux.dev>
References: <cover.1790139577.git.shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add 16 KUnit tests that check task_nr_tracked_locks(current) always
equals the number of opted-in locks the task holds. They cover:

  - locks that did not opt in, which must not count
  - the mutex, rw_semaphore and percpu_rw_semaphore lock and trylock
    calls, including the killable, interruptible, freezable and io ones
  - downgrade_write(), the cleanup.h guards, and nested locks released
    out of order
  - the percpu_rwsem_release()/percpu_rwsem_acquire() hand-off
  - re-init clearing the opt-in

Five tests use a helper thread that holds a lock. They check that a
failed trylock does not count, that a lock taken right as the helper
releases it (usually through the slow path) counts exactly once, and
that each task has its own count.

Three cases cover what the opt-in changes besides the count: that an
opted-in but unheld lock still reads unlocked, which the sticky bit
would otherwise break for rwsem_is_locked() and its callers; that
*_track_holder() refuses a lock that is already held; and that the
non_owner rwsem calls warn and do not count. The last needs
CONFIG_DEBUG_LOCK_ALLOC, as without it they are plain down_read() and
up_read(), so it skips otherwise.

Tests compare against the count at the start of the test, not zero.

Passes on UML, x86_64, x86_64 with PROVE_LOCKING + DEBUG_MUTEXES +
DEBUG_RWSEMS (where the mutex fast path is compiled out), and x86_64
PREEMPT_RT:

  tools/testing/kunit/kunit.py run --kunitconfig=kernel/locking/ lockholder

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/locking/.kunitconfig       |   4 +
 kernel/locking/Makefile           |   1 +
 kernel/locking/lockholder_kunit.c | 741 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |  13 +
 4 files changed, 759 insertions(+)
 create mode 100644 kernel/locking/.kunitconfig
 create mode 100644 kernel/locking/lockholder_kunit.c

diff --git a/kernel/locking/.kunitconfig b/kernel/locking/.kunitconfig
new file mode 100644
index 000000000000..ed243843b8b0
--- /dev/null
+++ b/kernel/locking/.kunitconfig
@@ -0,0 +1,4 @@
+CONFIG_KUNIT=y
+CONFIG_SMP=y
+CONFIG_TRACK_LOCK_HOLDERS=y
+CONFIG_TRACK_LOCK_HOLDERS_KUNIT_TEST=y
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index a0945beb304c..d23b754df40f 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -10,6 +10,7 @@ CONTEXT_ANALYSIS_rwsem.o := y
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 obj-$(CONFIG_TRACK_LOCK_HOLDERS) += lockholder.o
+obj-$(CONFIG_TRACK_LOCK_HOLDERS_KUNIT_TEST) += lockholder_kunit.o
 
 # Avoid recursion lockdep -> sanitizer -> ... -> lockdep & improve performance.
 KASAN_SANITIZE_lockdep.o := n
diff --git a/kernel/locking/lockholder_kunit.c b/kernel/locking/lockholder_kunit.c
new file mode 100644
index 000000000000..6b3c3a66f7df
--- /dev/null
+++ b/kernel/locking/lockholder_kunit.c
@@ -0,0 +1,741 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for sleeping lock holder tracking: check that
+ * task_nr_tracked_locks(current) always equals the number of opted-in
+ * locks the task holds.
+ */
+#include <kunit/test.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/lockholder.h>
+#include <linux/mutex.h>
+#include <linux/percpu-rwsem.h>
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+
+struct lockholder_ctx {
+	struct mutex		tmutex;
+	struct mutex		tmutex2;
+	struct mutex		pmutex;
+	struct rw_semaphore	tsem;
+	struct rw_semaphore	tsem2;
+	struct rw_semaphore	psem;
+	struct percpu_rw_semaphore	tpcpu;
+	struct percpu_rw_semaphore	ppcpu;
+	bool			pcpu_ready;
+
+	/* Count at test start. Tests compare against it, not against zero. */
+	unsigned int		base;
+
+	/* Helper thread that holds a lock until told to release it. */
+	struct completion	helper_holds;
+	struct completion	helper_may_release;
+	struct completion	helper_done;
+	unsigned int		helper_depth_held;
+	unsigned int		helper_depth_after;
+};
+
+/* Check the count relative to the start of the test. */
+#define EXPECT_DEPTH(test, ctx, n)					\
+	KUNIT_EXPECT_EQ((test), (ctx)->base + (unsigned int)(n),	\
+			task_nr_tracked_locks(current))
+
+#define ASSERT_DEPTH(test, ctx, n)					\
+	KUNIT_ASSERT_EQ((test), (ctx)->base + (unsigned int)(n),	\
+			task_nr_tracked_locks(current))
+
+static int lockholder_init(struct kunit *test)
+{
+	struct lockholder_ctx *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	mutex_init(&ctx->tmutex);
+	mutex_init(&ctx->tmutex2);
+	mutex_init(&ctx->pmutex);
+	init_rwsem(&ctx->tsem);
+	init_rwsem(&ctx->tsem2);
+	init_rwsem(&ctx->psem);
+
+	mutex_track_holder(&ctx->tmutex);
+	mutex_track_holder(&ctx->tmutex2);
+	rwsem_track_holder(&ctx->tsem);
+	rwsem_track_holder(&ctx->tsem2);
+
+	KUNIT_ASSERT_EQ(test, 0, percpu_init_rwsem(&ctx->tpcpu));
+	if (percpu_init_rwsem(&ctx->ppcpu)) {
+		percpu_free_rwsem(&ctx->tpcpu);
+		KUNIT_ASSERT_TRUE(test, false);
+	}
+	ctx->pcpu_ready = true;
+	percpu_rwsem_track_holder(&ctx->tpcpu);
+
+	init_completion(&ctx->helper_holds);
+	init_completion(&ctx->helper_may_release);
+	init_completion(&ctx->helper_done);
+
+	ctx->base = task_nr_tracked_locks(current);
+	test->priv = ctx;
+	return 0;
+}
+
+static void lockholder_exit(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	if (ctx && ctx->pcpu_ready) {
+		percpu_free_rwsem(&ctx->tpcpu);
+		percpu_free_rwsem(&ctx->ppcpu);
+		ctx->pcpu_ready = false;
+	}
+}
+
+/* Locks that did not opt in are never counted. */
+static void untracked_locks_are_not_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	mutex_lock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+	mutex_unlock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_EXPECT_TRUE(test, mutex_trylock(&ctx->pmutex));
+	EXPECT_DEPTH(test, ctx, 0);
+	mutex_unlock(&ctx->pmutex);
+
+	down_read(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 0);
+	up_read(&ctx->psem);
+
+	down_write(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 0);
+	up_write(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	percpu_down_read(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+	percpu_up_read(&ctx->ppcpu);
+
+	percpu_down_write(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+	percpu_up_write(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static void tracked_mutex_is_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	mutex_lock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 0, mutex_lock_interruptible(&ctx->tmutex));
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 0, mutex_lock_killable(&ctx->tmutex));
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	mutex_lock_io(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_TRUE(test, mutex_trylock(&ctx->tmutex));
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static void tracked_rwsem_read_is_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	down_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 0, down_read_killable(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 0, down_read_interruptible(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 1, down_read_trylock(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static void tracked_rwsem_write_is_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	down_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+	up_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 0, down_write_killable(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_EQ(test, 1, down_write_trylock(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static void tracked_percpu_rwsem_is_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	percpu_down_read_freezable(&ctx->tpcpu, false);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_ASSERT_TRUE(test, percpu_down_read_trylock(&ctx->tpcpu));
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	percpu_down_write(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_write(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	scoped_guard(percpu_read, &ctx->tpcpu)
+		EXPECT_DEPTH(test, ctx, 1);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	scoped_guard(percpu_write, &ctx->tpcpu)
+		EXPECT_DEPTH(test, ctx, 1);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/*
+ * percpu_rwsem_release()/percpu_rwsem_acquire() move the count with the
+ * lock.
+ */
+static void percpu_rwsem_handover_moves_the_count(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	percpu_down_write(&ctx->tpcpu);
+	ASSERT_DEPTH(test, ctx, 1);
+
+	/* As if returning to user space with the lock held. */
+	percpu_rwsem_release(&ctx->tpcpu, _THIS_IP_);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	/* Take it back before releasing it. */
+	percpu_rwsem_acquire(&ctx->tpcpu, false, _THIS_IP_);
+	EXPECT_DEPTH(test, ctx, 1);
+
+	percpu_up_write(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/* The percpu read slow path, used right after a writer, is counted too. */
+static void percpu_rwsem_slow_read_path_is_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	/* A writer forces readers onto the slow path for a while. */
+	percpu_down_write(&ctx->tpcpu);
+	ASSERT_DEPTH(test, ctx, 1);
+	percpu_up_write(&ctx->tpcpu);
+	ASSERT_DEPTH(test, ctx, 0);
+
+	/*
+	 * rcu_sync stays non-idle for a grace period after a writer, so
+	 * this most likely uses the slow path.
+	 */
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_EXPECT_TRUE(test, percpu_down_read_trylock(&ctx->tpcpu));
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/* downgrade_write() keeps the lock held, so the count does not change. */
+static void downgrade_write_keeps_the_count(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	down_write(&ctx->tsem);
+	ASSERT_DEPTH(test, ctx, 1);
+
+	downgrade_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/* Tracked locks add up; untracked ones in between do not count. */
+static void nested_locks_stack(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	mutex_lock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+
+	mutex_lock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+
+	down_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 2);
+
+	down_write(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 2);
+
+	mutex_lock(&ctx->tmutex2);
+	EXPECT_DEPTH(test, ctx, 3);
+
+	down_read(&ctx->tsem2);
+	EXPECT_DEPTH(test, ctx, 4);
+
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 5);
+
+	percpu_down_read(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 5);
+
+	/* Release in a different order than taken. */
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 4);
+	percpu_up_read(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 4);
+	up_write(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 4);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 3);
+	up_read(&ctx->tsem2);
+	EXPECT_DEPTH(test, ctx, 2);
+	mutex_unlock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 2);
+	mutex_unlock(&ctx->tmutex2);
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/* cleanup.h guards are counted too. */
+static void guards_are_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	scoped_guard(mutex, &ctx->tmutex)
+		EXPECT_DEPTH(test, ctx, 1);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	scoped_guard(rwsem_read, &ctx->tsem)
+		EXPECT_DEPTH(test, ctx, 1);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	scoped_guard(rwsem_write, &ctx->tsem)
+		EXPECT_DEPTH(test, ctx, 1);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/*
+ * The helper thread takes a lock and records its own count. It is used to
+ * create contention and to check that counts are per task.
+ */
+enum helper_lock {
+	HELPER_TMUTEX,
+	HELPER_TSEM_WRITE,
+	HELPER_TPCPU_WRITE,
+};
+
+struct helper_arg {
+	struct lockholder_ctx	*ctx;
+	enum helper_lock	which;
+};
+
+static int lockholder_helper(void *data)
+{
+	struct helper_arg *arg = data;
+	struct lockholder_ctx *ctx = arg->ctx;
+
+	switch (arg->which) {
+	case HELPER_TMUTEX:
+		mutex_lock(&ctx->tmutex);
+		break;
+	case HELPER_TSEM_WRITE:
+		down_write(&ctx->tsem);
+		break;
+	case HELPER_TPCPU_WRITE:
+		percpu_down_write(&ctx->tpcpu);
+		break;
+	}
+
+	ctx->helper_depth_held = task_nr_tracked_locks(current);
+	complete(&ctx->helper_holds);
+
+	wait_for_completion(&ctx->helper_may_release);
+
+	switch (arg->which) {
+	case HELPER_TMUTEX:
+		mutex_unlock(&ctx->tmutex);
+		break;
+	case HELPER_TSEM_WRITE:
+		up_write(&ctx->tsem);
+		break;
+	case HELPER_TPCPU_WRITE:
+		percpu_up_write(&ctx->tpcpu);
+		break;
+	}
+
+	ctx->helper_depth_after = task_nr_tracked_locks(current);
+	complete(&ctx->helper_done);
+
+	/* Wait for kthread_stop(). */
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(HZ / 10);
+	return 0;
+}
+
+static struct task_struct *start_helper(struct kunit *test,
+					enum helper_lock which)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct helper_arg *arg;
+	struct task_struct *t;
+
+	arg = kunit_kzalloc(test, sizeof(*arg), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, arg);
+	arg->ctx = ctx;
+	arg->which = which;
+
+	t = kthread_run(lockholder_helper, arg, "lockholder_kunit");
+	KUNIT_ASSERT_FALSE(test, IS_ERR(t));
+
+	wait_for_completion(&ctx->helper_holds);
+	return t;
+}
+
+static void stop_helper(struct kunit *test, struct task_struct *t)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	complete(&ctx->helper_may_release);
+	wait_for_completion(&ctx->helper_done);
+	kthread_stop(t);
+}
+
+/* Each task has its own count, and a new task starts at zero. */
+static void the_count_is_per_task(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct task_struct *t;
+
+	down_read(&ctx->tsem2);
+	ASSERT_DEPTH(test, ctx, 1);
+
+	t = start_helper(test, HELPER_TMUTEX);
+
+	/* The helper's lock is not in our count. */
+	EXPECT_DEPTH(test, ctx, 1);
+	/* The helper started from zero, not from our count. */
+	KUNIT_EXPECT_EQ(test, 1u, ctx->helper_depth_held);
+
+	stop_helper(test, t);
+	KUNIT_EXPECT_EQ(test, 0u, ctx->helper_depth_after);
+
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem2);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/* A failed trylock is not counted. */
+static void failed_trylock_is_not_counted(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct task_struct *t;
+
+	t = start_helper(test, HELPER_TSEM_WRITE);
+
+	KUNIT_EXPECT_EQ(test, 0, down_read_trylock(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 0);
+
+	KUNIT_EXPECT_EQ(test, 0, down_write_trylock(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 0);
+
+	stop_helper(test, t);
+
+	/* Once the lock is free, the trylock succeeds and counts. */
+	KUNIT_ASSERT_EQ(test, 1, down_read_trylock(&ctx->tsem));
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+/*
+ * A failed mutex_trylock() is not counted, and a contended mutex_lock()
+ * is counted exactly once: not zero (slow path missed) and not twice
+ * (fast and slow path both counted).
+ */
+static void contended_mutex_is_counted_once(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct task_struct *t;
+
+	t = start_helper(test, HELPER_TMUTEX);
+
+	KUNIT_EXPECT_FALSE(test, mutex_trylock(&ctx->tmutex));
+	EXPECT_DEPTH(test, ctx, 0);
+
+	/*
+	 * Let the helper release the lock. mutex_lock() below most likely
+	 * finds it still held and takes the slow path.
+	 */
+	complete(&ctx->helper_may_release);
+
+	mutex_lock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	wait_for_completion(&ctx->helper_done);
+	kthread_stop(t);
+}
+
+/* The same for a contended rwsem. */
+static void contended_rwsem_is_counted_once(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct task_struct *t;
+
+	t = start_helper(test, HELPER_TSEM_WRITE);
+
+	complete(&ctx->helper_may_release);
+
+	down_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+	up_write(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	down_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	wait_for_completion(&ctx->helper_done);
+	kthread_stop(t);
+}
+
+/* The same for a percpu_rw_semaphore, starting with a failed read trylock. */
+static void contended_percpu_rwsem_is_counted_once(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+	struct task_struct *t;
+
+	t = start_helper(test, HELPER_TPCPU_WRITE);
+	KUNIT_EXPECT_EQ(test, 1u, ctx->helper_depth_held);
+
+	KUNIT_EXPECT_FALSE(test, percpu_down_read_trylock(&ctx->tpcpu));
+	EXPECT_DEPTH(test, ctx, 0);
+
+	complete(&ctx->helper_may_release);
+
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	percpu_down_write(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_write(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	wait_for_completion(&ctx->helper_done);
+	KUNIT_EXPECT_EQ(test, 0u, ctx->helper_depth_after);
+	kthread_stop(t);
+}
+
+/* Initializing a lock again clears its opt-in. */
+/*
+ * The opt-in is a sticky bit in the same word that says whether the lock is
+ * held, so an opted-in lock that nobody holds must still read as unlocked.
+ */
+static void opted_in_lock_still_reads_unlocked(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	KUNIT_EXPECT_FALSE(test, rwsem_is_locked(&ctx->tsem));
+	KUNIT_EXPECT_FALSE(test, mutex_is_locked(&ctx->tmutex));
+	KUNIT_EXPECT_FALSE(test, percpu_is_read_locked(&ctx->tpcpu));
+	KUNIT_EXPECT_FALSE(test, percpu_is_write_locked(&ctx->tpcpu));
+
+	down_read(&ctx->tsem);
+	KUNIT_EXPECT_TRUE(test, rwsem_is_locked(&ctx->tsem));
+	up_read(&ctx->tsem);
+	KUNIT_EXPECT_FALSE(test, rwsem_is_locked(&ctx->tsem));
+
+	down_write(&ctx->tsem);
+	KUNIT_EXPECT_TRUE(test, rwsem_is_locked(&ctx->tsem));
+	up_write(&ctx->tsem);
+	KUNIT_EXPECT_FALSE(test, rwsem_is_locked(&ctx->tsem));
+
+	mutex_lock(&ctx->tmutex);
+	KUNIT_EXPECT_TRUE(test, mutex_is_locked(&ctx->tmutex));
+	mutex_unlock(&ctx->tmutex);
+	KUNIT_EXPECT_FALSE(test, mutex_is_locked(&ctx->tmutex));
+
+	percpu_down_write(&ctx->tpcpu);
+	KUNIT_EXPECT_TRUE(test, percpu_is_write_locked(&ctx->tpcpu));
+	percpu_up_write(&ctx->tpcpu);
+	KUNIT_EXPECT_FALSE(test, percpu_is_write_locked(&ctx->tpcpu));
+}
+
+/* Opting in a lock that is already held is refused, and warns. */
+static void track_holder_on_a_held_lock_is_refused(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	mutex_lock(&ctx->pmutex);
+	down_read(&ctx->psem);
+	percpu_down_read(&ctx->ppcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	kunit_warning_suppress(test) {
+		mutex_track_holder(&ctx->pmutex);
+		rwsem_track_holder(&ctx->psem);
+		percpu_rwsem_track_holder(&ctx->ppcpu);
+		KUNIT_EXPECT_SUPPRESSED_WARNING_COUNT(test, 3);
+	}
+
+	/* Refused, so the locks are still untracked and nothing is counted. */
+	EXPECT_DEPTH(test, ctx, 0);
+	percpu_up_read(&ctx->ppcpu);
+	up_read(&ctx->psem);
+	mutex_unlock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+
+	mutex_lock(&ctx->pmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+	mutex_unlock(&ctx->pmutex);
+}
+
+/*
+ * The non_owner calls can run in different tasks, which a per-task count
+ * cannot follow. Both sides warn on a tracked rwsem and neither counts.
+ *
+ * Without CONFIG_DEBUG_LOCK_ALLOC they are plain down_read()/up_read(),
+ * which are counted and balanced, so there is nothing to test.
+ */
+static void non_owner_on_a_tracked_rwsem_warns(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_LOCK_ALLOC))
+		kunit_skip(test, "non_owner API needs CONFIG_DEBUG_LOCK_ALLOC");
+
+	kunit_warning_suppress(test) {
+		down_read_non_owner(&ctx->tsem);
+		EXPECT_DEPTH(test, ctx, 0);
+		up_read_non_owner(&ctx->tsem);
+		KUNIT_EXPECT_SUPPRESSED_WARNING_COUNT(test, 2);
+	}
+	EXPECT_DEPTH(test, ctx, 0);
+
+	/* An untracked rwsem uses them without warning, and is not counted. */
+	down_read_non_owner(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 0);
+	up_read_non_owner(&ctx->psem);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static void reinit_clears_the_opt_in(struct kunit *test)
+{
+	struct lockholder_ctx *ctx = test->priv;
+
+	down_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 1);
+	up_read(&ctx->tsem);
+
+	init_rwsem(&ctx->tsem);
+	down_read(&ctx->tsem);
+	EXPECT_DEPTH(test, ctx, 0);
+	up_read(&ctx->tsem);
+
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 1);
+	percpu_up_read(&ctx->tpcpu);
+
+	percpu_free_rwsem(&ctx->tpcpu);
+	KUNIT_ASSERT_EQ(test, 0, percpu_init_rwsem(&ctx->tpcpu));
+	percpu_down_read(&ctx->tpcpu);
+	EXPECT_DEPTH(test, ctx, 0);
+	percpu_up_read(&ctx->tpcpu);
+
+	mutex_lock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 1);
+	mutex_unlock(&ctx->tmutex);
+
+	mutex_init(&ctx->tmutex);
+	mutex_lock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+	mutex_unlock(&ctx->tmutex);
+	EXPECT_DEPTH(test, ctx, 0);
+}
+
+static struct kunit_case lockholder_test_cases[] = {
+	KUNIT_CASE(untracked_locks_are_not_counted),
+	KUNIT_CASE(tracked_mutex_is_counted),
+	KUNIT_CASE(tracked_rwsem_read_is_counted),
+	KUNIT_CASE(tracked_rwsem_write_is_counted),
+	KUNIT_CASE(tracked_percpu_rwsem_is_counted),
+	KUNIT_CASE(percpu_rwsem_handover_moves_the_count),
+	KUNIT_CASE(percpu_rwsem_slow_read_path_is_counted),
+	KUNIT_CASE(downgrade_write_keeps_the_count),
+	KUNIT_CASE(nested_locks_stack),
+	KUNIT_CASE(guards_are_counted),
+	KUNIT_CASE(the_count_is_per_task),
+	KUNIT_CASE(failed_trylock_is_not_counted),
+	KUNIT_CASE(contended_mutex_is_counted_once),
+	KUNIT_CASE(contended_rwsem_is_counted_once),
+	KUNIT_CASE(contended_percpu_rwsem_is_counted_once),
+	KUNIT_CASE(reinit_clears_the_opt_in),
+	KUNIT_CASE(opted_in_lock_still_reads_unlocked),
+	KUNIT_CASE(track_holder_on_a_held_lock_is_refused),
+	KUNIT_CASE(non_owner_on_a_tracked_rwsem_warns),
+	{}
+};
+
+static struct kunit_suite lockholder_test_suite = {
+	.name = "lockholder",
+	.init = lockholder_init,
+	.exit = lockholder_exit,
+	.test_cases = lockholder_test_cases,
+};
+kunit_test_suite(lockholder_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for sleeping lock holder tracking");
+MODULE_LICENSE("GPL");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 163192b2ed7f..67fc86b4fc6f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1672,6 +1672,19 @@ config WW_MUTEX_SELFTEST
 	  Say M if you want these self tests to build as a module.
 	  Say N if you are unsure.
 
+config TRACK_LOCK_HOLDERS_KUNIT_TEST
+	tristate "KUnit tests for sleeping lock holder tracking" if !KUNIT_ALL_TESTS
+	depends on KUNIT && TRACK_LOCK_HOLDERS
+	default KUNIT_ALL_TESTS
+	help
+	  Check that task_nr_tracked_locks() always equals the number of
+	  opted-in locks the task holds.
+
+	  For more information on KUnit and unit tests in general, refer to
+	  the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config SCF_TORTURE_TEST
 	tristate "torture tests for smp_call_function*()"
 	depends on DEBUG_KERNEL
-- 
2.53.0-Meta


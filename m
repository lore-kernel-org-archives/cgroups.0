Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015900;
	b=GySz4QKiy3ftXZn2CDtYHUmVtcZ+2JQESCmUGjX1IV4vYdCZYL3qkmanYe4C44VvAWec
	 nMYiwaizSxW3ZAwV5s3LxCRZ2moK6k+jQ6KgtdA7b9iz/7740u3EvHGGqTzJIyGPCD24M
	 p5SeEr4N2Ea68HQL3u9OaV0aTcSPxjFjMeHoobxoOkFg3ZzF6ZkSY+SyxshJqavOhvPXZ
	 MX6PJk4Xd3hq0jTQMVlsyai4bk1/4jJ2koMUs4imnPxNMZwPKgsKESnFAfJ67D7+7MFGm
	 NjKbk/PyrHRZQN0TK4JxNFSWWK3vOZrFjHRjekAQqb+qplOkFULeJdezWKcsRIBZPww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015900;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=86euM9Gfx67Z/jCzCvP+9zClJRgbdRmi1RRM/bKJC7A=;
	b=cgMqlaacnvwCmKi4SfyNhjdthxf1xFoXQ2asiIIG7Z7XjkoKN/YcPaVv9tJsLrYbgddT
	 WCYWUeZuXDIB3a7T/vrHbGmXLNghIZ7FxjlNGYJ6XNLg3MEL/fUS4pPdEYZD3COtbdFuv
	 22CuU+FnBIkoqSOYWAzvcaoPgHm4igUp3JkTR39nQZGNBZIkkU+8VDzEft22VO0xMBQch
	 M7gxrsXFYX1sezSsRnRAn1PftTnX0nC6eGYDw4IUtZW0SKUDdirhzDG8XZvUZFk/zEmA8
	 dbrnBBK5sA9HOU6KTFgSBHE3fmT7gb72YoSlOdYZDFB6E4wG4gJGOqzNbk31To5l9bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sL14LSRQ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88915606A32F;
	Sat,  7 Nov 2026 01:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88915606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sL14LSRQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015898;
	bh=86euM9Gfx67Z/jCzCvP+9zClJRgbdRmi1RRM/bKJC7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL14LSRQ2O/7aqTYuF+0rNby+HniyA1vPz03lJ+Jtqudop7ufjjGJq47ri9wpcSQj
	 Q/lWf1dKnadjhNJIcEVvSdPeN4azsCoIRrr51iSHASULO8WzjUqLoK1XlRG0VZpaO1
	 uy58arcSFFkg5aZxl+EO6a8LHBcX8zfoE+n//moAEgww/2X0XqgnAvadqOhb1lHPs7
	 w9C4iF/hmDAVNrVcEqpsP8ygOgs4XnpSE23JOUadAoijXywW/psSexX73IIJ2bLvcr
	 cPxpv6OO3AdQXB1MAf4kNgXTlB1nhsNi7Bqw+EPM75yxVwkr85Wni8slQ046RiX1/T
	 w5kVQ7wPiKViA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPk30VqzLZ4;
	Fri, 06 Nov 2026 20:44:58 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v4 01/26] sched: Fix cpuset_mutex double unlock in __sched_setscheduler()
Date: Fri,  6 Nov 2026 20:44:26 -0500
Message-Id: <20261107014451.1487825-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

From: Andrea Parri <parri.andrea@gmail.com>

A sched_setattr() with SCHED_FLAG_KEEP_POLICY on a SCHED_DEADLINE task
unlocks cpuset_mutex twice if the task's policy changes concurrently:

  WARNING: bad unlock balance detected!
  7.4.0-rc1 #1 Not tainted
  -------------------------------------
  repro/126 is trying to release lock (cpuset_mutex) at:
  [<ffffffff9a17cacc>] __sched_setscheduler+0x9cc/0xc40
  but there are no more locks to release!
  ...
  Call Trace:
   print_unlock_imbalance_bug.part.0+0xfb/0x110
   lock_release+0x286/0x2e0
   __mutex_unlock_slowpath+0x1a/0x400
   __sched_setscheduler+0x9cc/0xc40
   __x64_sys_sched_setattr+0xa3/0x1b0
   do_syscall_64+0x106/0x5f0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

__sched_setscheduler() samples p->policy before taking any lock, and
restarts from the recheck label if p->policy differs under the rq lock.
The restart drops cpuset_mutex but leaves cpuset_locked set, so a pass
that no longer needs the mutex still unlocks it on its way out:

  CPU 1                                CPU 2
  __sched_setscheduler(KEEP_POLICY)
    policy = p->policy /* DEADLINE */
                                       __sched_setscheduler(SCHED_OTHER)
                                         p->policy = SCHED_OTHER
    cpuset_locked = true
    cpuset_lock()
    rq = task_rq_lock(p)
    oldpolicy != p->policy
      cpuset_unlock()
      goto recheck
    /* no cpuset_lock() this time */
    ...
    if (cpuset_locked)
      cpuset_unlock()

Without CONFIG_DEBUG_MUTEXES, or CONFIG_DEBUG_RT_MUTEXES on PREEMPT_RT,
nothing warns. The second unlock still clears the owner field regardless
of who holds the mutex, so another task can lose cpuset_mutex inside its
critical section. Entering SCHED_DEADLINE needs CAP_SYS_NICE, but a
racing caller that owns the task does not need it if it samples a policy
other than SCHED_DEADLINE.

Clear cpuset_locked when dropping the mutex for the restart. This should be
safe because the flag is only tested on the paths leaving the next pass,
after that pass has set it again if it took the mutex.

The following program, run as root, reproduces the splat, which no longer
appears with this applied. On PREEMPT_RT it crashes the kernel within
seconds, which this also fixes:

  #define _GNU_SOURCE
  #include <pthread.h>
  #include <stdint.h>
  #include <sys/syscall.h>
  #include <unistd.h>

  struct attr {
      uint32_t size, policy;
      uint64_t flags;
      int32_t nice;
      uint32_t prio;
      uint64_t runtime, deadline, period;
  };

  static volatile int stop;
  static volatile pid_t target;

  static void set(struct attr a)
  {
      a.size = sizeof(a);
      syscall(SYS_sched_setattr, target, &a, 0);
  }

  static void *sleeper(void *arg)
  {
      target = syscall(SYS_gettid);
      while (!stop)
          usleep(1000);
      return arg;
  }

  static void *switcher(void *arg)
  {
      while (!stop) {
          /* SCHED_DEADLINE, 2us every 1s */
          set((struct attr){ .policy = 6, .runtime = 2000,
                             .deadline = 1000000000,
                             .period = 1000000000 });
          set((struct attr){ .policy = 0 }); /* SCHED_OTHER */
      }
      return arg;
  }

  static void *racer(void *arg)
  {
      /* KEEP_POLICY | KEEP_PARAMS */
      while (!stop)
          set((struct attr){ .flags = 0x18 });
      return arg;
  }

  int main(void)
  {
      pthread_t t[5];
      int i;

      pthread_create(&t[0], NULL, sleeper, NULL);
      while (!target)
          usleep(100);
      pthread_create(&t[1], NULL, switcher, NULL);
      for (i = 2; i < 5; i++)
          pthread_create(&t[i], NULL, racer, NULL);
      sleep(30);
      stop = 1;
      for (i = 0; i < 5; i++)
          pthread_join(t[i], NULL);
      return 0;
  }

An LLM helped find the PREEMPT_RT crash and write this patch and its test.

Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261016062629.2102883-1-sh_def%40163.com
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 45a127deeadd..2af550f92ac6 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -640,8 +640,10 @@ int __sched_setscheduler(struct task_struct *p,
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
-		if (cpuset_locked)
+		if (cpuset_locked) {
 			cpuset_unlock();
+			cpuset_locked = false;
+		}
 		goto recheck;
 	}
 
-- 
2.47.3


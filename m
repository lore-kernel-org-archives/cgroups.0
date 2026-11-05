Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907256;
	b=5pM7Yiewx8YTht7AfSLpNl4tn1/W+GHxjmchZ7yrMtbv/452AkhZ6oTEbRi873c5Sm8S
	 AGRbQ4c1xAj7IKZXz01K2NU5znB5YE5hL5AyXYDUe7H0DdVsYQe0iUJzSfG+B6qIN+xYQ
	 EH8GiLBh1+k+uLWm4QqyvEZDRoSQMoBRC3Vcpqn5gUeedeTYiAmNwnhldgXMCL4EJxDe0
	 wF48P/ijjhNCAkWzG3lKrs0D0PMnSS7NatcYp12vz+vtjP0ZzEGCL716CzLKaXb6D1M3x
	 w/pjmg3BNu4GTnyFHL4OmtvphsYz3tpXoRMa2FWDgDGpQqcTqYcIUI8Vh69by+ecnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UgrZOSXgcIR7ewws5Wtl/aD7cavaVZd53IcOP/KOXkE=;
	b=1/2HUS3wC8dpH4Bn0CAdYePxGc/f8A4FY+oUdDHGnyGPd3ntZHwvrOfgZI+Tltcp9too
	 4MKk/yGCgFjvyCM4qXY9TebvuI0CrEPxAeivin8As4Mp3hBw4nSio+UxDaz6xl9elN0UD
	 gTjg5st5yoe555xTsfIpf9/yZyX3qjofSRMjObw9kN69mcMsQd/MZ7sPFDk+PYa/1uy43
	 NHtV7oBW0KxGcBQNba3BRnmfw9RhQf0ZnbMsxnMu1fixTBPxyyZwjswjdxuUI7FErnxS7
	 mfDlEYPuv/+TDENlYpZebxOAJFHD8y/UCmIgkxcvmrJsGXGxwtaJTJgoOibFBPxHUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wfUNz3ai;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1086D606B056;
	Thu,  5 Nov 2026 19:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1086D606B056
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wfUNz3ai
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907249;
	bh=UgrZOSXgcIR7ewws5Wtl/aD7cavaVZd53IcOP/KOXkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfUNz3ai7Y58tnwvg1X98+jEC4IVm8uKj/gJTQ/Sp4733zg52AZNaIj5RB0SMKRWk
	 ywcxvSHd3zd3LTeTEYOaC0M8kyXrb7Fekr3soVdSnjPSUlPQrQHPEpL6Ae9E9fP6sP
	 uVjJgeEiPBVLjjiN3OTCAhGcgiPEozjRKO5EHfHgKBL3oxXg5fRSrhs/qt6nXV+aXM
	 8gCaT2kNyUJLMXQuony0BpxnTlqlbnmVlM5ViFK/XWYmGkKjs+fVmT/WDAqR9ShAnO
	 Tn8IwalGGgjAZ/UdVfjDYoI1g0ByUFSMOwnHAcBNyYPASPmp5Bo514hrHEwsfxGBge
	 GWKDEcetfIU6w==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDK0NNszLDS;
	Thu, 05 Nov 2026 14:34:09 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 01/24] sched: Fix cpuset_mutex double unlock in __sched_setscheduler()
Date: Thu,  5 Nov 2026 14:33:36 -0500
Message-Id: <20261105193359.1450487-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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


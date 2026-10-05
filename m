Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20DC372058
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791183997; cv=none; b=bPohBc7SjMSnHOeh6NYtXhLC8A1YQzGrTHFY4sMzJrXEyB0OgAWjS0g13LjqWXg7JD2OohD0SzSePyU9fvtCzZaTVYzA+Sakj2E/lyBsxtdYXVefptz7yX6Fhm84p2i6ofu8khVymmgWJZ+AN4ZCdPkjHiWqHFOAN9wlapWFgGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791183997; c=relaxed/simple;
	bh=05kHoko/nqMI072En1PJNukfGt9/4zUx6GVdib+NbNo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j/YOAwcEFF/7FZYlU1q2dGk9nD9r4xMjvIJp9zNtC7CApoXMTto5w+KvW1+h0CkrmpjH357Wwgj/Snh4U0tl8+GsfRAb1Bbaf/H7zlDX1rB8bK2FeVbR3gQ3cdvMyZyjqTJ39v1IzRbvwMD1OP3wHgLmJjhgdUr96zhAx8zdKXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o9OikwFl; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o9OikwFl"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so8605485e9.2
        for <cgroups@vger.kernel.org>; Mon, 05 Oct 2026 00:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183993; x=1791788793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+vg5y7TFdC/oAYFLNYNMU7By8Gx4IwKuOI2ehF5mxV8=;
        b=o9OikwFlJm20JBMrFsPyBqtt36XEsmOcUdkVWn6tJW7rgN7ouWHKhhwSMQy6Lk7Q1m
         c7Mre0y/sNHdNeu5+uYMrwH2rpjeMrWhlxT1lUvEC35HcuitDDK6M5WpV7Tat3f1q9x+
         +mV7hGdHU/ZF1zVilNbW2ZTYBok5yk3kVFV6gsNb4HJ6spBmxOKCFtZgNYLwEDVKmmb5
         2APkXVlCx6kY0E5BGdnFnL+pIElnZJC70+RFteRJtmFqtRIPBOd05bj2s1CC0waYqevD
         RLx1LoIngjQySglANuKJS8Aehk3DC8+yL8jS5K5G7ASRplpyegIDKItLr689Lb4FcvCh
         liZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183993; x=1791788793;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+vg5y7TFdC/oAYFLNYNMU7By8Gx4IwKuOI2ehF5mxV8=;
        b=XLz7XXZHIIKzXBHbzQR/LB0OLv+/ZbFN3uXQyYLWmi250ByZjsbH4Cqeehf44D8DoJ
         LU61w9sV1StgXHaP5T786Tq8p3c4viutUFM78Kn2CRVDUqEk0vosWeVDzM+OcyZYcvMP
         QzWkIhMj6RMInY2Uur3QT6BTvwCIPC43AyEwBtWnPNK8ZLCePH14HLboGbaGRLwtB/TL
         S77Cgsr9t80HS3ktDASDrrOrrhT1eRZqFPe2/ADsSfDnxKBZiPOmB7fL1LEpncBSIA4p
         4lPyeDy2c8Rv4ECvMX8Vx+wKFaP4phsbZ0C5JDykFFhf3cRQyPmgj1BVrKvI0LRWKp52
         683Q==
X-Forwarded-Encrypted: i=1; AKwUvByUUcVYaFyEdXUBnysQ+scQYRSc3iJcxEqaO6hW+uunnEKT3xWPy/o4txbohbJ1BXKQCB9Tx0gS@vger.kernel.org
X-Gm-Message-State: AFuF++km9yfT2hMrd+BQB+yXGO6a6cQvk/M9vUUKdIuSyu2oLiobGu1D
	6J1bib3Ix6tySsaFoCWsG13JhNhkceqNNLI4Gy3qzJQUWaR+Kd+UXH+N
X-Gm-Gg: AYBFou1dHvR2pM3uyvSmq0sxqH8FkGtaL0Kgoo4nJaf8GzMvTKoUjuqCeevSOZy37lV
	FX2D9pqKAUCvbEkwpFuNv1fCNjEzzbQ+vo9dy2hLTHmcroNxmir7eXiVlie62BOjBc4gUaxJc7Y
	YKJGwWb2os0xYF5gZiZY+Mt99YzwcEAdqQPaS4hIFB+bfNC6Sza2n+SQQk/Awo/A1FMzm5McUnN
	8OYiDeOY2eCyJOEtgHYcJBS1h+f+dTqs59dfKFqe9FDIGZO/SHNNI8Ut4WbRbZnO8AV3vUtKFZH
	k+Qq0BDWNDSwSbQbTe5JQ5lixVameMfbdsapBTXV7rx4yynxb6LjOtlPEys350C1p3tEH7cMah4
	IXxak6cHrpcds7F+3W0Cvkuha18p/D+qI0mSdco21oOwrNxgFZNWByLvyfdEjr4di1sKqbfKmPh
	BfzWFyNbHAgO0xa6LD7glOEjASU0ZzEOTRe36VvkiE374XorJ+c/28iJA1oqPhKpeTl3DyCXLes
	dOPfcCy5Y6JoipiIcvtZcfr72Sv5adf/Wu/0p0gjTTKR3o9h6OKz5IRjAjITPSy8MZzPgGT1u+F
	rMDz9meBMgIfhXXVKMxEQCb4y7Zxr83LKHZu+qRmTxk6RYbbTWIR7yNtbjloufO7cMtYPaqgL1q
	amQ==
X-Received: by 2002:a05:600c:c4a6:b0:4a0:25e9:bc47 with SMTP id 5b1f17b1804b1-4a02759a443mr172676745e9.19.1791183992976;
        Mon, 05 Oct 2026 00:06:32 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:32 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on RT
Date: Mon,  5 Oct 2026 09:06:22 +0200
Message-Id: <20261005070625.8871-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On PREEMPT_RT, a BPF task-storage program attached to sched_waking
can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
lock can enter priority-inheritance or wakeup code and re-enter scheduler
locking.

The first RFC [1] rejected every non-preemptible caller. That prevents the
deadlock, but it also rejects BPF arena allocation and faults under the
arena's ordinary raw lock.

This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
trylocks. Atomic acquisition succeeds only from the completely free state.
A regular waiter sets HAS_WAITERS before waiting, which prevents a later
atomic owner from barging. Atomic release preserves HAS_WAITERS and does
not enter priority inheritance or wake a task. Preemption and local
interrupts remain disabled for the atomic-owner section.

The design tradeoff is that a regular waiter cannot boost an atomic owner
and spins with interrupts disabled until the bounded allocator section
finishes. I would value locking review of whether that owner state and
handoff are acceptable, or whether the no-lock allocator should instead
fail in these contexts.

Patch 2 uses the new operation for global SLUB and page-allocator locks. It
avoids regular per-CPU RT local-lock slow paths and reuses centralized
objcg credit when the per-CPU stock is unavailable. Patch 3 adds a BPF
selftest for task-storage allocation from hrtimer_start while the hrtimer
base raw lock is held.

The series has one prerequisite, recorded by prerequisite-patch-id in this
cover letter:

  mm/page_alloc: skip shuffling and reporting for no-lock frees

That independent fix has been posted as a normal patch [2]. It keeps a
successful no-lock page free out of allocator shuffling and page-reporting
notification. It is separate because the issue begins with the v6.15
free_pages_nolock() API rather than the v7.0 slab regression addressed by
patch 2.

Patch 2 should also be evaluated with David Stevens's pending memory.high
deferral fix [3]. There is no build dependency, but bypassing the per-CPU
stock can make a no-lock charge reach that pre-existing schedule_work()
hazard more often.

The pre-rebase version of these atomic-owner changes passed four-vCPU
x86-64 PREEMPT_RT QEMU in release and lockdep/debug-rtmutex builds. Tests
completed 5,000 forced waiter handoffs without barging, kept asynchronous
IPIs out of atomic-owner sections and passed the BPF hrtimer workload.

After rebasing onto current mainline and the prerequisite, the affected
locking and MM objects build with PREEMPT_RT and lockdep. I have not
repeated the runtime campaigns for this RFC rebase.

If this direction is accepted, patches 1 and 2 would need joint stable
backports for v7.0 and later.

Changes since the RFC v1:

  - replace the blanket context rejection with an atomic rtmutex owner
  - preserve local IRQ state across a successful atomic trylock
  - cover the global slab, page allocator and memcg-cache paths
  - bound shared objcg credit when the per-CPU stock is skipped
  - add forced-handoff, caller-attribution and BPF hrtimer tests
  - keep the independent no-lock page-free fix as a prerequisite

[1] https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com
[2] https://lore.kernel.org/r/20261005063515.6312-1-kmehltretter@gmail.com
[3] https://lore.kernel.org/r/20260904173145.2028377-1-stevensd@google.com

Karl Mehltretter (3):
  locking/rtmutex: Support atomic PREEMPT_RT spin trylocks
  mm: use atomic RT trylocks for no-lock allocation
  selftests/bpf: exercise task storage from hrtimer_start

 Documentation/locking/rt-mutex.rst            |  40 ++--
 include/linux/rtmutex.h                       |   4 +-
 include/linux/spinlock.h                      |   3 +
 include/linux/spinlock_rt.h                   |  28 ++-
 kernel/locking/rtmutex.c                      | 211 ++++++++++--------
 kernel/locking/spinlock_rt.c                  |  66 +++++-
 mm/internal.h                                 |  27 ++-
 mm/memcontrol.c                               |  90 ++++++--
 mm/page_alloc.c                               |  33 ++-
 mm/slub.c                                     |  36 +--
 .../bpf/prog_tests/task_storage_hrtimer.c     |  50 +++++
 .../bpf/progs/task_storage_hrtimer.c          |  48 ++++
 12 files changed, 479 insertions(+), 157 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_storage_hrtimer.c


base-commit: e767a4ea70a3992c37ed604157d32f0dfbf9b1e3
prerequisite-patch-id: 33838040c410e5de0aef855a2719a092b561a5c4
-- 
2.53.0


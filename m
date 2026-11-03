Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692821;
	b=pDCmJvbwlSIqiV3nueFNdW6gWyuXAj7EhcoTXD6V/hd9Kf8FOFLItib7bJLmD2GbC9nE
	 W/1424IeMKVKUGSDzGeq7ejmUUvRiUXFN/UecDalUSZGTgnRQZCfoH2+Q93duMi6EON1+
	 zwikaizSK6mqsOJBuyAcAJMe/nDrny4g++bodszvKF2JKXjjBhEznYuQqO931SebFLXte
	 uD1Pn78WhKRL4WJpLueioyiEkPZypN7jDghbO+V25hO8waN+Aig+4P+YPua8bvzBOidf0
	 W/kbgYxj5td6UnC7nIa/8HrVf3gPNhPv7z0XjUPxpgtLuAjJ1yIbpRluMkTYlX9XO+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692821;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xrhIdGWRYDvwFuTtFot+aWJhfp2ZEWcKkmDR7R1zYSo=;
	b=s7V7aFOCI2H2jDPZyPFAD47jchN6/VbQ20eP2RtTXJUGW9P81j2pXg1E6InTH7U0YLLK
	 8wgLXTeb/wsZHxUfdoq2gcH/Z0p0mtW8IgIj9AXXBmXaMYCqnztPac5xqtZdZp9MSzJeV
	 vEVS/mvP3RvL0Y2QlVotaPiJN0KFZZIiQ2IngqWknRwUYNjmxVUEuhus925sLkrjQG205
	 tUfd09jUHnVa6p+7oHzaX972RMamP1g2SzLlv5ytHQU9faF2Q2ZaAxNqpKmWGymOMXAOK
	 0LQ3zbqjjUAokeVxLU6BkG1fODoE4xJpBpMM1ovZ0xIiPEVMcywtQW9TeTj7H7U7/Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=f38tGRqn;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EC0606A32F
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0EC0606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=f38tGRqn
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CCB7C3F6ED
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692811;
	bh=xrhIdGWRYDvwFuTtFot+aWJhfp2ZEWcKkmDR7R1zYSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=f38tGRqnZw5smZo6CpFiEGeFFGCaGeq+c/oSi6jW7J8mkcCC0/fHGR8I9lxRr+q0X
	 46MtsY8ol+3F3ZxtdwlKiNya9Y4hFNquNtHVeXWTqtmW+1zq9tJB7HAJAgy10lQnKg
	 64j4Agi1DzhZpqaKlpe2vHB2vRf645UXntnGswaOn+zNOXo7JuqNfWMU+HgULBc1qQ
	 QjyRHqZSiAGDG/VM/GkO+s61FScAfyUdsM8Ia8F4lZBTLJdoj0uCyyr0OUyKxojLXV
	 AxqjQbqOqHYYsEpzCi8kau6DJFpJgakRb1eQM29GE2FJMXBf7Nv+eQnhn8kVEzBmEd
	 dw8zUcxJPtLgtPazG9/QZwvJDkvsSn4DwBdeM5k6O928z4YEAvegL34tBoViQWVwR2
	 Ko3oW8DuvgFJ6WJ/k4quJCFZYdI01MbMRU83IrAjp/i/RQ9zjY3/uAWcB9P2Uh0aDS
	 pKezZz/WHZ9AKB+OA3e0a25bLILRBmKSiugdFJRXPtme40ZvjwDav7TNnrmGFFtY2g
	 bDoiKIz6TROtR59rNbQGVYM1SkyghCJxyj+FDhQ77jN47xnYm1uOhtW/mXSwzzsqC/
	 78rgyDYfkRyGPwsjLd/i3JHSqwSfBsB8MdEbGCH946ApWxTBqDaK1QORdebSpr0WK1
	 MJYOOrGSXEPeJJEa7ed8uEm0=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35c5aef2a74so16513499eec.0
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692810; x=1794297610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xrhIdGWRYDvwFuTtFot+aWJhfp2ZEWcKkmDR7R1zYSo=;
        b=FLRYhGxxUWUiK1duHQMjMKB5OSUr7PeTHO96IRz+yaITQIbgoJOPvS7VCT4Hfu7LQH
         FnH7FbsRax6L/mfiwPWk+uqB+iMwVHjD+sqi/MKvphzAb6Dx6m3H/9+l0qSQJMp6vVcT
         aSyUO/Dg8C/CI7KyuXfsTAWtOAYmX8Tk68kM47YPexs6j8Eo+JrI22XznapmyWCSLskV
         vM+q7TnvS+yLme1MrRjKZIcG+Wi6fd2SUmntj7rEQ0Fz3NURdc+LNlE/1gw5wbD+LHN7
         OCV7yBWDiMfwPhWM5WsSUAjgwA46h5t+9G02vZOvlt4OcmXJg1bN8/w8RLzuUrj8rCT+
         sQKw==
X-Forwarded-Encrypted: i=1; AKwUvBwP5j/fBoYGoBJrFA1yr/R4wE/oURzCX4rcQUF0KE2uyJTMGeMLFue+sh7OeohGtRz3FpBmnxzn@vger.kernel.org
X-Gm-Message-State: APuU4Z9NAMEtJtn68hhaAJpLqlHeIO7cv65Rf/VJXAPgIdlKhonhDYBv
	j9Mljhxbv53qPgVOK4rU+im22dejlSiWN7j2Q2UWL4pSHudl8azUoDu3Wiauxn0uYd/q+DSlxd2
	fHItm2r4bfZskPVdJIgtJNgcNgBTLrBskdbQVZzESwlChZHK/4JxZTKmGMJo+eP8A2AOaqdGCEe
	4=
X-Gm-Gg: AYBFou0YowoXdQU09crk+lSl1g8sztMRf1/MKNABL2A1rLK8pi29offDOOn4jRm2pku
	sTh24u6f9UZRx4L8UlbK6aJo4idPZKfB21pCpO8f/8sWJ5gScxqenPBmtRify747S9TNlnuIBbb
	YwUel5PB+3i+3XCjsgA7MbP+q2BJZSdBwkr/HBjLNj0J9cBEysYPE/IFrvvI/U5GxJB89hRJGOw
	WibnCDqLQCDPtzy6gFuqy/Dz4JY+f11+17y2z/KiQCDaMYqTCTrE5YGS5a4ViFUaNpS9Mh3UJAp
	9ebfnE2VnYcykZPZAdSwbQQ+RW1ATezOEavD6cNNER8C1HKhR+JVkW9XrOUHYwSRc5Wyl5kFcf0
	siLkCTM/URgBSiolbjji/YnQ4x3L0EBKl7XMf+S8p5xxI6wcPTOcOaD8PHsIO08pQ4vhikZ6PRL
	Ww9EU4dEBUgZj1KNBrTA==
X-Received: by 2002:a05:7301:3d06:b0:358:eccb:af7c with SMTP id 5a478bee46e88-36a42404840mr28102172eec.33.1793692809488;
        Tue, 03 Nov 2026 00:00:09 -0800 (PST)
X-Received: by 2002:a05:7301:3d06:b0:358:eccb:af7c with SMTP id 5a478bee46e88-36a42404840mr28102057eec.33.1793692808725;
        Tue, 03 Nov 2026 00:00:08 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.02.23.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:08 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 0/6] mm, sched, cgroup: LRU Cache never drains when isolcpus are used with spinning SCHED_FIFO tasks causing page migration stalls
Date: Tue,  3 Nov 2026 20:59:34 +1300
Message-ID: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
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

Dear maintainers of the scheduler, memory management, and cgroup subsystems,

A user, Caron Wills, ran into this problem in production and authored
the patch series, which we have iterated on, tested, and verified on bare
metal with the included reproducer together.

Caron Wills has been running into a problem where their low latency 
workloads are causing systemd / PID 1 to be stuck in D state for extended
periods of time, up to 10 minutes in their production environment, and I have
seen 3-5 minutes in testing my synthetic reproducers. This prevents user 
sessions from being created / ssh logins fail / and system services cannot be
restarted or containers cannot be killed or launched.

Downstream bug:
https://bugs.launchpad.net/ubuntu/+source/linux-aws/+bug/2165410

The user's system uses isolcpus on a large system with 192 CPUs, with 2x
AMD EPYC 9R45 CPUs across 2 NUMA nodes. 

The cpus are pinned like so:

isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178 
rcu_nocb_poll skew_tick=1 nosmt=force idle=poll numa_balancing=disable 
transparent_hugepage=never audit=0 nmi_watchdog=0 nowatchdog mce=ignore_ce 
tsc=reliable clocksource=tsc

Each of the isolated cpus are running CPU intensive workloads, spinning at
100% as SCHED_FIFO tasks at priority 80.

The issue happens when a significant amount of pages are migrated between NUMA
nodes. For example, 50GB of pages being migrated from node 1 to node 0.

Systemd enters D state for 3-5+ minutes with the following stack:

kernel: INFO: task systemd:1 blocked for more than 122 seconds.
kernel:       Tainted: G           OE       7.0.0-1004-aws #4-Ubuntu
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: task:systemd         state:D stack:0     pid:1     tgid:1     ppid:0      task_flags:0x40     0100 flags:0x00080000
kernel: Call Trace:
kernel:  <TASK>
kernel:  __schedule+0x2b2/0x630
kernel:  schedule+0x27/0x90
kernel:  schedule_timeout+0xcf/0x110
kernel:  wait_for_completion+0x7c/0x140
kernel:  __flush_workqueue+0x14e/0x430
kernel:  ? raw_spin_rq_unlock+0x14/0x50
kernel:  flush_migrate_mm_task_workfn+0x19/0x30
kernel:  task_work_run+0x62/0x90
kernel:  exit_to_user_mode_loop+0x14e/0x500
kernel:  do_syscall_64+0x265/0x5a0
kernel:  ? putname+0x41/0x90
kernel:  ? do_sys_openat2+0x99/0xe0
kernel:  ? __x64_sys_openat+0x5f/0xa0
kernel:  ? __ct_user_enter+0x2c/0x110
kernel:  ? do_syscall_64+0x21b/0x5a0
kernel:  ? __ct_user_enter+0x2c/0x110
kernel:  ? __ct_user_enter+0x2c/0x110
kernel:  ? do_syscall_64+0x21b/0x5a0
kernel:  ? __ct_user_enter+0x2c/0x110
kernel:  ? irqentry_exit+0x17f/0x5a0
kernel:  ? exc_page_fault+0x94/0x1e0
kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
kernel:  </TASK>
kernel: INFO: task kworker/u768:1:1765 blocked for more than 122 seconds.
kernel:       Tainted: G           OE       7.0.0-1004-aws #4-Ubuntu
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: task:kworker/u768:1  state:D stack:0     pid:1765  tgid:1765  ppid:2      task_flags:0x42     08060 flags:0x00080000
kernel: Workqueue: cpuset_migrate_mm cpuset_migrate_mm_workfn
kernel: Call Trace:
kernel:  <TASK>
kernel:  __schedule+0x2b2/0x630
kernel:  schedule+0x27/0x90
kernel:  schedule_timeout+0xcf/0x110
kernel:  wait_for_completion+0x7c/0x140
kernel:  __flush_work+0x7d/0xd0
kernel:  ? __pfx_wq_barrier_func+0x10/0x10
kernel:  flush_work+0x10/0x20
kernel:  __lru_add_drain_all+0x19c/0x2c0
kernel:  lru_cache_disable+0x1f/0x30
kernel:  do_migrate_pages+0x4e/0x2b0
kernel:  cpuset_migrate_mm_workfn+0x26/0x50
kernel:  process_one_work+0x1a2/0x380
kernel:  worker_thread+0x1b8/0x360
kernel:  ? _raw_spin_lock_irqsave+0xe/0x20
kernel:  ? __pfx_worker_thread+0x10/0x10
kernel:  kthread+0xf7/0x130
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork+0x195/0x2a0
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork_asm+0x1a/0x30
kernel:  </TASK>

What happens is that the spinning SCHED_FIFO processes running on isolcpus are
constantly dirtying the LRU cache, and when we attempt NUMA migration of the
50GB of pages, systemd calls flush_migrate_mm_task_workfn() which creates a
kworker that calls cpuset_migrate_mm_workfn() then do_migrate_pages() then 
lru_cache_disable(), and then __lru_add_drain_all(). __lru_add_drain_all() then
creates a kworker on each CPU to drain the LRU cache, and systemd and the
initial kworker wait until this is done on all CPUs.

Since the isolcpus are running SCHED_FIFO tasks, they never get preempted,
and kworkers never get a chance to run until they get an opportunity to by
returning from a syscall, and it takes a very long time before all 192 CPUs
actually drain their LRU cache before the page migration can continue.

This stalls page migration, systemd gets stuck in D state, and causes all sorts
of problems.

Reproducer:

This was all tested on c8a.metal-48xl on AWS, but this instance type is not
really necessary. You need a large system with 2 NUMA nodes, and many CPUs.
c8a.metal-48xl has 2 NUMA nodes, and 192 cpus, so something similar will be okay.

In this reproducer, CPUs 0-17, 96-107, 179-191 are housekeeping threads, while
18-95 and 108-178 are isolated with isolcpus.

All of this was tested with Ubuntu resolute 26.04 userspace.

```
sudo apt update
sudo apt upgrade
sudo apt install build-essential
```

Setup isolcpus, nohz_full and rcu_nocb by setting the following grub command
line in `/etc/default/grub.d/99-repro.cfg`:

``` 
cat << 'EOF' | sudo tee /etc/default/grub.d/99-repro.cfg
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178 rcu_nocb_poll skew_tick=1 nosmt=force idle=poll numa_balancing=disable transparent_hugepage=never audit=0 nmi_watchdog=0 nowatchdog mce=ignore_ce tsc=reliable clocksource=tsc"
EOF
```

Run 

```
sudo update-grub
sudo reboot
```

Once the system is up again, check the cmdline:

```
cat /proc/cmdline
```

Save the following to files:

1. Churn Worker (`repro_worker.c`)

This program pins a `SCHED_FIFO/80` thread to an isolated core, continuously 
dirtying and discarding a 24 MB private buffer to generate un-drained local
per-CPU LRU folio batches.

```c
// repro_worker.c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sched.h>
#include <sys/mman.h>

#define REGION_SIZE (24 * 1024 * 1024) // 24 MB

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <cpu_id>\n", argv[0]);
        return 1;
    }

    int cpu = atoi(argv[1]);

    // Pin thread to target isolated CPU
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(cpu, &cpuset);
    if (sched_setaffinity(0, sizeof(cpuset), &cpuset) != 0) {
        perror("sched_setaffinity");
        return 1;
    }

    // Elevate priority to SCHED_FIFO 80
    struct sched_param param = { .sched_priority = 80 };
    if (sched_setscheduler(0, SCHED_FIFO, &param) != 0) {
        perror("sched_setscheduler (run as root)");
        return 1;
    }

    // Allocate 24MB private anonymous region
    char *ptr = mmap(NULL, REGION_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (ptr == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    // Churn loop: refault pages, then trigger MADV_DONTNEED
    while (1) {
        for (size_t i = 0; i < REGION_SIZE; i += 4096) {
            ptr[i] = (char)i;
        }
        madvise(ptr, REGION_SIZE, MADV_DONTNEED);
    }

    return 0;
}

```

2. Anchor Memory Allocator (`anchor_alloc.c`)

This program allocates and holds 50 GB of memory bound to NUMA node 1 inside
the target cgroup slice.

```c
// anchor_alloc.c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define GIB_50 (50ULL * 1024 * 1024 * 1024)
#define PAGE_SIZE 4096

int main() {
    char *ptr = mmap(NULL, GIB_50, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (ptr == MAP_FAILED) {
        perror("mmap anchor");
        return 1;
    }

    printf("[+] Touching full 50 GB anchor memory (4KB page stride)...\n");
    fflush(stdout);

    // Touch every 4KB page so all 13,107,200 pages fault into physical RAM
    for (size_t i = 0; i < GIB_50; i += PAGE_SIZE) {
        ptr[i] = 1;
    }

    printf("[+] 50 GB anchor memory fully allocated on NUMA Node 1.\n");
    fflush(stdout);

    while (1) {
        sleep(3600);
    }
    return 0;
}

```

3. Orchestration Script (`run_repro.sh`)

This script sets kernel panic thresholds, spawns worker load on isolated CPUs 
`18-95` and `108-178` inside `repro.slice`, allocates node 1 anchor memory, and
fires the `cpuset.mems` flip via systemd.

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Compile binaries
gcc -O2 repro_worker.c -o repro_worker
gcc -O2 anchor_alloc.c -o anchor_alloc

# 2. Configure capture sysctls
echo "[+] Configuring panic and hung task sysctls..."
#sysctl -w kernel.hung_task_panic=1
sysctl -w kernel.hung_task_timeout_secs=60
sysctl -w fs.inotify.max_user_watches=524288
sysctl -w fs.inotify.max_user_instances=8192
sysctl -w fs.file-max=2097152
ulimit -n 65536


# 3. Create target systemd slice
SLICE="repro.slice"
echo "[+] Resetting ${SLICE}..."
systemctl stop ${SLICE} 2>/dev/null || true
systemctl reset-failed ${SLICE} 2>/dev/null || true

# Initially assign allowed memory nodes to both 0 and 1
systemctl set-property ${SLICE} AllowedMemoryNodes=0,1

# 4. Generate list of 149 isolated CPUs (18-95 and 108-178)
systemd-run --slice=${SLICE} --scope --unit=repro-workers bash -c '
CPUS=($(seq 18 95) $(seq 108 178))
for cpu in "$${CPUS[@]}"; do
    chrt -f 80 taskset -c "$${cpu}" ./repro_worker "$${cpu}" &
done
wait
' &

sleep 5

# 5. Allocate 50GB anchor memory bound strictly to NUMA Node 1
echo "[+] Spawning 50GB anchor process bound to NUMA Node 1..."
systemd-run --slice=${SLICE} --scope --unit=repro-anchor numactl --membind=1 ./anchor_alloc &

# Wait for anchor allocation to complete
sleep 25

# Verify memory node distribution
echo "[+] Verifying memory location:"
numastat -c anchor_alloc || true

(
    while [ "$(awk '{print $3}' /proc/1/stat)" != "D" ]; do sleep 0.01; done
    t1=$(date +%s.%N)
    echo -e "\n[*] PID 1 entered D state at $(date +%H:%M:%S)..."

    while [ "$(awk '{print $3}' /proc/1/stat)" = "D" ]; do sleep 0.02; done
    t2=$(date +%s.%N)

    awk -v t1="$t1" -v t2="$t2" 'BEGIN {printf "\n[+] PID 1 recovered. Total duration in D state: %.3fs\n", t2 - t1}'
) &
MONITOR_PID=$!

# 6. Trigger cpuset.mems write via systemd (forces cpuset_migrate_mm_workfn)
echo "[!] FIRING TRIGGER: Restricting ${SLICE} AllowedMemoryNodes to Node 0..."
systemctl set-property ${SLICE} AllowedMemoryNodes=0 2>/dev/null || true

echo "[*] Trigger sent. PID 1 should block in task_work -> lru_cache_disable()."

# Wait for the background timer to complete measurement
wait "${MONITOR_PID}"
```

Instructions

1. Log in as `root`.
2. Save the files to a local directory.
3. Make the script executable and run:
```bash
chmod +x run_repro.sh
./run_repro.sh
```

The reproducer script attempts to migrate the 50GB of pages from NUMA node 1
to node 0, which stalls on draining the LRU cache, and systemd hangs for 3-5 
minutes.

The following patches fix this problem by:

1) Adding HK_TYPE_KERNEL_NOISE back to the test in cpu_is_isolated().
2) Keeping unbound kthreads off nohz_full CPUs when fetching kthread affinity.
3) Bypassing per-CPU LRU/mlock batching on isolated CPUs, committing folios
   directly to the LRU lists instead.
4) Draining per-CPU LRU batches when CPUs become isolated at runtime.
5) Allowing cpuset.mems writes opened with O_NONBLOCK to migrate memory
   asynchronously without blocking the writer in task_work.
6) Dropping the redundant workqueue flush in cpuset_fork() so forking tasks
   do not block on asynchronous memory migrations.

Please have a look, and please let me know if you have any questions or need
any more information.

Thanks,
Matthew

Caron Wills (6):
  sched/isolation: Consider nohz_full CPUs isolated in cpu_is_isolated()
    again
  kthread: Keep unbound kthreads off nohz_full CPUs
  mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on
    isolated CPUs
  sched/isolation: Drain per-CPU LRU batches when CPUs become isolated
  cgroup/cpuset: Don't wait for memory migration when cpuset.mems is
    written with O_NONBLOCK
  cgroup/cpuset: Don't make a forking task wait for memory migration

 include/linux/sched/isolation.h | 10 ++++++-
 kernel/cgroup/cpuset.c          | 50 +++++++++++++++++++++++----------
 kernel/kthread.c                | 30 +++++++++++++++++---
 kernel/sched/isolation.c        |  8 ++++++
 mm/folio.c                      | 21 +++++++++++++-
 mm/internal.h                   | 28 ++++++++++++++++++
 mm/mlock.c                      | 28 ++++++++++++++----
 7 files changed, 148 insertions(+), 27 deletions(-)

-- 
2.55.0


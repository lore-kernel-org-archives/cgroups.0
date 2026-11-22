Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.127
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315673;
	b=1SB1Dr+4cbxUDGeJDXQ33B1SKoRDJjU+Iqsm2x7XJvMRzhaNT6P3O+Cec3Jv41R/pOLn
	 zdCd5M4Zma6yILcnSIQkK28mcdjq7v6+7jyz8qYWDaIRV/pKNioAUdUv+p9ZUgUz0yvHZ
	 vHW27mdDVYTzXd9mSUd93EXB3xu3CrZg1U3FrC9kScWc3ofiHl6d2p9lDOXMXgR1Cxzqw
	 Ew3y/8lTZR8HOQqEm0X7/dG0B5I21Xmhvvsy5TuP1SoGxXY/+D5TVYpSh1Lay9vb4Alnc
	 5fzsjeq18LE/aPA3no1romCvPp1pBN/9xGz2odTVjOdgDy4KRIpfayqIciQVp/eP88Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315673;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bOrv+xLYUsaUyXaSe+BARibazXC+W+FOt8ErwK+aCss=;
	b=adTD2wb79l7BR9YbebBGrQAHtbloj2Abav5PIh3A5WrLapgLwyr650o3yI2p5PWZvCz5
	 O91GG85Ebj1u/wLjiuck1fclzy8UjtUO8AC+SNFLClgS7dnUETl9IWu/khO4dljAvcemA
	 CHTRaGvPnStBSzCEPVwVlfcI1Pvkva0fgLg2cGMLOmBrWOiL1yg1sZySk0jPqF1x9o/Up
	 5hs5+D45R0v+1GEApWaloir2IMr1ta+xy8fL9ldcD3qAJDjmDyRRlCMsA1lfEcUe8afQa
	 wdPTjTD14J2Uym8ybSD/fM+aCcF/CuuuWV1w2NIXd909Ub2uzH6uHLJqq4qidfcfQ6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GvsIzOyn;
	arc=none smtp.remote-ip=95.215.58.127
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0AE606A68C
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 02:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF0AE606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GvsIzOyn
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rzojMZvLtM9+3SwUWO3HxhYcavbGDeGlgbRtLOpYVG4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315670; v=1; x=1795920470;
 b=GvsIzOyniRqJWLrSd29NQaoEIkIBRxfPl1mYz3guSdKs+KeehSOg3M+BN50opEeuSqRggTiN
 CrDymRoMXbaBZOcBSu1ZvDpQZo+XbrlbHRZH2prtGrrSy/q2pdLsCv2fj5vqqm0m0DMxFHjbCmv
 Q1sqNC33JjQdqb18hpwpuG/8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 313eb3f773ebefb2;
	Sun, 22 Nov 2026 02:47:49 +0000
X-Mizu-Trace-ID: 313eb3f773ebefb2
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/7] memcg: effective high limit that avoids isolation issues
Date: Sat, 21 Nov 2026 18:47:30 -0800
Message-ID: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
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

(My initial plan [1, 2] was to track kernel lock holders, let them
bypass memcg limits and throttle them on unlock or on return to
userspace. I was asked to look for alternative solutions, and this
series is one.)

memcg limits can cause isolation problems. A task stuck in limit
enforcement in the charge path keeps holding its locks, and tasks in
other cgroups that need them wait for a limit that has nothing to do
with them. btrfs, for example, charges its tree blocks to the root
cgroup for this reason [3].

We see this in Meta's fleet. Over 28 days, on several tens of
thousands of unique hosts, a bpftrace script [4] recorded sleeping
locks held in memcg reclaim while another task waited for them. Most
belong to the reclaiming workload, like its mmap_lock (680,579
times, up to 4.7s), but some are shared by the whole machine or a
whole filesystem:

- cgroup_mutex, used by every cgroup change. mkdir charges the new
  memcg to the parent while holding it, and reclaims if the parent is
  at its limit: 350 times, up to 2.5s.
- kernfs_rwsem, used by cgroupfs lookups. The kernfs notification
  worker held it while queueing inotify events charged to the
  watcher's cgroup: 2,324 times, up to 3.3s.
- btrfs tree locks, used by every b-tree search and change. On kernels
  with [3], the XArray nodes that index tree blocks are still charged
  to the task, so tasks reclaimed with tree locks held 2,853 times,
  850 of them with a root node locked, up to 2.6s.

Hung-task reports show worse cases. A container's systemd created a
cgroup while its own cgroup was over memory.high, and mkdir ran
memory.high reclaim with cgroup_mutex and the parent directory's lock
held for over 30 minutes. The host's systemd, tasks forking into
cgroups, oomd and a monitoring agent all waited, so the userspace OOM
killer could not even read the cgroup tree.

memory.max is a hard limit, so this series does not change it.
memory.high doesn't have to be enforced in the charge path: since
commit b23afb93d317 ("memcg: punt high overage reclaim to
return-to-userland path"), the charge only records the overage (usage
above the limit), and the task reclaims and is throttled on return to
userspace, where it holds no locks. Avoiding this priority inversion
was one of the reasons for that commit.

But return to userspace is too late when one system call charges a
lot, like mlock() of a large range. So commit c9afe31ec443 ("memcg:
synchronously enforce memory.high for large overcharges") handles the
overage in the charge itself when the charge can block and more than
a batch is pending. That brought the problem back: the task reclaims
and sleeps, up to 2s per call, under whatever locks it holds. It also
misses THP charges outside MADV_HUGEPAGE ranges, which can't block
under the default defrag setting. RESULTS shows both problems.

This series is a first step in rethinking the memcg high limit around
isolation. It makes memory.high enforcement asynchronous (to
allocation and charging) again and keeps it effective for large calls.
The task handles the overage on return to userspace, and also inside
the operations that can charge a lot in one call, where it holds no
locks or only the locks of the file it works on:

- Populating memory (mlock, mlockall, MAP_POPULATE, MAP_LOCKED,
  MADV_POPULATE_*): 2M at a time, with mmap_lock dropped in between.
- tmpfs fallocate, buffered writes (generic_perform_write(), iomap,
  btrfs) and reads into user memory (filemap_read(), shmem): once per
  folio or range.
- MADV_COLLAPSE: after each collapse, with mmap_lock dropped.

These points also throttle THP charges, which the synchronous step
skips. A file's lock only blocks tasks using that file. Two cases hold
more: splice() from a pipe also holds the pipe's lock, and gfs2 holds
its allocation glocks in writes that allocate. The synchronous step
sleeps with these locks today too.

Why not keep the synchronous step, with a higher threshold, without
its sleep, or only outside these operations? It would still reclaim or
sleep under locks, like mmap_lock in THP faults and invalidate_lock in
readahead, and it would not close the THP gap.

This also lets users drop memory.max, which still reclaims in the
charge path and can stall lock holders as above. They can set only
memory.high and let a userspace OOM killer like oomd [5], or a future
BPF OOM policy [6], decide when to kill. Meta plans to do this.

The last two patches remove the synchronous step, update the
memory.high documentation and fix test_memcg_high_sync, which missed
the THP gap.

RESULTS

Tests run in a VM with 4 CPUs and THP on for anonymous memory and
shmem (enabled=always, shmem_enabled=always, tmpfs huge=always, the
default defrag=madvise), in a cgroup with memory.high=64M. Reads go
into an untouched buffer. "No hooks" is the base plus only the patch
that removes the synchronous step. Usage 18s into a 512M operation,
without swap:

  test                                    base  series  no hooks
  mlock, mlockall, MAP_POPULATE,      513-514M     84M  513-514M
    MADV_POPULATE_WRITE
  tmpfs fallocate and write           512-513M     84M  512-513M
  reads of a tmpfs file                   513M  84-85M      513M
  MADV_COLLAPSE of a sparse range          96M     98M      514M
    (one VMA, or one VMA per PMD)
  reads of /dev/zero or /dev/urandom      513M    513M      513M
    (known gaps)

Usage grows by one 2M folio per throttle, so it is 84-85M after 18s.
On ext4, XFS and btrfs, 256M writes stay at 64-67M on both kernels
(257-264M with no hooks), and reads with a cold page cache at 70-73M.
Reads with a warm page cache, where only the buffer is charged, reach
257M on base and stay at 84-85M with the series.

With swap, the MAP_POPULATE, MADV_POPULATE_WRITE and tmpfs write tests
finish in under 2s at 65-66M with the series (base: 157-169M, no hooks:
513M). tmpfs fallocate is throttled with or without swap. With swap,
base fails it with -ENOMEM for small pages.

During mlock() of an 80M MADV_HUGEPAGE range, a task in another cgroup
that reads the process's /proc/<pid>/cmdline every 10ms waits up to
15.3s on base and under 1ms with the series. Populating 2G with no
limit takes the same time on both kernels.

All patches build with gcc and clang (W=1), with CONFIG_MEMCG=n and
with btrfs as a module. A lockdep kernel showed no warnings. The
memcontrol selftests pass, and the fixed test_memcg_high_sync fails on
base.

KNOWN GAPS

Other paths that charge a lot in one call are now throttled only on
return to userspace, and memory.max still limits them. Most can get a
throttle point later, some after dropping a lock:

- /dev/zero and /dev/urandom reads, getrandom(), sendfile() to a
  socket, io_uring submissions, netfs and FUSE write-through writes
- MADV_WILLNEED, UFFDIO_COPY, KSM unmerge, mprotect() of mlocked
  mappings
- FIDEDUPERANGE, FS_IOC_ENABLE_VERITY, KVM_PRE_FAULT_MEMORY,
  guest_memfd fallocate, KVM page splitting

Rarer ones, like sendmmsg(), btrfs send and FITRIM, can wait. Memory
pinning (VFIO, iommufd, RDMA, io_uring buffers, direct I/O and
others), fork() and single large allocations (BPF maps and others)
hold a lock for the whole call or can't be split, so they stay as they
are.

[1] https://lore.kernel.org/20260924155025.949998-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/
[3] commit cf1dec76ba8a ("mm/filemap: add AS_KERNEL_FILE")
[4] https://github.com/bpftrace/user-tools/tree/master/reclaimlockmonitor
[5] https://github.com/facebookincubator/oomd
[6] https://lore.kernel.org/20260127024421.494929-1-roman.gushchin@linux.dev

Based on mm-everything-2026-11-20-06-34.

Shakeel Butt (7):
  memcg: add helpers to handle memory.high overage in long operations
  mm/gup: handle memory.high overage while populating
  mm, fs: handle memory.high overage in buffered reads and writes
  mm/shmem: handle memory.high overage in fallocate and reads
  mm/khugepaged: handle memory.high overage in MADV_COLLAPSE
  memcg: remove synchronous memory.high enforcement
  selftests/cgroup: make test_memcg_high_sync check that throttling
    holds

 Documentation/admin-guide/cgroup-v2.rst       | 12 +++++-
 fs/btrfs/file.c                               |  9 +++++
 fs/iomap/buffered-io.c                        |  9 +++++
 include/linux/memcontrol.h                    | 34 ++++++++++++++++
 mm/filemap.c                                  | 31 +++++++++++++++
 mm/gup.c                                      |  9 ++++-
 mm/internal.h                                 | 27 +++++++++++++
 mm/khugepaged.c                               |  8 ++++
 mm/madvise.c                                  | 11 +++++-
 mm/memcontrol.c                               | 21 ++++------
 mm/shmem.c                                    | 37 ++++++++++++++++--
 .../selftests/cgroup/test_memcontrol.c        | 39 +++++++++++++++----
 12 files changed, 217 insertions(+), 30 deletions(-)


base-commit: b298839c2f77b60eea645a68d2245aa088463955
-- 
2.53.1-Meta


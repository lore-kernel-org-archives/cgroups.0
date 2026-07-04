Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3392F1F4180
	for <cgroups@vger.kernel.org>; Sat,  4 Jul 2026 04:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783141001; cv=none; b=tHIYTLd1QtyyRS3OKjzz6C0ZTZOAZTqNAGyXXLmNYsSRQPfXj44s//E5hKY/nfDL2u/0s+PAcEcGJ2xyWRjb8Yb1tvTDqKqfcBCZve67YDQaAEDTIvmJlfNHE9u6nMsAE2yxClGWerDFLpa6OzZtRT2VpjdwQ72dUA+8VyW+8Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783141001; c=relaxed/simple;
	bh=FsK/anu7ld8yItLaJL7sUTnonSkqW/HBxWodktHytME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pt1UMuTbsnBhoOSKOUO3YJzc27s0cX/PLiF8liXh5NThquCXfAysOIi9bzVs+Y3hwcaTjmwVidee7GJv/+RZH5QzcuA8BcDBPzzm76avV3cL55nqMzi/jzVHFL4EDUhcdI+59ZQmBlD3vxv3plOnBgPoE+DiZyAgWgmqRGrWt8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qjYHBIXR; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qjYHBIXR"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2cace91f112so9247615ad.0
        for <cgroups@vger.kernel.org>; Fri, 03 Jul 2026 21:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783140999; x=1783745799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YFwGSAkhDwqUDzFEg23WMafmVyoQV+WTTBxYcFcn7YY=;
        b=qjYHBIXReI8+Luk/v4kzjW06xcFQQp6wAhFdsEFMWuCmDHQyuvKO4Pn6fusnHnQXsm
         IMgsjxBzr784Pv82RIQIewpNz0I1I7qItR3u1s9/wHWjAcwHHWzly8bnv9YSNtspaO60
         kntKnt39imP4p6diQ8bRkwErs9o7DQ2Odu0/2pLe8brs8c5gp7kQCaTL/MEmFtsc/SC3
         jnPv/HS8dmv/TzCQ1J4wgNVbCA032vRIV+FJP/YiAsE7SB+KFHy6LpcJwKKh6CsQPPuz
         ShpcGDBey39s67+C91p8ToCcDnCJsmdVCgTNaBu7Al6zWNe6/ZHZZJIFbzLehWC+6Xt9
         jSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783140999; x=1783745799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFwGSAkhDwqUDzFEg23WMafmVyoQV+WTTBxYcFcn7YY=;
        b=AVYIRf5ml5o8NhpyMad8eCh1nvLH6Yk+/8AMkt8IGttgwwItdOnLRJ+jt1c+zWqFub
         9u70H+GPn4pnJo57DA4wGpQZIfqtwOtu4AaowCwE3rIIDElRFXzqFVtfG92uUCOYEqH0
         UFGqVOrla1JE32L2KJlOXjB3NGtZXQ6Ne4eZpoqf3gu/9OP5PzgLaAl/2H1ePjFwRgVi
         4ITb5AIjLi7eB1/ZFPLP0cuekFlntH4RB0hVTQHhMipmednasHOK9QHFyEnRVtxqYTx3
         J4OC8MG3PFvdvy/4rKW4Vjt0fT21X/B9j4PnOG0afTxE2r3ErjtqZRZsRlhdiRYy4aib
         tjOA==
X-Forwarded-Encrypted: i=1; AHgh+Rreikw3/BjQPhzfmM+amn9OKkWzl0tRcxfUyIXraV5iXWlNXeUi+CWBx21usJ8oT6zu8y0ef/RW@vger.kernel.org
X-Gm-Message-State: AOJu0YwJgZY3W75NildXAgUg1P2CBRza6rCPwYf6pElMLFXiZWHTJQK+
	3PtK52UYU2qage8evMCqzmwASoV/RkC27YqM7Xp2z/dkxUFTPWalpuHt
X-Gm-Gg: AfdE7cn7E2U4bIyK2LhkSDpFXP4ykuGtQeRGyBeeChsL1PnsR2jzeyEjh0+ZmKFOD0I
	AbEZjKkgyN5EVM2IvLTxVCC184euUPt2YnZ/13xdjCTpsU6L8d6LLdVyTJWaIT0f6r4T8Teyvdl
	uTjNQgLCtY8XaMTK17UspZxlqEp0R2XbNIqLypok0oN6cCsPT7TSGOd39CgDwfRtEvp6oDz/5+Y
	nfVPxi+lA7iBXXavfTlk5sB3kUhN6cj/OsHIiSGBaePcT71ibboLgVunwljSBGveZQp+hf8ePXk
	IXm+uvbggyIjH9VZCuoJJYmpaLCFRCD71nW6ISrXj/q6+cHwqWiyOMts6a2gNyUtnl+XsUzOvgK
	2xyVdlxxfiDg1G0zn9sI4eZeikC9kaP3jQLd5Q4r7rRigWczG1XYx5YNhETdl9vldgq0n
X-Received: by 2002:a17:902:ecc8:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2cbb9ecf4b0mr20612325ad.38.1783140999401;
        Fri, 03 Jul 2026 21:56:39 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa566sm24021975c88.4.2026.07.03.21.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 21:56:39 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	bpf@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg stat readers
Date: Fri,  3 Jul 2026 21:56:14 -0700
Message-ID: <20260704045617.487664-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dear reviewers,

This is my first attempt at contributing to the Linux kernel. I am doing
an internship at Meta on the Linux team, and have recently been learning
the basics of the memory controller (cgroup v2) and BPF. I find these
topics really interesting; to help other beginners like me understand
how BPF is used, and to make a small contribution to this great
community, I wrote a few self-tests that compare two ways of reading
memory-cgroup statistics for a whole cgroup subtree:

  (A) the traditional path: open, read and parse memory.stat (plus
      memory.current / memory.max) for every cgroup from user space; and

  (B) a BPF path: a single SEC("iter.s/cgroup") program walked over the
      subtree that calls the memcg kfuncs (bpf_get_mem_cgroup,
      bpf_mem_cgroup_flush_stats, bpf_mem_cgroup_page_state,
      bpf_mem_cgroup_vm_events, bpf_put_mem_cgroup) for each cgroup and
      stores the results in a hash map, drained once afterwards.

The series builds on the memcg BPF kfuncs (mm/bpf_memcontrol.c). When those
kfuncs are unavailable (for example CONFIG_MEMCG=n) the tests skip cleanly
rather than failing to load.

These tests may also be useful as a small, self-contained comparison of the
BPF cgroup iterator against the file-based interface across cgroup trees of
different sizes and under different load. The pass/fail result of every test
depends only on the correctness / structural checks; the timing tables are
informational and are printed only under -v (or when a test fails), never on
a normal PASS.

The patches are:

  1/3 memcg_stat_reader - reads a quiescent (charged once) subtree both
      ways, asserts that the BPF snapshot agrees with memory.stat for the
      anon counter (which is rstat-flushed and deterministic), and reports
      the wall-clock cost of each path. It also adds a small
      read_cgroup_file() helper to cgroup_helpers (the read counterpart of
      write_cgroup_file) and selects CONFIG_MEMCG=y in the base selftest
      config.

  2/3 memcg_stat_churn - runs the same comparison while the tree is under
      continuous allocation churn (one busy mmap()/memset()/munmap() process
      per selected leaf), so each read pays a realistic rstat flush. It
      reuses the BPF program and map from patch 1 verbatim; only the
      user-space load model and sampling loop are new. Pass/fail is
      structural only. This is a closer simulation of real-world
      workloads than the first test.

  3/3 memcg_stat_churn_percpu - extends the churn test to make the
      per-cgroup cross-CPU rstat flush fan-out an explicit knob: each
      churner migrates across K CPUs, so a cgroup's statistics become dirty
      on K CPUs and a reader's flush must visit K per-cpu trees for it. This
      shows how the cost of the two readers changes as that fan-out grows.

In my testing (a 60-CPU VM) the BPF path is roughly an order of magnitude
faster than the per-cgroup memory.stat parse for a whole-tree scan, mainly
because it avoids the per-cgroup open/read and string parsing. The gap
narrows as the rstat flush that both paths share grows larger, for example
when a cgroup's statistics are dirty on many CPUs at once. The exact numbers
are included in each patch's changelog.

I used AI tools in part to help me understand these subsystems and to help
write the code. I have reviewed all of the code myself.

I would be very grateful for any feedback, and I apologise in advance for
anything I have gotten wrong. Thank you for taking the time to look at this.

Have a good day!

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

Ziyang Men (3):
  selftests/bpf: add memcg_stat_reader BPF-vs-memory.stat benchmark
  selftests/bpf: add memcg_stat_churn BPF-vs-memory.stat benchmark under
    churn
  selftests/bpf: add memcg_stat_churn_percpu BPF-vs-memory.stat
    benchmark under cross-CPU churn

 tools/testing/selftests/bpf/cgroup_helpers.c  |  46 +
 tools/testing/selftests/bpf/cgroup_helpers.h  |   2 +
 tools/testing/selftests/bpf/config            |   1 +
 .../testing/selftests/bpf/memcg_stat_reader.h |  35 +
 .../bpf/prog_tests/memcg_stat_churn.c         | 716 ++++++++++++++
 .../bpf/prog_tests/memcg_stat_churn_percpu.c  | 902 ++++++++++++++++++
 .../bpf/prog_tests/memcg_stat_reader.c        | 617 ++++++++++++
 .../selftests/bpf/progs/memcg_stat_reader.c   | 181 ++++
 8 files changed, 2500 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/memcg_stat_reader.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_reader.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_stat_reader.c

-- 
2.53.0-Meta


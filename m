Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2CC3C0A0A
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086172; cv=none; b=adI59wqJ+t5QBqglAs7eHWqJ8Hz3VTVPJa+cJAhaqBzdfIRtMet9zw4eEQDxPXdvF5IUDiKAs0wgJ/pPnxpxO+mI/puGdCeO/H1aS26nU9XUXOAC+I+PsKxvty39ZMM6wE9Npv3mGmGoqhF6RfMoNIbfgXqQD8dWnO8s6WtHhlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086172; c=relaxed/simple;
	bh=jj0xXLdHnLuNFtjAp+3mACkjm4GQ1ncXGwUUFMTgays=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fUCEbTLY5aLoMslGLyH5bZUgofXq9iLc7mlYNlsncJ4vfPlZh1Sv4EHpEZIEmwKBexZNABeuoKWMJlIPqT4lOzvQYaZdoeKovLUUybZKN7CPhWnzgAFzW7G8XNoj8f9QWEJp7/J+rAXVQ/fm7oSZSkAPSdbg3SYW8vBB60HBclk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cNegDMuz; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cNegDMuz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=smuGmk21K57soIDpX9xRt9BbzTPX01FIBsuhki3qxVU=;
	b=cNegDMuzfa9tQvyToC72m0ArSkyHVD+RaagQzGD/nqOzWZp9fdoQEvmCuAPDDaArgiUcrS
	tBri5clUOgq5GZKRHqx5P8jsuV8XS5iJRyciRc5F1Ld9ynhPL11ucRX4HHZFIx/f1kK8CL
	vMtTZyhZ1z07gaXJo5/qsxGChKcFDM4=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 0/4] bpf: BPF-driven proactive memcg reclaim
Date: Fri,  7 Aug 2026 15:01:48 +0800
Message-ID: <cover.1786086076.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

This series lets a BPF program decide when to trigger memcg reclaim
and how aggressively to do it, based on whatever runtime signal it
chooses to observe -- rather than reclaim only being triggered once a
cgroup's usage crosses a fixed threshold. The core idea is a new kfunc,
bpf_try_to_free_mem_cgroup_pages(), which gives BPF direct access to
the reclaim path so this decision can be made in BPF policy rather than
hard-coded threshold logic.

This was originally part of a larger series posted here [1].
That series also adds a memcg BPF struct_ops (memcg_charged,
memcg_uncharged, below_low, below_min) for synchronous, in-line memory
protection decisions. That mechanism and this one solve different
problems -- struct_ops hooks run inline on the charge/reclaim path,
while the kfunc here is for asynchronous, out-of-band reclaim decided
independently by a BPF program -- so I think they're better reviewed
as separate series rather than bundled together. This series carries
only the async reclaim piece: the bpf_try_to_free_mem_cgroup_pages
kfunc (patch 1), plus a new bpf_thread_wq mechanism (patch 2) that
grew out of discussion here [2].

Patch 1 adds bpf_try_to_free_mem_cgroup_pages(), a sleepable kfunc
wrapping try_to_free_mem_cgroup_pages(). With it, a BPF program can
reclaim from a given cgroup on its own terms -- any condition it can
observe at runtime -- instead of being limited to "usage hit
threshold X".

Patch 2 adds bpf_thread_wq, a bpf_wq-like map field backed by a
dedicated kthread_worker rather than the system workqueue, which can
be attached to a specific cgroup at init time. The motivation is
accounting: reclaim work triggered from BPF still costs CPU (and can
itself touch memory), and running it via a plain irq_work/system
workqueue callback would charge that cost to whatever context happens
to run it, not to the cgroup the policy cares about. bpf_thread_wq
lets that cost be attributed to a chosen cgroup instead -- e.g. the
low-priority cgroup being reclaimed from.

Patch 3 is a selftest that exercises bpf_thread_wq's cgroup attachment
in isolation: verifying the callback observes the target cgroup when
one is given, and does not when it isn't.

Patch 4 (selftests/bpf: add memcg async reclaim test for
bpf_wq/bpf_thread_wq) ties patches 1 and 2 together as a worked
example: it watches the WORKINGSET_REFAULT_FILE counter of a
high-priority cgroup as a proxy for memory-pressure impact, and once
it starts climbing, proactively reclaims pages from a low-priority
cgroup via bpf_try_to_free_mem_cgroup_pages, running that reclaim
inside a bpf_thread_wq attached to the low-priority cgroup so the
reclaim cost lands on it rather than leaking into an unrelated
context. This demonstrates the end-to-end use case: BPF observes
pressure on the cgroup it wants to protect, and reclaims from the
cgroup it wants to charge, in one self-contained mechanism.

[1] https://sashiko.dev/#/message/cover.1779760876.git.zhuhui%40kylinos.cn
[2] https://sashiko.dev/#/message/1b58d56976202f26818d31dbd0da2ecb2e2460f5%40linux.dev

Hui Zhu (4):
  mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
  bpf: add bpf_thread_wq kthread-backed workqueue with cgroup placement
  selftests/bpf: add thread_wq cgroup test
  selftests/bpf: add memcg async reclaim test for bpf_wq/bpf_thread_wq

 include/linux/bpf.h                           |  15 +-
 include/linux/cgroup.h                        |   2 +
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/btf.c                              |   7 +
 kernel/bpf/helpers.c                          | 418 +++++++++++++++
 kernel/bpf/syscall.c                          |  15 +-
 kernel/bpf/verifier.c                         |  44 +-
 kernel/cgroup/cgroup.c                        |  13 +
 mm/bpf_memcontrol.c                           |  58 +++
 .../testing/selftests/bpf/bpf_experimental.h  |   7 +
 .../bpf/prog_tests/memcg_async_reclaim.c      | 479 ++++++++++++++++++
 .../bpf/prog_tests/thread_wq_cgroup.c         |  87 ++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 255 ++++++++++
 .../selftests/bpf/progs/thread_wq_cgroup.c    |  56 ++
 14 files changed, 1455 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/thread_wq_cgroup.c

-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793092352;
	b=qOJGHUwlYIYN2xvh9uF2tcNx4xm3atn9lH7zn6Qx3cYyo3ocHML4UxsZiu/iGrxqchV4
	 Ve5bOjBWg6ANcQ/b2x8MPW4djG9siyEjZK5DFmIV6n+4hs2KMBiOocV6d5cOect7oxXmP
	 1/F3ETLQ4q7fRzt0MyFaiz5iTeIVqFCS+4T/g2D9XHhXFGvfU7rLlgCk5vBjQgapb4isr
	 m4aDYIaJxfM/CbFGlNjhnko6HmNq2a5G6AcFhPmZjQwvfr082esRVlOrxl4EnaYRoEQSZ
	 yeXeFmNYFY16L44i4U8E3XNybO1Zl9so4mUvLATkBGXU/VhzN2b79jvyyUK3Dt6WYIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092352;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Ndi2448wVUZuF68kqWF0v2z9NaMIBNKc9nVCJQzYI1k=;
	b=hjp2hzfdzYqJFWj4JKlcq52cYz1h5HMZhxcdiMITpVAqMQvFSVMadr6+iJUPpa/pkfTd
	 VKWJ9cKTwaZiHoV2503cksaKu63j6yLOBKEL7jEdtJFW1UV1vE2c9aXphE+OjYwI+cKGQ
	 /42Yqru4mCyyuPo9MEzRFU3TBBPYfF9BubVVEeFivxrx3UdYsX/gzC+qBbwQcMtleIkeU
	 5J/EiYUuxOWoFpXY6YD6XSeD72lgNE98PEav02uWAu3k5NwgBAH9tSxkvJOOCvBqRAcym
	 l1jTAQuQk6Oh/8NLaUGY0394TrtOEUg1YdVrsYYCHgIFW0HHemn+Ebm5U3mwEWwzQJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="bA2/gm+I";
	arc=none smtp.remote-ip=95.215.58.50
Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA39606A31B
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 09:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AA39606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bA2/gm+I
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Iy2EZRXCQMOBxljPF+GT6qR9TSW/M2vcb/khwUxJInc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793092348; v=1; x=1793697148;
 b=bA2/gm+InVPxrA8/cUeuKfkv9tlw8WkJfCJkOBEDJtQCHB0HWSave9Iz76npyrcxJMqpPc1t
 uCc6jbvmBvAjzUUwt9MB4DHn/lLKKxWsS6jwJ3eh4ZlxhovExca29l8pVbWHLXsWABOthurUun7
 yDoOp3aXMoQ0FUfbTaxkhPds=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id e68cbb451e1e33a5;
	Tue, 27 Oct 2026 09:12:27 +0000
X-Mizu-Trace-ID: e68cbb451e1e33a5
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
	JP Kobryn <jp.kobryn@linux.dev>,
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
Subject: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min protection
Date: Tue, 27 Oct 2026 17:11:58 +0800
Message-ID: <cover.1793086858.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
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

From: Hui Zhu <zhuhui@kylinos.cn>

This follows the memcg_ext RFC [1], which adds bpf_memcg_ops - a
struct_ops type attaching memory controller policy to a cgroup - and
one member, high_policy().  Its cover letter names dynamic protection
as future work; these two patches are that.

Why it matters: memory.low and memory.min protect a cgroup by a fixed
threshold and have no idea whether it is using the memory.  A
high-priority cgroup that holds a large working set and then goes idle
keeps suppressing reclaim on its siblings, and that memory is wasted.
A policy program sees the real activity - page faults, charges - and
can grant or withdraw protection as it changes.

The hooks are not new: [2] proposed the same below-low and below-min
decision on its own memcg_bpf_ops type.  Only the carrier changes
here.  bpf_memcg_ops already supplies attach, the ancestor walk,
result combination and the re-entry guard, so protection costs two
members and one walk helper shared with high_policy().

Patch 1 adds low_policy() and min_policy().  A program gets a
read-only snapshot of the check the kernel is making - the memcg, the
reclaim target, the threshold and the usage - and returns a request;
BPF_MEMCG_PROT_BELOW, the only one so far, treats the cgroup as below
its threshold, so reclaim skips it and counts it in memory.events.
The kernel compares elow/emin first and asks BPF only when it found
the cgroup unprotected, and ORs the answers of the cgroup and every
ancestor, so a policy can only add protection, never take it away.

Patch 2 is the prog_tests runner: attach both policies to a child,
fault 8M of anonymous memory into it, reclaim from its parent, and
check that both hooks were consulted and that the ctx described the
check faithfully.  Both answer NO_OPINION, so nothing about reclaim's
outcome is asserted.  A working example that does answer BELOW, so
reclaim skips one cgroup and takes the memory from a sibling instead,
is maintained out of tree at [3], released under GPLv2.

[1] https://lore.kernel.org/all/20260921192559.2619635-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/all/cover.1779760876.git.zhuhui@kylinos.cn/
[3] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_plus

Hui Zhu (2):
  memcg_ext: add memory.low and memory.min protection policies
  selftests/bpf: Add bpf_memcg_ops protection test

 include/linux/bpf_memcontrol.h                | 104 ++++++++++-
 include/linux/memcontrol.h                    |  23 ++-
 mm/bpf_memcontrol.c                           | 162 ++++++++++++++----
 .../bpf/prog_tests/memcg_ops_protection.c     | 151 ++++++++++++++++
 .../bpf/progs/memcg_ops_protection.c          |  72 ++++++++
 5 files changed, 470 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_protection.c

-- 
2.43.0


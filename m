Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794504472;
	b=RmEq5X+XqJJaW7g3KQU1eZ9OccffFtFWC9y+fKCxigmRtP5Llu/Q/u+slPWvLSJsGYAl
	 rAjs6ylq6QKFA2p6Qm2kK33UnXzzYt+QpCGeozjCY9ABEqDlY+J0SPhxv0Mehvvd7dk0u
	 BZgoLhoSbtbORKV/JxRs2oWehix1P27XvOgq94tqEo0aqSH7+3BOlBtGYeEnU5hx8l8Mt
	 OqEcaSNj2Bh/sgJKivlKChZrppmIIi4dmR2SDdj9bsv37Rf47U2Pak43LS+LHxzYtcClF
	 mSNpp6TJtfZIzDWbdd6Pe2Rfa+bU7b/7FoPpMDDlkH6Sbqyn5gv8fuQG2ElwjB0GpMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504472;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vx5w0fm9h8v5n62PQL9iExcxSEIFCRvNTIp+UzuHmzc=;
	b=un7FHDNOv/zlWn/VMoVcW7fSOtxt9mLbcp5wqQy6CSurPHsUMqYEWj7CRBfFu1XfYSnT
	 68Xx6/6teC/IX9cEHCHb9vEfD0yy23OEPpYLle7vMI2QndN2NnCzcozQAQ8aUeGqHsxiN
	 hZNUSsHCJWLugqgfU44O279QGNdSgV2lAcKP0JQ0LvVZAFlSObzF7HpnHJmIrfSe2w14W
	 IAe6h7RIL+k7OwYo1e9d2KjV5WSf8DokdZaqck3U1ICL/P/hy+o+96O8A8D59RI6mql09
	 x7+KaDxbIHhya0m+edDqNAeYh07S2+mcbdvYAsuyGm6CsMUI6tmHst2dSL0FnYm3sFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="E66JfS/S";
	arc=none smtp.remote-ip=91.218.175.144
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F30606A323
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 17:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16F30606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E66JfS/S
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PRA9hilCOAvyfJtG+XpLHywnfM53VKvxUll8kJ4luZM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794504469; v=1; x=1795109269;
 b=E66JfS/SRrOD0UJf6/ME6wXYS4FtrU3K4Q7CPv5Gw7Xo+2orO1NpP1A8IV8gUm69yPZ8InAj
 8HwOmg7pmNvIyf/h3xeHS4yzOqWLtZbs9Er8XrvB7BtPTfdf/oDiR7XVlQVgdw+0qD/Yu2XHa+i
 UjVMlmYXWvoanjVuf5zsW+kE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 34b2f950337f546b;
	Thu, 12 Nov 2026 17:27:48 +0000
X-Mizu-Trace-ID: 34b2f950337f546b
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Amery Hung <ameryhung@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/3] bpf, cgroup: Don't wait for cgroup_mutex to read or free cgroup bpf state
Date: Thu, 12 Nov 2026 09:27:12 -0800
Message-ID: <20261112172721.440275-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
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

In the Meta fleet, BPF_PROG_QUERY callers, link-info readers and the
cgroup bpf release work often wait minutes for cgroup_mutex. The holder is
almost always a cgroup mkdir or rmdir stuck on kernfs_rwsem. In one day,
hung-task reports showed this on 1,075 hosts (query), 94 hosts (link info)
and 458 hosts (release work).

Patch 3 gives the cgroup bpf state its own mutex, so these paths no longer
take cgroup_mutex. Attach, detach and replace still take cgroup_mutex
first, because they walk the descendants.

Patches 1 and 2 fix two old races. Attach and query get the cgroup from an
fd and take the lock later, without checking whether the cgroup's bpf
state was released in between. An effective query then reads freed memory
(patch 1). Attach leaks the program, or with cgroup storage writes to a
freed cgroup later (patch 2). Patch 3 makes the attach race easy to hit,
so patch 2 must come before it. Both fixes have Fixes tags.

Testing, in an x86-64 VM with lockdep, PROVE_RCU and KASAN:

- The 41 cgroup bpf selftests pass. A 60-second stress of mkdir/rmdir,
  attach/detach, links, queries, fdinfo, storage map free and sockets in
  dying cgroups shows no lockdep or KASAN reports.
- Debug-only delays reproduce both races. Without the fixes, KASAN reports
  use-after-free in cgroup_bpf_prog_query() and, with patch 3, in
  cgroup_storage_map_free(), and BPF_PROG_ATTACH leaks the program. With
  the fixes, attach and query return -ENOENT.
- While a mkdir holds cgroup_mutex for 5 seconds, query and link info
  return in under a millisecond instead of 4.6 seconds. Attach and detach
  still wait.
- Builds with CGROUP_BPF=n and with BPF_LSM=n.

Shakeel Butt (3):
  bpf, cgroup: Don't read freed effective arrays in BPF_PROG_QUERY
  bpf, cgroup: Don't attach to a removed cgroup
  bpf, cgroup: Protect cgroup_bpf state with its own mutex

 include/linux/bpf-cgroup-defs.h |   1 +
 include/linux/bpf-cgroup.h      |   3 +
 kernel/bpf/cgroup.c             | 158 +++++++++++++++++++++++---------
 kernel/bpf/local_storage.c      |   8 +-
 4 files changed, 123 insertions(+), 47 deletions(-)


base-commit: 0fb18ce8a2e9de830433923cf65838933d615359
-- 
2.53.0-Meta


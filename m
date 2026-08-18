Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CAE22126C
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 00:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787012695; cv=none; b=Qofp5hZ0R9rlJnGczIoClpGNIR0p6afc6FrffVWje2kOnOOKeg2qLI6b3UWGZCiASDszfyEPI/cCC5xcUJeT3Z+YeUofPDwt9olm49HZUi/tL2++WBEF5pN7xpbaUPpz986LtSEqyooF16vli/2UymXwvxomGZsAPIJrd6R/Y2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787012695; c=relaxed/simple;
	bh=qWRqvfmnNty80NoawIZpg8GiTpU1j9V039JR3Hleqg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YHOnFXAbB/UgtkJ4Y2HTv6qWoilV1aI61h5ChmdqRbA6xn2tuu7tyP1S45Z2FRREt4CF9TXk+QsD37AIB/+X9S/eeaF1xEL+HAMv9qZ8Glh6nlQ2aJhAOKt3FEZIxeIbMiOJz6mVWh9Po/3+63QgNq500cY8ad5zzMFl2yB0DAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXSrOccU; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXSrOccU"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e08baf860so4019798a91.2
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 17:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787012694; x=1787617494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XQzhuTEmSzFVRktqX1xn6ptqrzbe2xgge0zZzqfRxOc=;
        b=HXSrOccUFFHs/y8UgtdBxzzK6rYbzWVrbVupWEqVQP7QD+L1+5JMUb4bDRJIznS0OJ
         WW/yPAkPwh864IwLN3KS2ygMcnptY5b90KTyJjRf4mZeFKaIJU2pUWwDlmP515UKpxBC
         j9qOFX/JP/cLIdAI2xLTCajl1IpfF/gU0q6cfGgWrYmr1Xhc+gB4al54DImdU2g19xy+
         yh0yLJAR+LYlyoaq4RQrnJqheZFBt1527McScmewJpxrhdVXaqR5bKvLLsLggcX4pFNd
         xErBq9eUsdnKsTQBe7AZSOkGey/+pCIHxhniibUG6u5lNRW+8WusdUn6dxCgLI1wSkmq
         8siQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787012694; x=1787617494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XQzhuTEmSzFVRktqX1xn6ptqrzbe2xgge0zZzqfRxOc=;
        b=LEKOoZJTqsNVUS4KT1Js7kJuit+40MlOOrCzLZQw7FPwEeE6gWsK1UGhls7qqLcm87
         6FUE2mdnA8KzWEBXufhrCAtRv68vBx4SglyvWUmvkbB79c9kTLRLS1K+wlyYmhVPKKYT
         ZP0xeNXqrXzw/BeJP9dKBN564BIr6RU+wgRMTiHix6VUJLjwvddQ3LfpGIOMYLiV3JdR
         KMTe2Nmc/p3UhoGyrZ/3QR7TF5sbCiClNA/cr7J5jrYvZPQ5EMYV9A62yMB8mV47DeNQ
         exar316DX8zCn2raVnjqVqFFYVeWqZKEBpDYh2HfKseRRZrmIjC3l9515SWgBfiFug2J
         P9Iw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/GMNBBog3zrD/NahYV5syZq4AWG86uYPqPU5gB/yJn8J0SfYEgOUEi8MkLjjThF0+GXyj7Viw@vger.kernel.org
X-Gm-Message-State: AOJu0YyfxXyL3RGRBlgjyi/wLGqciS4bAxIri6hWKLSzaWwLVcTqcHIe
	c/to4gW6HmkBFjAHmF9zX8p57JI5QYEd2vp5CRx2+hjXlA44GfYy4zez
X-Gm-Gg: AR+sD13BLevuzBROcwoHe+TRmxEaF//eKko0XHAy7nTVeNNypSoPdFcInw1fE9Y7hA0
	cO7MVnBOnMMG3U22zYr4v6zM1q7zUR06KW71TawPoPhyqBe7d9I0AI8gXqvkpxMCwDwDWUlLiAh
	ghEkpCQcmhc+GS5+OufsYDBPT805VdHMvE0ETE7g3bU5r3K77c5ABKZ+q+M+EK1RhC1WsQL50XO
	rcm3HtZlIMVWiuqYFeA6JCQobIsc39jbp994nM9N0Xl9RjQeAyHVI/nfr04UdXGna7TOk8lsQuk
	jJbj+Qz/wjSMctjJ/NGmFZ7gEdPcC8ckbtu5Rf9qxBF3gFzjGPKcOBK/SjkP8knOh5dGBYbHW3d
	+dOFuJDbDWGptZ98DmkC2FYr+hKNmar5SsJO6W711Da2vFFR3zu3AM94Tq828sb5XYJOM/tdn79
	XEzqCy43XbWJylThlK0J+CTn7ILHca/DtLcaeUg1jwapDeAoZpPmjGNZU=
X-Received: by 2002:a17:90b:2c8d:b0:38f:caa2:5721 with SMTP id 98e67ed59e1d1-3933e62f4f8mr29637987a91.17.1787012693684;
        Mon, 17 Aug 2026 17:24:53 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:67::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dcedf4sm10261905eec.5.2026.08.17.17.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 17:24:53 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	kernel-team@meta.com
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] cgroup: expose cpu.stat to BPF
Date: Mon, 17 Aug 2026 17:24:48 -0700
Message-ID: <20260818002450.3071325-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the title suggests, this series adds bpf kfuncs for the cgroup CPU
controller.

Motivation:
Collecting cgroup statistics is expensive: the existing
method is to open and parse a cgroup file. memcg already has an
efficient alternative through BPF; this series extends that idea to cpu.

Design:
- Add bpf_css_flush_rstat() and bpf_cgroup_base_stat() to cgroup rstat.
  The second kfunc returns the raw cgroup_base_stat after the
  same cputime adjustment used by cpu.stat.
- Leave reading the CFS bandwidth counters to the BPF program. They are
  plain fields of tg->cfs_bandwidth, so they need no kernel code.
- Add bpf_css_to_task_group(), which returns a checked RCU pointer of
  the task_group*. This is usefule to compute the throttled time in bpf
  side since the bpf_per_cpu_ptr() requires a verifier-known struct
  task_group * and a pointer carrying the MEM_PERCPU property. 
  This use the convention that task_group embeds its css at offset zero,
  so no scheduler helper or scheduler source change is needed.

===
Changes since v1:
- Make the rstat flush generic, move it to rstat.c, and take a css.
- Return cgroup_base_stat directly instead of repacking its CPU times.
- Replace the throttled-time aggregation kfunc with a checked RCU cast in
  the CPU cgroup BPF code. The cast preserves the verifier type needed for
  the BPF program to perform the per-CPU sum itself.
- Remove the changes in the scheduler part.

Tested on VM with v7.2-rc5. 

Ziyang Men (2):
  cgroup: add BPF kfuncs to read a cpu cgroup's stats
  selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs

 kernel/cgroup/Makefile                        |   2 +
 kernel/cgroup/bpf_cpu.c                       |  61 +++++
 kernel/cgroup/rstat.c                         |  59 +++-
 tools/testing/selftests/bpf/cgroup_iter_cpu.h |  22 ++
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/cgroup_iter_cpu.c          | 259 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_cpu.c     | 113 ++++++++
 7 files changed, 517 insertions(+), 2 deletions(-)
 create mode 100644 kernel/cgroup/bpf_cpu.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_cpu.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c

-- 
2.53.0-Meta


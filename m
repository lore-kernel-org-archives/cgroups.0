Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFF54915BC
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788911779; cv=none; b=RombDXK5AjBG5gNMS1dOyVshj584Jq+Y0ccAV/OzvpW3FHCYu+Mx9rI1Jj4eDaP4SpoE+KIfz87HqlhRvD1DHjZmTewosbzkJfa26VcF7XrtDL9tiWbbNan+AnEpwiGOiPFdCewthAgx0sXdOs6MeNIgJ/nZ464rdqXB7+npK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788911779; c=relaxed/simple;
	bh=5MxxvCdVgC3YLTJh7XEdP1bYFUpjHnVxjCwGvCeCFF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AvP3LNXs4z5cqL45/37FcnbGHzxe+p/SqDGFuZrLFhbck8nDqxQqpTZ+7hw72WnrrYLpHDOvQ1mxMn+wZ+z8qNsNLv8rXsbsls+rVrKb8iUumBh2jt4xuD+5aBvk6QD9D/zCFrQdUEBPE+YF5k1l5zbyE7NRo0ZASZVCappv8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDd3GtzJ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDd3GtzJ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3990fe066ebso4377983a91.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 16:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911775; x=1789516575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aeaQ8qHK/MyWCciP9ARnOOzHBOTcOWNQ9SeCb5dOpCc=;
        b=JDd3GtzJo1ampPo13lGt2FWKwTeupUuyjiznSutxyH1B//grR6To87GBFZt86ZRVd8
         WEP8ghZO4b1ax/yeiPCToBWaEXWFQMRrqjn5Q7UIC+0EZzZyVY4Ta2ZlaWfGXTnVCx6K
         ghLPhkg1XMrl/HMWDzNDZKnGVgxYPQxOT5kNS+73HRlitL8TFnaHZAlQHK8pLw0fIH0j
         UMgvHwaJuzHNDSxdAQSm31oYwsjEJM17EbR+wyzEMxzWSVQn/rOKW36XxNbyR/2TMo06
         TQJ3spvzMRlYPpdmmlRisluRUz8WXENwNzJYyh84GfQZ47YiHBQZzEqY/FhZzqo3nR4b
         MpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911775; x=1789516575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aeaQ8qHK/MyWCciP9ARnOOzHBOTcOWNQ9SeCb5dOpCc=;
        b=rCoLNoChvLk+qOJXiQbNzxMWHL3KGTc+r2BvmX95jQAZnk6QIeW9WsJohWVy9AGZUI
         wL7ejZfq7FtNIKVgvbp+TPSAUWNmr2VqhfAjELwtQ+CM57eYNpIaLr8d4hss5xKFnGwd
         XIdQI2zhzwiq5/FxgM9OHzX1Bi9GOFhJfdAHjNOc2OnZNPeD0jOm/sfSHaV91H4RJ/dv
         0s53kl/z3cdTP++w/rAqpZXnPO5EE5s+hUVNq2r+eRnqPVIvVJmW0t95CRGoYi2TtsEb
         UyCVLr8teEXcM+RfmqszW5B1tBHaLeLyb3ETgFP75+k6wui9eJAmg/Hd1l67B+4i4bHc
         dLlA==
X-Forwarded-Encrypted: i=1; AKwUvBzDOz+214JJmNFiOOUWpEco0EcGvNAahuN0VGYm53+hcLMkWevgkd5/XSFbB1OiIFlytI/GlJGw@vger.kernel.org
X-Gm-Message-State: AFuF++khOnkme2BL4fj9HsOpjHiklTc6MNko1vKXxsBP/iclmDKjK8h0
	HB+w7/troqFOxCEDnh8SUGY1zaRHSyaU8F4/WTs/rMIFGydpRwtrix86
X-Gm-Gg: AYBFou0YyDu9k2o3lCz1MmhPLwfmCEzQjmy2kf/OdjYok8NPKxm2Mqsdd2Q9lTV9Osm
	03J/CUDSN7FXJIaqRNB5MhV0MUcJhgC1oybp/vPpDdIxz55SvBG9QqV3ObIR9xCfxMsbEGrv5RE
	gxbvitQe943Z69550Wee70uQIf1tQ2a33YWVuWkF/VQ/4eXNP+8Fv34vusShYtpPKc5jHIy8s75
	dugJlcS0BMxnHJ/1cubrF/7gTdXhYKhGEmoXRbFZ+IeP0VfaHFNTUDxdpfSZdl6mcsxIcgAp3z5
	ShsNHRZAuMsJ0F5fAqUGPk/mPFN95PPxGKxZ+oAHsOlu8Mbtuv/ECzLbYlaGl842VThWhzQhZ3I
	4DzoD7bytyPf4VM+a2ErDydR0rVnnF7sx8JcsMEnHSmapCiO1qNEVABEWNLc2hoZRUEorBxn5FM
	R6yAIfcjY1sqq/vSO2Atz6fRgB6ATRQTwNSos8qpSjgczmlqqB3S+EkwY=
X-Received: by 2002:a17:90b:4cce:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39b260dd4e9mr51323684a91.2.1788911775237;
        Tue, 08 Sep 2026 16:56:15 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:73::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324410092sm36459946c88.14.2026.09.08.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:14 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] selftests: add shared Makefile for BPF selftests and new memcg test
Date: Tue,  8 Sep 2026 16:55:48 -0700
Message-ID: <20260908235552.2610256-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series refactors the BPF-related build machinery that is currently
duplicated across selftests/{bpf,sched_ext,hid}/. It adds the shared
tools/testing/selftests/lib.bpf.mk fragment and wires up three consumers,
simplifying both existing BPF selftests and future additions.

The series also adds a cgroup memory-controller selftest that complements
the existing coverage.

Patch 1 adds lib.bpf.mk.

Patch 2 adds selftests/cgroup/test_memcg_stat_cross_cpu, which verifies a
cgroup flush by comparing values read through BPF memcg kfuncs with the
corresponding cgroupfs values. The existing bpf/cgroup_iter_memcg test only
checks whether selected values are non-zero.

Patches 3 and 4 replace the duplicated BPF build machinery in
selftests/{hid,sched_ext} with lib.bpf.mk.

===
Changes since v3:
For shared Makefile:
- Track in-tree libbpf headers directly so a single make invocation rebuilds
  BPF objects and skeletons after a header change.
- Restore the target definitions needed by LoongArch and MIPS cross builds.
- Validate output directories and skeleton suffixes, and reject dotted or
  hyphenated source stems before they reach build and cleanup rules.
- Add stamp tracking for vmlinux.h generation while preserving content-based
  header updates.
- Make skeletons and subskeletons explicit outputs, so a missing subskeleton is
  regenerated and both sets participate in the all target.
- Namespace private variables, expand the caller-visible contract, track a
  supplied VMLINUX_H, and remove unnecessary include search paths.

For cgroup selftest:
- Add CONFIG_BPF_EVENTS and probe every required kfunc plus the sleepable
  cgroup iterator before running.
- Bound CPU fanout, cgroup/process count, and total memory use; skip a case
  when the flush threshold would require more than 256 MiB.
- Check CPU discovery, polling, iterator creation, and BPF errors, with clearer
  diagnostics.
- Compare each BPF statistic against two following memory.stat samples, keeping
  exact equality on a quiet subtree while tolerating values that move between
  the two samples.

For hid and sched_ext:
- Remove unused HID locals instead of suppressing warnings, drop obsolete
  variables and comments, tighten cleanup, and correct the generated-output
  description.

===
Changes since v2:
For shared Makefile:
- Use USERCFLAGS and USERLDFLAGS to extend CFLAGS and LDFLAGS.
- Pass OPT_FLAGS/RELEASE and EXTRA_CFLAGS to the libbpf and bpftool sub-makes.
- Use one rule per BPF source instead of a global vpath that also affected the
  caller's normal %.c rules.
- Take HOSTCC/HOSTLD from lib.mk instead of including Makefile.include, which
  also rewrote the caller's AR, LD, and CFLAGS.
- Report a missing vmlinux from the recipe rather than at parse time, so
  "make clean" still works without BTF.

For cgroup selftest:
- Create one cgroup tree, perform one flush, then read through BPF and
  cgroupfs.
- Use common cgroup helpers such as cg_read_key_long() and values_close().
- Use cpu_set_t rather than manually allocated CPU lists.
- Move test_memcontrol.c's anonymous-memory allocator into cgroup_util.
- Address the remaining review feedback.

===
Changes since v1:
- Generalize lib.bpf.mk for source layouts and suffixes, extra headers and
  flags, skeleton suffixes, subskeletons, and configurable output directories.
- Add patch 3 (hid) and patch 4 (sched_ext), converting those directories to
  the shared fragment.

Ziyang Men (4):
  selftests: add shared lib.bpf.mk to build BPF progs and skeletons
  selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
  selftests/hid: build the BPF program via the shared lib.bpf.mk
  selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk

 tools/testing/selftests/cgroup/.gitignore     |   8 +
 tools/testing/selftests/cgroup/Makefile       |  46 ++
 tools/testing/selftests/cgroup/config         |   5 +
 .../selftests/cgroup/lib/cgroup_util.c        |  82 ++
 .../cgroup/lib/include/cgroup_util.h          |   3 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  95 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  18 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 755 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          | 179 +----
 tools/testing/selftests/hid/progs/hid.c       |   7 +-
 tools/testing/selftests/lib.bpf.mk            | 321 ++++++++
 tools/testing/selftests/sched_ext/Makefile    | 149 +---
 14 files changed, 1382 insertions(+), 316 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
 create mode 100644 tools/testing/selftests/lib.bpf.mk

-- 
2.53.0-Meta


Received: from mta1.migadu.com (out-93.mta1.migadu.com [95.215.58.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB173955F1
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 19:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018784; cv=none; b=iLmL589WDh3QgYI8osDX+yvClEElqUwql06fPcPKhGNH9djTrLhd+iL1ElmlEnhcI8b9wgzGpzjO3B8YEGFBoBr19geg8d/7kRiPzjXQuEdn7TRXmzQMH+riOv4MrAmzhinEbyGr4TKVMYgVbPATEDI8EFOtaTHQ/wKW1ncCY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018784; c=relaxed/simple;
	bh=N0QLwAgxaBt6p5mr1X5j4hSoGitsMI3jdbKpX7+fG+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWfjnLpRXUsMA3DOhLwfRm0DJQlxqA+wNKjomREcegM/r8jgSwwiS8f9q9Vf7Yk44DX2OlvE0glTB5+TudLM290U1n1s9St7vcpEMQfjgLHGR5qq3OAlONBQw8IsdKujaAf3W+cN5j+tHDcux7MOmgosWolgUPMvT3YU7/IvoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cT/jUZ47; arc=none smtp.client-ip=95.215.58.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cT/jUZ47"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=N0QLwAgxaBt6p5mr1X5j4hSoGitsMI3jdbKpX7+fG+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018780; v=1; x=1790623580;
 b=cT/jUZ47A1q794mPy6RU5ZFbHKhIG2TqdrTOhACX1fYDbznHYC1iFduJvMNgxdl/xGS9XTsu
 rT1+YVcjdAkvobwSkfbPlIiNIOb9jV5aBnUoFgaaLcMXAnRDDsBQPSRSv+z3QHthbH7W0kqju9A
 1EDhpS1si9Swb/8rrmZoMMXU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c80bc367aa6462a1;
	Mon, 21 Sep 2026 19:26:19 +0000
X-Mizu-Trace-ID: c80bc367aa6462a1
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a second attach type
Date: Mon, 21 Sep 2026 12:25:56 -0700
Message-ID: <20260921192559.2619635-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
the only one struct_ops attach type.

It calls cgroup_bpf_enabled(atype) with an atype that
find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
goto and needs a constant.  Today the compiler can see there is only one
value; add a second type and the build breaks with "impossible constraint in
'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, and
use it here.  This is a syscall path, so the cost does not matter.

And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
whose subsystem is not built keeps type_id 0, so a query for type 0 finds it
and returns success with nothing instead of -ENOENT.  Skip such slots.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/bpf-cgroup.h | 9 +++++++++
 kernel/bpf/cgroup.c        | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 8a75a6cd7309..3b2c127d401d 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -76,6 +76,14 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 
 extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATTACH_TYPE];
 #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_enabled_key[atype])
+/*
+ * Same test when @atype is not a constant.  cgroup_bpf_enabled() uses
+ * static_branch_unlikely which creates jump-label site and requires statically
+ * selected key. Since key is selected dynamically, use static_key_enabled here
+ * and keep it off fast paths.
+ */
+#define cgroup_bpf_enabled_runtime(atype) \
+	static_key_enabled(&cgroup_bpf_enabled_key[atype])
 
 struct bpf_cgroup_storage_map;
 
@@ -508,6 +516,7 @@ static inline int cgroup_bpf_struct_ops_attach(struct bpf_map *map,
 }
 
 #define cgroup_bpf_enabled(atype) (0)
+#define cgroup_bpf_enabled_runtime(atype) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) ({ 0; })
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 696b27383974..99b4e96f5db7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -45,6 +45,7 @@ static enum cgroup_bpf_attach_type find_atype_by_struct_ops_id(u32 type_id)
 
 	for (atype = 0; atype < MAX_CGROUP_BPF_ATTACH_TYPE; atype++) {
 		if (cgroup_bpf_is_struct_ops_atype(atype) &&
+		    cgroup_struct_ops[atype].type_id &&
 		    cgroup_struct_ops[atype].type_id == type_id)
 			return atype;
 	}
@@ -1448,7 +1449,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			return -ENOENT;
 		from_atype = to_atype = atype;
 		flags = 0;
-		if (!cgroup_bpf_enabled(atype))
+		if (!cgroup_bpf_enabled_runtime(atype))
 			goto skip_count;
 	} else if (type == BPF_LSM_CGROUP) {
 		if (!effective_query && attr->query.prog_cnt &&
-- 
2.53.0-Meta


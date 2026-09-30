Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B824DE700
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 13:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776343; cv=none; b=YyajIEUBp7iucdYM3/c4F6QLKdz1kDglmBRp/0H9Mwjomibd6Tq1PEOZ0tGUMmKIZAXoa4OBeY9OzDG4nNvTwnSbr3SQswSiwtjNdV3loGdsIUZF5H1iKjwR4R7BsdMyP/AN4UPj0eR8XuhTTYcI4QVhD3FbxIRgOl+2WuPyhoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776343; c=relaxed/simple;
	bh=AfeltYVpXCk9FWs65H6joY5ChH2MtXhQYovBE0rEmzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aoG239fYfBGh15d7GzSsly1UR60bpQGtMedM5tUlpCnNc8o9cXYs1D3FjaN7DW/Cb4hrjfp6arRPLYFzBE9x3/n5CRVh/3LMupGwhEoIDlDVazdprX4cMPMYJW2PwzILkrrwgHwNQaZwuIL87NguBHn31eCVqmYsJkVKmbb04tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ToJi3vCN; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ToJi3vCN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AfeltYVpXCk9FWs65H6joY5ChH2MtXhQYovBE0rEmzQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790776331; v=1; x=1791381131;
 b=ToJi3vCNuUoCqHi+rcgwOKcRA5B1vsUqA8h2STaI5e5DE6l9wLK2frO6jnS4TCGEUk7gci0K
 pbqe7OP4yoIh8801/1VLNTlvFLbjqsSanby6CiXr7FmLTnyqlyVCmoyg7lHFELrzTNr7hlzz9et
 YVZWAwql9Y/byP+4lSAdBUPw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d603edd5d970b7f4;
	Wed, 30 Sep 2026 13:52:10 +0000
X-Mizu-Trace-ID: d603edd5d970b7f4
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Amery Hung <ameryhung@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] bpf, cgroup: fix cgroup struct_ops query for a second attach type
Date: Wed, 30 Sep 2026 06:51:59 -0700
Message-ID: <20260930135159.3926039-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
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

Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct_ops to cgroups")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
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
index 2bbe77de89f0..4187f99ea025 100644
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


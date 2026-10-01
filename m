Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9251AEF3
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864349; cv=none; b=JgV0QYOyWBgUjTNe6UmVzYNY0d6d7Mv2bEMM8YHNTjNBTl1t6aovJcqeh0MHf3md68LjLb946jJCufc0uonLMBaifWf0W4GpjHFOifNYP+3Qo+zxC6+kRx7iHfj2oivr/iZnR+dcaR1VSopS0qxhp5YNp2FKZ9k/pKUDkZSnAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864349; c=relaxed/simple;
	bh=weY1YjX1ml+PqTzLzYH2YTbOr+K3mljuFSCdICr58sw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rIr2rReJPNfwljZkOgXu7ccLBdMSCNXvU6rMWn0Iz3ID07RxKbHiijNDllPTuwmD/F7jlBl/snOlzUbA0BC01L29OSXjREaDPjp9AIdTqDw9Ux6znwT6gEmu7c1fcwHqLNR+bM6KgdLwZ2xB4CRSLlN0i73Mi4mh9QeO2Y8zyEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=svUEB3Up; arc=none smtp.client-ip=95.215.58.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="svUEB3Up"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=weY1YjX1ml+PqTzLzYH2YTbOr+K3mljuFSCdICr58sw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790864345; v=1; x=1791469145;
 b=svUEB3UpUR1AmBzyPyzHyy99fmiI84MvThwHDwZnOyeYaWsmJaIER7uEmx//xCcQ3jR5u6nP
 NEUU+v6zepPSA5b9tbBvd/tO1B3jFREwmIVg/HvnaDn/GaqcdWcw4s4/X9TjeI3lhzA03aQvWHf
 fI2l5sG6ifnQP6PWIusQ0KOs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5109a60fab2357ff;
	Thu, 01 Oct 2026 14:19:04 +0000
X-Mizu-Trace-ID: 5109a60fab2357ff
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
Subject: [PATCH bpf-next v2] bpf, cgroup: fix cgroup struct_ops query for a second attach type
Date: Thu,  1 Oct 2026 07:19:01 -0700
Message-ID: <20261001141901.3225830-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
the only struct_ops attach type.

It calls cgroup_bpf_enabled(atype) with an atype that
find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
goto and needs a constant.  Today the compiler can see there is only one
value; add a second type and the build breaks with "impossible constraint
in 'asm'".  The check is not needed anyway.  When the key is off nothing is
attached, so progs[atype] and effective[atype] are empty and the count loop
leaves total_cnt at 0.  The other attach types already use that loop with
no such check.  Drop the check and the skip_count label.

And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
whose subsystem is not built keeps type_id 0, so a query for type 0 finds
it and returns success with nothing instead of -ENOENT.  Skip such slots.

Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct_ops to cgroups")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
v2:
- Drop the cgroup_bpf_enabled() check and the skip_count label instead of
  adding cgroup_bpf_enabled_runtime() (Alexei).
- Add the bpf-next subject prefix (Amery).

v1: https://lore.kernel.org/all/20260930135159.3926039-1-shakeel.butt@linux.dev/

 kernel/bpf/cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 2bbe77de89f0..ce82963bcfc7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -45,6 +45,7 @@ static enum cgroup_bpf_attach_type find_atype_by_struct_ops_id(u32 type_id)
 
 	for (atype = 0; atype < MAX_CGROUP_BPF_ATTACH_TYPE; atype++) {
 		if (cgroup_bpf_is_struct_ops_atype(atype) &&
+		    cgroup_struct_ops[atype].type_id &&
 		    cgroup_struct_ops[atype].type_id == type_id)
 			return atype;
 	}
@@ -1448,8 +1449,6 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			return -ENOENT;
 		from_atype = to_atype = atype;
 		flags = 0;
-		if (!cgroup_bpf_enabled(atype))
-			goto skip_count;
 	} else if (type == BPF_LSM_CGROUP) {
 		if (!effective_query && attr->query.prog_cnt &&
 		    prog_ids && !prog_attach_flags)
@@ -1476,7 +1475,6 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		}
 	}
 
-skip_count:
 	/* always output uattr->query.attach_flags as 0 during effective query */
 	flags = effective_query ? 0 : flags;
 	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))

base-commit: 6a75c73eebd4d497ded7d08b47894f9ddbebb5a9
-- 
2.53.0-Meta


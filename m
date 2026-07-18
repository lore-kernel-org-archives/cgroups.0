Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D728466C;
	Sat, 18 Jul 2026 08:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362660; cv=none; b=SEIp6c7C/auLISQA35+0aTcI4KjIODw1KajFcfDHhcSDYBC1eVR6kR7Rrd5dkMSeG+rqwUpkd6LkU78wEz2695r1misc3a8X43VSkhGAL8lBAtUSakseBPZukMbnFrKc1KG0yBa7NfqI4oV4GJFLj4dPsUXmELKdOex2/QiYzM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362660; c=relaxed/simple;
	bh=RNR5l4bWfiVajPPe+/eJudV2IuDEzSave0Yc3TrPcM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi/UJrzU8IcKs6X7mxPtjt2+d+lBjn6Ml5LIpf2WX7wPNFsRVIojlJOTzjIHr56IbSMpFuQYvPKPHhKerK6iNSFPFIvCNWPFjdWD2dHz6pVG3yqbzLDjttwRL6ZupCYW5hbD6p5OzBJgplM5pJH6lhnTGgQvbvOK11YERF8IvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GREOxJQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GREOxJQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964031F00A3A;
	Sat, 18 Jul 2026 08:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362656;
	bh=Gd+YEyF5kgp7SgtSQT0SBCD+6GIuf5Bhdvp27U0xJeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GREOxJQjHR5DZ234RIV2DD4ZtnKChEczFXoJTfJ9LM6yE2L2CauLsE3v2g1BuJeDR
	 XrILpxtrg0OjwgNWTLgI6JsO/Hc7wOjA6zHh3zVPp+/yWO2d6fSrmBGZMzoTjoQ2bZ
	 M9jR56x8DVoR/vWFQ91MadhaPNP00dSiVEk5avZUmo7ag/F7d1GY1vO3jezl2Q4Nzc
	 iWluy/+bBOD714hyOSCIxRto3gCpzw+XqwvtS8HAhyKaYjix6BU+EXuspvczB+zst7
	 2VjTgjTr6XrWd8Y4NRbK3PdVWLlYrcCkKCar0cJ+K6Dn3vmbWqjWwFrwjMQ00n4wBw
	 BiVecsiD7hb+A==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] tools/sched_ext: scx_qmap - Add init fault injection modes
Date: Fri, 17 Jul 2026 22:17:27 -1000
Message-ID: <20260718081727.582037-9-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add -J init-fail which makes ops.init_task() fail with -ENOMEM for tasks
whose comm starts with "qmfail", and -J cgrp-init-fail which does the same
in ops.cgroup_init() for cgroups named "qmfail*".

The former exercises the migration veto path: the cgroup.procs write must
fail with the injected errno while the destination sched stays up and the
task stays put. The latter exercises the ownership-return failure path: a
parent failing to re-init a returned cgroup leaves it unowned, and moves and
set_* ops against it must be skipped instead of dereferencing the missing
owner. Matching on "qmfail" names keeps the injecting scheduler's own enable
unaffected.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 tools/sched_ext/scx_qmap.bpf.c | 15 +++++++++++++++
 tools/sched_ext/scx_qmap.c     |  8 +++++++-
 tools/sched_ext/scx_qmap.h     |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index 8b8b14309466..925ae1a1d440 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -888,6 +888,10 @@ s32 BPF_STRUCT_OPS_SLEEPABLE(qmap_init_task, struct task_struct *p,
 	struct task_ctx_stor_val *v;
 	task_ctx_t *taskc;
 
+	if (qa.inject_mode == QMAP_INJ_INIT_FAIL &&
+	    !bpf_strncmp(p->comm, 6, "qmfail"))
+		return -ENOMEM;
+
 	if (p->tgid == disallow_tgid)
 		p->scx.disallow = true;
 
@@ -1012,10 +1016,21 @@ void BPF_STRUCT_OPS(qmap_dump_task, struct scx_dump_ctx *dctx, struct task_struc
 
 s32 BPF_STRUCT_OPS(qmap_cgroup_init, struct cgroup *cgrp, struct scx_cgroup_init_args *args)
 {
+	QMAP_TOUCH_ARENA();
+
 	if (print_msgs)
 		bpf_printk("CGRP INIT %llu weight=%u period=%lu quota=%ld burst=%lu",
 			   cgrp->kn->id, args->weight, args->bw_period_us,
 			   args->bw_quota_us, args->bw_burst_us);
+
+	if (qa.inject_mode == QMAP_INJ_CGRP_INIT_FAIL) {
+		char name[7] = {};
+
+		bpf_probe_read_kernel_str(name, sizeof(name), cgrp->kn->name);
+		if (!bpf_strncmp(name, 6, "qmfail"))
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
diff --git a/tools/sched_ext/scx_qmap.c b/tools/sched_ext/scx_qmap.c
index 105745f51b8e..46892b4bb448 100644
--- a/tools/sched_ext/scx_qmap.c
+++ b/tools/sched_ext/scx_qmap.c
@@ -69,7 +69,9 @@ const char help_fmt[] =
 "  -C MODE       cid-override test (shuffle|bad-dup|bad-range|bad-mono)\n"
 "  -i SEC        Stats interval, seconds (default 5)\n"
 "  -R MS         Round-robin period for time-shared cpus, ms (default 200)\n"
-"  -J MODE       Fault injection (wrong-cid: dispatch to a cid not held)\n"
+"  -J MODE       Fault injection (wrong-cid: dispatch to a cid not held,\n"
+"                init-fail/cgrp-init-fail: fail init_task/cgroup_init for\n"
+"                \"qmfail*\" comms/cgroups)\n"
 "  -v            Print libbpf debug messages\n"
 "  -h            Display this help and exit\n";
 
@@ -391,6 +393,10 @@ int main(int argc, char **argv)
 		case 'J':
 			if (!strcmp(optarg, "wrong-cid"))
 				inject_mode = QMAP_INJ_WRONG_CID;
+			else if (!strcmp(optarg, "init-fail"))
+				inject_mode = QMAP_INJ_INIT_FAIL;
+			else if (!strcmp(optarg, "cgrp-init-fail"))
+				inject_mode = QMAP_INJ_CGRP_INIT_FAIL;
 			else
 				inject_mode = strtoul(optarg, NULL, 0);
 			break;
diff --git a/tools/sched_ext/scx_qmap.h b/tools/sched_ext/scx_qmap.h
index 6db2ea4bdc85..cc2840e7aa3c 100644
--- a/tools/sched_ext/scx_qmap.h
+++ b/tools/sched_ext/scx_qmap.h
@@ -64,6 +64,8 @@ struct qmap_fifo {
 enum qmap_inject {
 	QMAP_INJ_OFF		= 0,
 	QMAP_INJ_WRONG_CID	= 1,	/* dispatch to a cid we don't hold */
+	QMAP_INJ_INIT_FAIL	= 2,	/* fail init_task for "qmfail*" comms */
+	QMAP_INJ_CGRP_INIT_FAIL	= 3,	/* fail cgroup_init for "qmfail*" cgroups */
 };
 
 /*
-- 
2.55.0


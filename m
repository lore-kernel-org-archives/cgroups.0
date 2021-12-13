From: Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [PATCH] cgroup: check the return value of kstrdup()
Date: Mon, 13 Dec 2021 11:30:42 +0800
Message-ID: <tencent_6410A5887F4B906866965C000E7A8AA3F007@qq.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639366299;
        bh=JRDtp9lI1b1ILfAffBPfZBg/lls6yyX8ptRRHfpz2oQ=;
        h=From:To:Cc:Subject:Date;
        b=FPifr6Ec9J+6SrXboWqby+5L0siqXqWfckxm7ccpH6wvHiCVtX23Fh2wreDvieBQp
         fh/wlRxpo5H9AjDlGw/S7qz8RJO97e8mT7pWV2e/BjQNbzgb2UmMbYJcKLGJXbY9/t
         R18rdqgoiT2nL/hsU3gSEsrhDt0N89A+F5JnbDLk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it so to catch the memory error in
time.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
 kernel/cgroup/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ea08f01..47c7d58 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2228,6 +2228,9 @@ static int cpuset_init_fs_context(struct fs_context *fc)
 	struct cgroup_fs_context *ctx;
 	int err;
 
+	if (!agent)
+		return -ENOMEM;
+
 	err = cgroup_init_fs_context(fc);
 	if (err) {
 		kfree(agent);
-- 

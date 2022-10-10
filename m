From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v1 1/3] Revert "cgroup: enable cgroup_get_from_file() on cgroup1"
Date: Mon, 10 Oct 2022 23:58:43 +0000
Message-ID: <20221010235845.3379019-2-yosryahmed@google.com>
References: <20221010235845.3379019-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/Luj9QXdroeEgRRoLBw0457X0Ivb/R1ok7ODQ4YpCY=;
        b=c55GI3V+Me3kNu6VHoni2F4jTF6mn9ch1qJ2gFWmMuGr8r+fuTjoxSEIpckivCsZcD
         +coTipWE6Gwes6jm+uAMQKrcWL1aHLm7ruVhxJqaoYl9ILn808xPkiBz57F8bKRcGGJb
         jHuTnIRkxRkh6uee/HLM3Q6Si1G5ODZR296XB8GbMMawjlhBq8K9mOK3Etl8foffXvmD
         9ZnB1uvi3Yl1cLi9IwZlHO6huADUDMXiVmmADGxl9Gn/WWSDFrHS5qjqe++6Vm7hnccy
         mPuStsnwKPLQDBAobK0TcMi3Uq7Rkk8DyKyVI8XHcUoPM4fZD9FSBqEC6Cin71kFr4Kh
         rCvQ==
In-Reply-To: <20221010235845.3379019-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>, "Christian A . Ehrhardt" <lk@c--e.de>

This reverts commit f3a2aebdd6fb90e444d595e46de64e822af419da.

Some callers of this function depended on the fact that it only supports
cgroup v2. Revert it now, and introduce a new function in a later patch
that supports both cgroup v1 and v2, for callers that need to support
both.

Reported-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 764bdd5fd8d1..72e97422e9d9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6218,6 +6218,11 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 		return ERR_CAST(css);
 
 	cgrp = css->cgroup;
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return ERR_PTR(-EBADF);
+	}
+
 	return cgrp;
 }
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog


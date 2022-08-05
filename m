From: Hao Luo <haoluo@google.com>
Subject: [PATCH bpf-next v7 2/8] cgroup: enable cgroup_get_from_file() on cgroup1
Date: Fri,  5 Aug 2022 14:48:15 -0700
Message-ID: <20220805214821.1058337-3-haoluo@google.com>
References: <20220805214821.1058337-1-haoluo@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=yX3R/1i2LvTgNgg51J0RQhSR+naxU23tOgWOVNggIfM=;
        b=a7tYZIN2B6Y2XNLphifwjcXADFx7gkBmMvn3k+uUvzZ3plqE2SbhHbFhSrzbeff3ob
         gpEkWJ+BU4BsSNfrGwlvuHWUfSz9wrzda85SNVzeODOFirlekVdIFXIDC690ySk6LjnV
         TKO7Dajm4ek5OH5PQo33IjTrMjr23rtrutvRF8uWrZBGLMdE4hI0vfFixcLZKpnrvxof
         MJhLvW7up+1p/h18noKqidVfcZrWhSkNQRSCmX2jeEpraXunH+F4G0xLO1YXelQ02PQ/
         OOykHlZU56GWzNfJT0elWItS0IcvSaxsXc+l6TRBYs7vgujcEPzpqiK68zkf+UF7XHZ5
         ONAQ==
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

From: Yosry Ahmed <yosryahmed@google.com>

cgroup_get_from_file() currently fails with -EBADF if called on cgroup
v1. However, the current implementation works on cgroup v1 as well, so
the restriction is unnecessary.

This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
the only thing stopping bpf cgroup_iter from supporting cgroup v1.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 kernel/cgroup/cgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 13c8e91d7862..49803849a289 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6099,11 +6099,6 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 		return ERR_CAST(css);
 
 	cgrp = css->cgroup;
-	if (!cgroup_on_dfl(cgrp)) {
-		cgroup_put(cgrp);
-		return ERR_PTR(-EBADF);
-	}
-
 	return cgrp;
 }
 
-- 
2.37.1.559.g78731f0fdb-goog


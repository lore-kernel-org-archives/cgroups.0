From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v2 1/8] cgroup: enable cgroup_get_from_file() on cgroup1
Date: Fri, 10 Jun 2022 19:44:28 +0000
Message-ID: <20220610194435.2268290-2-yosryahmed@google.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M8/ooGDXsUIPk2mNJ2l2OjGkicZ3p1bfFAHZWM/Ly3A=;
        b=GsYyQ0tB9bXQvXH2rfH1JcR8TEHmOvJ6SarwER+CY1co37p00ocODWPY6ALAvi7cC/
         BhRL3SNdxxNtunT13h/LwWckSxL/x3PAnQlMiII3OjHHuxFjm/UiaqGQxGXDWeFua/FG
         Y41TkbjTNQZBdWmKWYSTYgE2O7pEhXg8S5aHcheB5zWS3P42tcPr1sfBsttz0m6u2hUS
         k57s9rBU2kRz1kN/xSirNBOIuFSqSk7cJ2Iomhw1Sciw7oQjyaJUK3RsSElxoEdJENaN
         Lak88pvz9+Eaj9JoaT6P2JaZC4ShxM85fhVOaqcNPgOPT2GVKO2t8qNWcDUt1V4NiF6D
         Kovg==
In-Reply-To: <20220610194435.2268290-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

cgroup_get_from_file() currently fails with -EBADF if called on cgroup
v1. However, the current implementation works on cgroup v1 as well, so
the restriction is unnecessary.

This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
the only thing stopping bpf cgroup_iter from supporting cgroup v1.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/cgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734d..9943fcb1e574d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6090,11 +6090,6 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
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
2.36.1.476.g0c4daa206d-goog


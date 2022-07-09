From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v3 2/8] cgroup: enable cgroup_get_from_file() on cgroup1
Date: Sat,  9 Jul 2022 00:04:33 +0000
Message-ID: <20220709000439.243271-3-yosryahmed@google.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IqjL6yZGTqZ3Qe1XCgaEl6Fvh17NMPAOr7heTy9DUWI=;
        b=sgi3aVUrpzBWfebO0eixVS0qfo5Xt0wVCPW7ELzk3n4yMTtTrcclhOKlRVXJ1RmLUA
         9YQfDzxLvHW4dQVosJREPn4Niv6/YVO4lwQctTJkGW4lHPxXY4SKXvJGucNbaX6IfLUz
         t6rDR5WEeCcw/g318JGwbL+CqPH6ReaRv2xTNI0j2QM8BBWS8W5TzaKTO3uPfcFtiI6h
         /K+AEn9xXXbg6EmwFKHBaSMOy8kDnkOIICWxXn0oTE0kCLUHjB20+RRazYIHIGQukycM
         xeHWcswZban+jsAKB71K7reqzFvxxfU55QTsB6Mjr/uVx78vP6CIOkmnjlDiACm4XIvU
         slnA==
In-Reply-To: <20220709000439.243271-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

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
2.37.0.rc0.161.g10f37bed90-goog


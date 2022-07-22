From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v4 2/8] cgroup: enable cgroup_get_from_file() on cgroup1
Date: Fri, 22 Jul 2022 02:13:07 +0000
Message-ID: <20220722021313.3150035-3-yosryahmed@google.com>
References: <20220722021313.3150035-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DhjjSNuficgbRYAqqQ0W8XZGDABdrTHUp2H4nxtLaug=;
        b=PI4AMB4vSbp0OIWCtIi99l5y4UFdCqR/ok0FBs166w/hgCwQvkncSijD7lGvRoGySS
         Ua+FnMCqGvIRXN2qe0qH77bKrmYhFAwB5e6L+hNKsACMXnx+MLuG6goCLrTFH/hCi3Pl
         QHMcf1tqWKZKns+LlKiQ9RodcMfMMI5jeZmU4Sv4uRY3wo8nJnqQubNwUPaJLeqve4w0
         18WyJP6Wa1gNf02gbU0YwudKDR8P47mc6mIu2MjlZoyN6nr/mHEZFIYgVUiXCTFQY+5Q
         PSF8Ximzmamk1QeoF2Wacsv93SLBXFR/+gXPNly8OgWAOCz3BLuAMNV6K0Rvv1ycTXz8
         fIkw==
In-Reply-To: <20220722021313.3150035-1-yosryahmed@google.com>
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
index 1779ccddb734..9943fcb1e574 100644
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
2.37.1.359.gd136c6c3e2-goog


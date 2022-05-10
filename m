From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH bpf-next 6/9] cgroup: add v1 support to cgroup_get_from_id()
Date: Tue, 10 May 2022 00:18:04 +0000
Message-ID: <20220510001807.4132027-7-yosryahmed@google.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Dj8G52Ku/C8Y7g0RB9bNxhRV9jY61G7LwBKsHFtUSBY=;
        b=T2/IAHh55Gjn5HeBRFdMbJMuKc4A52+bUpWlUzeffogFLw8TTHeFLtYgq22aCDSH0T
         9m4JTdgAoZuuUHr5I3kddwnsxcs8TQAQHDjK0UzNNzDxg/le5nOw/ffd5aukwJ4o5odv
         hqrUXfaotL2uO9PHctmV7H/6ClL+ttTG+dlAwNNowSl/QZnHkF0tmiub103C3Lc+H366
         YaCrxgdzJ1UEE5C+opIeGU7M6jGjOoESS0Kq0WQGfx5CJSHP7FogfGa56LdFw0/8ZBX/
         QYaa6FmxrCLIdWPx0PReW/umNNuLKbGeFGSlAXTWp7OOLAXyLtxRE/8udLP34ZfvVWyw
         p5Rw==
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

The current implementation of cgroup_get_from_id() only searches the
default hierarchy for the given id. Make it compatible with cgroup v1 by
looking through all the roots instead.

cgrp_dfl_root should be the first element in the list so there shouldn't
be a performance impact for cgroup v2 users (in the case of a valid id).

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/cgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index af703cfcb9d2..12700cd21973 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5970,10 +5970,16 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
  */
 struct cgroup *cgroup_get_from_id(u64 id)
 {
-	struct kernfs_node *kn;
+	struct kernfs_node *kn = NULL;
 	struct cgroup *cgrp = NULL;
+	struct cgroup_root *root;
+
+	for_each_root(root) {
+		kn = kernfs_find_and_get_node_by_id(root->kf_root, id);
+		if (kn)
+			break;
+	}
 
-	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
 		goto out;
 
-- 
2.36.0.512.ge40c2bad7a-goog


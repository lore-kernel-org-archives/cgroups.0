From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 2/2] bpf: cgroup_iter: support cgroup1 using cgroup fd
Date: Tue, 11 Oct 2022 00:33:59 +0000
Message-ID: <20221011003359.3475263-3-yosryahmed@google.com>
References: <20221011003359.3475263-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kbGsK3zRIBgwO+yeL9iNdWAuCYqQNstAHk5QocJBrw0=;
        b=HlswPq1vxu4CahK3K4qytrglcfUaCIEln3TR+ZaOeKULDkAK1aqKQSdLX6eVGYAWQV
         1YXwY5Yypslv441L2zV7UTIw3m7naY0rZWu+z+IxjaLZCz09HM29UwTgE7uFvLdoIy6H
         SYG7rPGunn+5Y4b8pIi5ZvGNguDNlWO9iqX+60jtpWrAEMWcFdWzG7iZrYGZy0/pI57t
         aboRfOJjSmvh1loG6tkJG8t7kek1kBVlhY1i/m3YSnZkRST1i25gfU8Iu1OMg9ak/9yu
         cpnrqG2zBTIbNcsCF7b0l0HnYDAucO2pgNJ88wz9TssQO/7wDN6vGFPyzXUU81+lAaP0
         /hew==
In-Reply-To: <20221011003359.3475263-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Use cgroup_v1v2_get_from_fd() in cgroup_iter to support attaching to
both cgroup v1 and v2 using fds.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/bpf/cgroup_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
index 0d200a993489..9fcf09f2ef00 100644
--- a/kernel/bpf/cgroup_iter.c
+++ b/kernel/bpf/cgroup_iter.c
@@ -196,7 +196,7 @@ static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
 		return -EINVAL;
 
 	if (fd)
-		cgrp = cgroup_get_from_fd(fd);
+		cgrp = cgroup_v1v2_get_from_fd(fd);
 	else if (id)
 		cgrp = cgroup_get_from_id(id);
 	else /* walk the entire hierarchy by default. */
-- 
2.38.0.rc1.362.ged0d419d3c-goog


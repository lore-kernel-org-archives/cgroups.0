From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Fri, 10 Jun 2022 19:44:30 +0000
Message-ID: <20220610194435.2268290-4-yosryahmed@google.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oRH9s66i/tSGRatQjV8lrlYVzRqMhVkli+0iViEEm3E=;
        b=EWvIhNpLP4xn7/AaqRD2ry5tJ0od8mdvtIo1l8Mu+AVSg+pAqesAczV/0Lr9wi2kiz
         Fy1MQLHaGvnHVaKfEvTTAGxuQ35arwQTMzrK2HRvce7BKsnt7sTyah4aPc8tPwHAGwCP
         alnn29BH+uZT8ISPg2q0Aplzk57S3UfzlWezvPJ4bm6+UjnhYvJElPhjilELUc3eMS3i
         biAZPX2dSat+7EcVOoZvb8GhkN6J+dYfXoCwKW+EU9nHCjcLl83cMunu9bKv9Kdj8e3T
         TmfhQM5pKilrhRQQjzkRZ7h9oFsr0mAh0K0WVdTgcxvqo9ykb8W3YB6HehNxkS1wukLn
         Pf+g==
In-Reply-To: <20220610194435.2268290-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

From: Hao Luo <haoluo@google.com>

In bpf_seq_read, seq->op->next() could return an ERR and jump to
the label stop. However, the existing code in stop does not handle
the case when p (returned from next()) is an ERR. Adds the handling
of ERR of p by converting p into an error and jumping to done.

Because all the current implementations do not have a case that
returns ERR from next(), so this patch doesn't have behavior changes
right now.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/bpf/bpf_iter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index d5d96ceca1058..1585caf7c7200 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -198,6 +198,11 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
 	}
 stop:
 	offs = seq->count;
+	if (IS_ERR(p)) {
+		seq->op->stop(seq, NULL);
+		err = PTR_ERR(p);
+		goto done;
+	}
 	/* bpf program called if !p */
 	seq->op->stop(seq, p);
 	if (!p) {
-- 
2.36.1.476.g0c4daa206d-goog


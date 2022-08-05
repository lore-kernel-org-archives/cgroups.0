From: Hao Luo <haoluo@google.com>
Subject: [PATCH bpf-next v7 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Fri,  5 Aug 2022 14:48:16 -0700
Message-ID: <20220805214821.1058337-4-haoluo@google.com>
References: <20220805214821.1058337-1-haoluo@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=7MaHmbvjhjrXHhN5Hd2JmNuqCLNElFu+/Qz1TUQGsGM=;
        b=XE0i/VM2AKUVwDXrI7BSBUWMw8xZL12GqzlEqpo9DCJuNkA2rk48R5GIWi3DkPnewZ
         Wqvf9KpzxAPPV+FGmjzKY47JWe+wrpsfYtvFSHb7DSImp86aYtmySfXl+MACOjjbsl7E
         YSsiFaaLXKUzdkjkTNUYxnprMH6PDTmVSVPM9FeftJ8EKEjX+4ITxuColVd/djrYLv5Q
         TqcPRDDcgfhjG/51ZgCmmTqr/S+HVPaNytx65orUi0h5nGR0lofrgsGKAn5TAUFqiufk
         Gm2cDgi9HxIrq9dUhtauCQN4hSLAgikGj+kw+GAt1YS8s9rH/fyWctEx5ntVb17vS7e0
         OAQg==
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

In bpf_seq_read, seq->op->next() could return an ERR and jump to
the label stop. However, the existing code in stop does not handle
the case when p (returned from next()) is an ERR. Adds the handling
of ERR of p by converting p into an error and jumping to done.

Because all the current implementations do not have a case that
returns ERR from next(), so this patch doesn't have behavior changes
right now.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 kernel/bpf/bpf_iter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 7e8fd49406f6..4688ba39ef25 100644
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
2.37.1.559.g78731f0fdb-goog


From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v3 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Sat,  9 Jul 2022 00:04:34 +0000
Message-ID: <20220709000439.243271-4-yosryahmed@google.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z+JHBwxAxDgScZtO1p/+es4hJDW+SiPZzqWzOE/0rOo=;
        b=FM9Dmst+4r/eCIlrO0NIewdKZfGIpGWmXrkjfyiCnHGlO+FW3rZHJdcwkrNHgDaTY+
         cvSYpDa2VVz8F5b/HJk2BsfHzDEHYzxa91MpEdZrSY4qCNp+aQGUemw3B+BBN2wVTepD
         IMDuPcDtlPxcTr/9vxUCX+eFJDXNBb+wibjvwy3nMSfNb27E8YxtzMH96QbzdtOJNFWi
         GDPEPDNWf0f1RW1m8z9GtmDs2h6Q2PqyNj6+5ie+TBMvfXKwUN8BGxbqZXCks4Nl8kEE
         u5szkY6eBbLmh9vcfQeF7tEyiY5MgEIXNcmRC9xkHn1LF9PtT+MBlXQoXha+si78OTkH
         13MQ==
In-Reply-To: <20220709000439.243271-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

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
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 7e8fd49406f64..4688ba39ef25c 100644
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
2.37.0.rc0.161.g10f37bed90-goog


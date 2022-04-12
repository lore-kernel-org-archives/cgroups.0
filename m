From: Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH] cgroup: don't queue css_release_work if one already pending
Date: Tue, 12 Apr 2022 12:24:59 -0700
Message-ID: <20220412192459.227740-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYhX4cxvNPixKiX8/O3wLDCe+0alwiuzYnrIU9ZEA4g=;
        b=WcXC5z9iBD0s8lqEIkWuMQZUWfBIEmGdOcTDJqsddJGTc3xoDzEDte6mLkWCIDPq6H
         YHQuTi2jz+pLaZ8K0n3h+80UsslQCJcbZCL49vv/iIQRc4MzeoUTN57u4Pk6Dtk8H9Wc
         KDCu2a04jyUl6dKyGyJfhQgPSJPUaOxmhiyGeDPKKJPcJHNUlNymuti54JQo6/NDczvO
         vbVuQ9W77Cy/v2QPjgtsQEF4MpP2tX3f+bHSl/ir7fHiWkRxbpG2V2V744Rx+xNFpwjR
         XZUkPMYcqusEKPz9Uy9mX9juzRrR5tQ+Q4qiBB8T1Gj6Sx2YQ1W9au99vcD3HFtSTAwh
         8rqw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

Syzbot found a corrupted list bug scenario that can be triggered from
cgroup css_create(). The reproduces writes to cgroup.subtree_control
file, which invokes cgroup_apply_control_enable(), css_create(), and
css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.
In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
work for an css->refcnt initialized with css_release() destructor,
and there is a chance that the css_release() function will be invoked
for a cgroup_subsys_state, for which a destroy_work has already been
queued via css_create() error path. This causes a list_add corruption
as can be seen in the syzkaller report [1].
This can be avoided by adding a check to css_release() that checks
if it has already been enqueued.

[1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <cgroups@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Reported-by: syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Fixes: 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu and work item")
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 kernel/cgroup/cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..9ae2de29f8c9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5210,8 +5210,11 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	INIT_WORK(&css->destroy_work, css_release_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+			      work_data_bits(&css->destroy_work))) {
+		INIT_WORK(&css->destroy_work, css_release_work_fn);
+		queue_work(cgroup_destroy_wq, &css->destroy_work);
+	}
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
-- 
2.35.1

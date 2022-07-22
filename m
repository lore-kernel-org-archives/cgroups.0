From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH bpf-next v5 1/8] btf: Add a new kfunc flag which allows to
 mark a function to be sleepable
Date: Fri, 22 Jul 2022 17:48:22 +0000
Message-ID: <20220722174829.3422466-2-yosryahmed@google.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tP9zyImv+ry8FNBxQIa8g2nDvi+pmzcTYg12pdkvHPI=;
        b=YK3c3yeup+bH6kPfzgxKhijxptXaWxV4qnHhmTbBev1QmNGCXbtmVnFrlr4Z2CCjh3
         HvBBuufaM4IFIrJryHJI9BgoamRPqPvn2+5X1sWfuYaWVAysrHkSIUz5N8sGq7tsbkoW
         YDBxVrPPJkP9jHs79x06TQDGnbFlXoP4PUIaxqAAQVyV8PfDqY1nQdMd9Bo9MBR+UJFp
         xi7nhqpVnWAkUWpxeTExeGAMnuc6+5Hrqfc9Btb7pxCTbWntL4JVKp6ddWTnh51udH4p
         USSZCRwdYJFGCvi5d7pIxm7oQ3VePLxozAKnOcgqPZd49THtGn8wbKoKbycbDPZekUKV
         akCg==
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

This allows to declare a kfunc as sleepable and prevents its use in
a non sleepable program.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 Documentation/bpf/kfuncs.rst | 6 ++++++
 include/linux/btf.h          | 1 +
 kernel/bpf/btf.c             | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index c0b7dae6dbf5..c8b21de1c772 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -146,6 +146,12 @@ that operate (change some property, perform some operation) on an object that
 was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
 ensure the integrity of the operation being performed on the expected object.
 
+2.4.6 KF_SLEEPABLE flag
+-----------------------
+
+The KF_SLEEPABLE flag is used for kfuncs that may sleep. Such kfuncs can only
+be called by sleepable BPF programs (BPF_F_SLEEPABLE).
+
 2.5 Registering the kfuncs
 --------------------------
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index cdb376d53238..761bfd8c31b6 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -49,6 +49,7 @@
  * for this case.
  */
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
+#define KF_SLEEPABLE	(1 << 5) /* kfunc may sleep */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7ac971ea98d1..be5788797789 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6175,6 +6175,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	bool rel = false, kptr_get = false, trusted_arg = false;
+	bool sleepable = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
@@ -6212,6 +6213,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		rel = kfunc_flags & KF_RELEASE;
 		kptr_get = kfunc_flags & KF_KPTR_GET;
 		trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
+		sleepable = kfunc_flags & KF_SLEEPABLE;
 	}
 
 	/* check that BTF function arguments match actual types that the
@@ -6419,6 +6421,13 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			func_name);
 		return -EINVAL;
 	}
+
+	if (sleepable && !env->prog->aux->sleepable) {
+		bpf_log(log, "kernel function %s is sleepable but the program is not\n",
+			func_name);
+		return -EINVAL;
+	}
+
 	/* returns argument register number > 0 in case of reference release kfunc */
 	return rel ? ref_regno : 0;
 }
-- 
2.37.1.359.gd136c6c3e2-goog


From: Hao Luo <haoluo@google.com>
Subject: [PATCH bpf-next v6 1/8] btf: Add a new kfunc flag which allows to
 mark a function to be sleepable
Date: Mon,  1 Aug 2022 10:54:00 -0700
Message-ID: <20220801175407.2647869-2-haoluo@google.com>
References: <20220801175407.2647869-1-haoluo@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=94uBmcLYR44gO9IwX8w38Cl0b3ucjrw05lLRZoANBEo=;
        b=rsW6JPNEjOByHKoZqtGJI0llTPq60KTitf7bJXV8OIcA7HWQ2jwDpIlYh4NiTbi44U
         /7SW+a184h2h92ey8CKe9MxNIJ5Ng8ysWl3CfH1bLJrDxBMVr9MFcETQxxfOBYswE6zA
         pNYteBbHgrN0aaOFqkSLuGdW2mApz5mLUYEEhkWEvi6K5ZHULL3x9tJvZ/1cYdhf7ncy
         5vWXyHUIpdbK26RpZDPmzHXVDoq7xbNfAa/vJFw0n8Z0b+Tnwne4PxoLWi2BcO2bNH4A
         BNxxuzwmXaJjbELOSQTSuxSkFeCfifQL026l2dMv4rwxiS88sswqMQEU6E7IeermXS5K
         bQzw==
In-Reply-To: <20220801175407.2647869-1-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

This allows to declare a kfunc as sleepable and prevents its use in
a non sleepable program.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Hao Luo <haoluo@google.com>
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
index cdb376d53238..976cbdd2981f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -49,6 +49,7 @@
  * for this case.
  */
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
+#define KF_SLEEPABLE   (1 << 5) /* kfunc may sleep */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7e64447659f3..d3e4c86b8fcd 100644
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
2.37.1.455.g008518b4e5-goog


From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 3/5] bpf: introduce bpf_memcg_flags()
Date: Sun,  5 Feb 2023 06:58:03 +0000
Message-ID: <20230205065805.19598-4-laoar.shao@gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvT0LPmkis2rub1BPyeQPcuStniilZcgbmYKVTz7Hvo=;
        b=Oy5xAL4aXjTTwo6yYaI1NHOu5VWyI2xXvQE6gfQ6deE11ldVIy3ideM0a5D+DQHey0
         1Ch7zNbFrAM2Mxq+adjEPGfyeb6rkTy+HItd92lPh8wBG4qwkyfkKPPwsViylhGza+2R
         3m4jVEHwA/hpX7IsxmkeHZ7RjPVTU9InZBjXFDXeOK3Lrfwqm8SvHreAqgU64/YUAy6w
         Kv6b5gjZC6d3vw/2ds1OCOlSAyY5ByndnEwkG1T3n0AZC8BIy9hjKO7Ro6JNzD7+GWxY
         zNIqq6ubKqbPiTxzqG4R42z68sNVUDjUNaL3mxLmQ1F+t+JTCAnjxOizNdm3nk8hlzL6
         0q2A==
In-Reply-To: <20230205065805.19598-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org
Cc: bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

This new helper will be used in both bpf prog and bpf map.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fe0bf48..4385418 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -28,6 +28,7 @@
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/static_call.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2933,4 +2934,11 @@ static inline bool type_is_alloc(u32 type)
 	return type & MEM_ALLOC;
 }
 
+static inline gfp_t bpf_memcg_flags(gfp_t flags)
+{
+	if (memcg_bpf_enabled())
+		return flags | __GFP_ACCOUNT;
+	return flags;
+}
+
 #endif /* _LINUX_BPF_H */
-- 
1.8.3.1


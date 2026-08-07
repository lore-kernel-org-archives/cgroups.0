Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A312F12CE
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086181; cv=none; b=P4Uepi3LsjhBDDZNyLhHG1mva8lnfGOiwFuh+ijHlPtFqntNKdhct1vn/Y35BPeSs2DLo3BN0oMaPlao1L+uZgaMrETGwkGQNSMwC+78RlsdZhklrkXjWUGdc1faQQXgX4RfT4F8947J4dnKn4KRYtpMyVX0hJ+d5ysWgvdkc/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086181; c=relaxed/simple;
	bh=6HduimIZ7ib5YtvSjnxyAzJJAPkkLNqQAwlWa7TzeQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbkDL9w/eeWj8jVWE0HLGUNEd/tBXBX5lfZaUoQEEqBdQaEPawt7NgyCFqmWy76roS3pvbDXVpbmcSaFqwRuN5at7kXswss83lXl84uLLdlcJfnO8us8Fqh4W4n9ZEevdsND0vE7tHg2mRnVwlUZZm1KxCcyRD2IeR1pa30PW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=prda60MS; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="prda60MS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmnNnkKZaC6z/s8sNb+drFXBEauMY/l5sTUHuEf6x40=;
	b=prda60MSdMi03FYQX8L+/loT6b5foyZ0pO1qiijpR9hAHQH6/pPFJMqcWbh5ya7u6Y045A
	H7jbnme9dtuLXAx9uGrtRM5C4ARU8ASnohlen1hhYCajk0I7wbX+74sr3PUVS/USXxyuz8
	6kl667qHNptBEFa/dZ7GJcAn8DOCR7g=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 1/4] mm/bpf: Add bpf_try_to_free_mem_cgroup_pages kfunc
Date: Fri,  7 Aug 2026 15:01:49 +0800
Message-ID: <5cd3efa9a4c614ba0b03cf4a3bd459dea67a9f61.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

Expose the memory cgroup reclaim interface to BPF programs by adding
the bpf_try_to_free_mem_cgroup_pages kfunc. This allows BPF to
trigger memory reclamation for a specific cgroup.

The kfunc wraps try_to_free_mem_cgroup_pages and introduces a
swappiness parameter with the following semantics:
Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed through
as an explicit swappiness override.
Values below MIN_SWAPPINESS indicate the use of the system default
(passed as NULL to the core reclaim path).
Values above SWAPPINESS_ANON_ONLY result in 0.

Note that the swappiness override is only respected by the core
reclaim path if the MEMCG_RECLAIM_PROACTIVE flag is set in
reclaim_options.

Swap usage during reclaim is gated on reclaim_options: swap is
considered only when MEMCG_RECLAIM_MAY_SWAP is set. Without this
flag, reclaim is restricted to file-backed pages regardless of the
swappiness value or the cgroup's swappiness setting.

Also include <linux/swap.h> for the swappiness macro definitions and
register the function with the KF_SLEEPABLE flag.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..3f7a5c97e135 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,61 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_try_to_free_mem_cgroup_pages - attempt to reclaim pages from
+ *                                    a memory cgroup
+ * @memcg:           the target memory cgroup to reclaim from
+ * @nr_pages:        the number of pages to reclaim
+ * @gfp_mask:        GFP flags controlling the reclaim behavior
+ * @reclaim_options: bitmask of MEMCG_RECLAIM_* flags to tune
+ *                   reclaim strategy
+ * @swappiness:      swappiness override value, or a sentinel to use
+ *                   the default
+ *
+ * BPF-facing wrapper around try_to_free_mem_cgroup_pages() that
+ * validates and translates the @swappiness argument before
+ * delegating to the core reclaim path.
+ *
+ * The @swappiness parameter follows these semantics:
+ *   - Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed
+ *     through as an explicit swappiness override.
+ *   - Values below MIN_SWAPPINESS are treated as "use the system
+ *     default"; the override pointer is set to NULL and the cgroup's
+ *     own swappiness setting takes effect.
+ *   - Values above SWAPPINESS_ANON_ONLY are rejected as invalid.
+ *   - If @reclaim_options does not include MEMCG_RECLAIM_PROACTIVE,
+ *     the @swappiness override is ignored entirely by the core
+ *     reclaim path and the system default is used regardless.
+ *
+ * Swap usage during reclaim is gated on @reclaim_options: swap is
+ * considered only when MEMCG_RECLAIM_MAY_SWAP is set.  Without this
+ * flag, reclaim is restricted to file-backed pages regardless of the
+ * @swappiness value or the cgroup's swappiness setting.
+ *
+ * Return:
+ *   The number of pages actually reclaimed on success, or 0
+ *   if @swappiness exceeds SWAPPINESS_ANON_ONLY.
+ */
+__bpf_kfunc unsigned long
+bpf_try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+				 unsigned long nr_pages,
+				 gfp_t gfp_mask,
+				 unsigned int reclaim_options,
+				 int swappiness)
+{
+	int *swapiness_ptr;
+
+	if (swappiness > SWAPPINESS_ANON_ONLY)
+		return 0;
+	else if (swappiness < MIN_SWAPPINESS)
+		swapiness_ptr = NULL;
+	else
+		swapiness_ptr = &swappiness;
+
+	return try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask,
+					    reclaim_options, swapiness_ptr);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -172,6 +228,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_try_to_free_mem_cgroup_pages, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


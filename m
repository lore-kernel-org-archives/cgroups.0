From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 02/13] bpf: Introduce new helper bpf_map_put_memcg()
Date: Fri,  2 Sep 2022 02:29:52 +0000
Message-ID: <20220902023003.47124-3-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ia4obLCjxStcu+ICWYF8jUpLC+DBctMa/v2GHxl/gGU=;
        b=mGoieldFRW2ZsDHdEN4SGCykyr50uN6imE/RwcMpTgP+UImu3qxKPcjshQFMbcPCH0
         uYa4R3RNELwqch3SIr0C74TTS/jL857Xy8RcS9/k21JMyxJJUf2YNaFFVlcjqcqfB+yw
         /Oe8BEVARTMeYoQ3hPeJvdKL3YSyxw/d0xpdKh1Zngx9QJIJ82ylFj4vVhnLCIQzPjcC
         DlDpvggQJ9jWbT5zHIXw4sJqpNqrnagdYX8K6LbXA8oO+uLEspmkDZS/yf3+UxDeUQi3
         YNWr/PkVUiPiWmBkX+/KeXFXBAEVgHn2Ex8HMJ5uO9B1PmrOuU68MCDIg8ElFlywwvOx
         Ovkg==
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

Replace the open-coded mem_cgroup_put() with a new helper
bpf_map_put_memcg(). That could make it more clear.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e9d462..7ce024c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -441,6 +441,11 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
 	return root_mem_cgroup;
 }
 
+static void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	mem_cgroup_put(memcg);
+}
+
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
@@ -451,7 +456,7 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	old_memcg = set_active_memcg(memcg);
 	ptr = kmalloc_node(size, flags | __GFP_ACCOUNT, node);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -465,7 +470,7 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	old_memcg = set_active_memcg(memcg);
 	ptr = kzalloc(size, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -480,7 +485,7 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	old_memcg = set_active_memcg(memcg);
 	ptr = __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
-- 
1.8.3.1


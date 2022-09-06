From: Roberto Sassu <roberto.sassu@huaweicloud.com>
Subject: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
Date: Tue,  6 Sep 2022 19:02:55 +0200
Message-ID: <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, houtao1@huawei.com, Roberto Sassu <roberto.sassu@huawei.com>, stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf maps")
added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space specify
whether it will just read or modify a map.

Map access control is done in two steps. First, when user space wants to
obtain a map fd, it provides to the kernel the eBPF-defined flags, which
are converted into open flags and passed to the security_bpf_map() security
hook for evaluation by LSMs.

Second, if user space successfully obtained an fd, it passes that fd to the
kernel when it requests a map operation (e.g. lookup or update). The kernel
first checks if the fd has the modes required to perform the requested
operation and, if yes, continues the execution and returns the result to
user space.

While the fd modes check was added for map_*_elem() functions, it is
currently missing for map iterators, added more recently with commit
a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A map
iterator executes a chosen eBPF program for each key/value pair of a map
and allows that program to read and/or modify them.

Whether a map iterator allows only read or also write depends on whether
the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
structure is set. Also, write needs to be supported at verifier level (for
example, it is currently not supported for sock maps).

Since map iterators obtain a map from a user space fd with
bpf_map_get_with_uref(), add the new req_modes parameter to that function,
so that map iterators can provide the required fd modes to access a map. If
the user space fd doesn't include the required modes,
bpf_map_get_with_uref() returns with an error, and the map iterator will
not be created.

If a map iterator marks both the key and value as read-only, it calls
bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes. If it
also allows write access to either the key or the value, it calls that
function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for req_modes,
regardless of whether or not the write is supported by the verifier (the
write is intentionally allowed).

bpf_fd_probe_obj() does not require any fd mode, as the fd is only used for
the purpose of finding the eBPF object type, for pinning the object to the
bpffs filesystem.

Finally, it is worth to mention that the fd modes check was not added for
the cgroup iterator, although it registers an attach_target method like the
other iterators. The reason is that the fd is not the only way for user
space to reference a cgroup object (also by ID and by path). For the
protection to be effective, all reference methods need to be evaluated
consistently. This work is deferred to a separate patch.

Cc: stable@vger.kernel.org # 5.10.x
Fixes: a5cbe05a6673 ("bpf: Implement bpf iterator for map elements")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpf.h       | 2 +-
 kernel/bpf/inode.c        | 2 +-
 kernel/bpf/map_iter.c     | 3 ++-
 kernel/bpf/syscall.c      | 8 +++++++-
 net/core/bpf_sk_storage.c | 3 ++-
 net/core/sock_map.c       | 3 ++-
 6 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9c1674973e03..6cd2ca910553 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1628,7 +1628,7 @@ bool bpf_map_equal_kptr_off_tab(const struct bpf_map *map_a, const struct bpf_ma
 void bpf_map_free_kptrs(struct bpf_map *map, void *map_value);
 
 struct bpf_map *bpf_map_get(u32 ufd);
-struct bpf_map *bpf_map_get_with_uref(u32 ufd);
+struct bpf_map *bpf_map_get_with_uref(u32 ufd, fmode_t req_modes);
 struct bpf_map *__bpf_map_get(struct fd f);
 void bpf_map_inc(struct bpf_map *map);
 void bpf_map_inc_with_uref(struct bpf_map *map);
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..862e1caa8b0f 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -71,7 +71,7 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
 {
 	void *raw;
 
-	raw = bpf_map_get_with_uref(ufd);
+	raw = bpf_map_get_with_uref(ufd, 0);
 	if (!IS_ERR(raw)) {
 		*type = BPF_TYPE_MAP;
 		return raw;
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index b0fa190b0979..1143f8960135 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -110,7 +110,8 @@ static int bpf_iter_attach_map(struct bpf_prog *prog,
 	if (!linfo->map.map_fd)
 		return -EBADF;
 
-	map = bpf_map_get_with_uref(linfo->map.map_fd);
+	map = bpf_map_get_with_uref(linfo->map.map_fd,
+				    FMODE_CAN_READ | FMODE_CAN_WRITE);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e9d4622aef7..4a2063d8e99c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1232,7 +1232,7 @@ struct bpf_map *bpf_map_get(u32 ufd)
 }
 EXPORT_SYMBOL(bpf_map_get);
 
-struct bpf_map *bpf_map_get_with_uref(u32 ufd)
+struct bpf_map *bpf_map_get_with_uref(u32 ufd, fmode_t req_modes)
 {
 	struct fd f = fdget(ufd);
 	struct bpf_map *map;
@@ -1241,7 +1241,13 @@ struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 	if (IS_ERR(map))
 		return map;
 
+	if ((map_get_sys_perms(map, f) & req_modes) != req_modes) {
+		map = ERR_PTR(-EPERM);
+		goto out;
+	}
+
 	bpf_map_inc_with_uref(map);
+out:
 	fdput(f);
 
 	return map;
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 1b7f385643b4..bf9c6afed8ac 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -897,7 +897,8 @@ static int bpf_iter_attach_map(struct bpf_prog *prog,
 	if (!linfo->map.map_fd)
 		return -EBADF;
 
-	map = bpf_map_get_with_uref(linfo->map.map_fd);
+	map = bpf_map_get_with_uref(linfo->map.map_fd,
+				    FMODE_CAN_READ | FMODE_CAN_WRITE);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a660baedd9e7..7f7375dc39b2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1636,7 +1636,8 @@ static int sock_map_iter_attach_target(struct bpf_prog *prog,
 	if (!linfo->map.map_fd)
 		return -EBADF;
 
-	map = bpf_map_get_with_uref(linfo->map.map_fd);
+	map = bpf_map_get_with_uref(linfo->map.map_fd,
+				    FMODE_CAN_READ | FMODE_CAN_WRITE);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-- 
2.25.1


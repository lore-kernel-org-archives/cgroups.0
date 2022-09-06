From: Roberto Sassu <roberto.sassu@huaweicloud.com>
Subject: [PATCH 4/7] libbpf: Introduce bpf_btf_get_fd_by_id_opts()
Date: Tue,  6 Sep 2022 19:02:58 +0200
Message-ID: <20220906170301.256206-5-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
In-Reply-To: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, houtao1@huawei.com, Roberto Sassu <roberto.sassu@huawei.com>

From: Roberto Sassu <roberto.sassu@huawei.com>

Introduce bpf_btf_get_fd_by_id_opts(), for symmetry with
bpf_map_get_fd_by_id_opts(), to let the caller pass the newly introduced
data structure bpf_get_fd_opts. Keep the existing bpf_btf_get_fd_by_id(),
and call bpf_btf_get_fd_by_id_opts() with NULL as opts argument, to prevent
setting open_flags.

Currently, the kernel does not support non-zero open_flags for
bpf_btf_get_fd_by_id_opts(), and a call with them will result in an error
returned by the bpf() system call. The caller should always pass zero
open_flags.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/lib/bpf/bpf.c      | 12 +++++++++++-
 tools/lib/bpf/bpf.h      |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 92464c2d1da7..f43e8c8afbd3 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -980,19 +980,29 @@ int bpf_map_get_fd_by_id(__u32 id)
 	return bpf_map_get_fd_by_id_opts(id, NULL);
 }
 
-int bpf_btf_get_fd_by_id(__u32 id)
+int bpf_btf_get_fd_by_id_opts(__u32 id,
+			      const struct bpf_get_fd_opts *opts)
 {
 	const size_t attr_sz = offsetofend(union bpf_attr, open_flags);
 	union bpf_attr attr;
 	int fd;
 
+	if (!OPTS_VALID(opts, bpf_get_fd_opts))
+		return libbpf_err(-EINVAL);
+
 	memset(&attr, 0, attr_sz);
 	attr.btf_id = id;
+	attr.open_flags = OPTS_GET(opts, open_flags, 0);
 
 	fd = sys_bpf_fd(BPF_BTF_GET_FD_BY_ID, &attr, attr_sz);
 	return libbpf_err_errno(fd);
 }
 
+int bpf_btf_get_fd_by_id(__u32 id)
+{
+	return bpf_btf_get_fd_by_id_opts(id, NULL);
+}
+
 int bpf_link_get_fd_by_id(__u32 id)
 {
 	const size_t attr_sz = offsetofend(union bpf_attr, open_flags);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9471c6e05b83..35c0cc6ed71b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -379,6 +379,8 @@ LIBBPF_API int bpf_prog_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_map_get_fd_by_id_opts(__u32 id,
 					 const struct bpf_get_fd_opts *opts);
 LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
+LIBBPF_API int bpf_btf_get_fd_by_id_opts(__u32 id,
+					 const struct bpf_get_fd_opts *opts);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 823aee68dc4e..7db2d963cb55 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -371,6 +371,7 @@ LIBBPF_1.0.0 {
 
 LIBBPF_1.1.0 {
 	global:
+		bpf_btf_get_fd_by_id_opts;
 		bpf_map_get_fd_by_id_opts;
 		bpf_prog_get_fd_by_id_opts;
 } LIBBPF_1.0.0;
-- 
2.25.1


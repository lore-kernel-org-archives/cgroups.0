From: Roberto Sassu <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 2/7] libbpf: Define bpf_get_fd_opts and introduce bpf_map_get_fd_by_id_opts()
Date: Tue,  6 Sep 2022 19:02:56 +0200
Message-ID: <20220906170301.256206-3-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220906170301.256206-1-roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mykolal-b10kYP2dOMg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Define a new data structure called bpf_get_fd_opts, with the member
open_flags, to be used by callers of the _opts variants of
bpf_*_get_fd_by_id() to specify the permissions needed for the file
descriptor to be obtained.

Also, introduce bpf_map_get_fd_by_id_opts(), to let the caller pass a
bpf_get_fd_opts structure.

Finally, keep the existing bpf_map_get_fd_by_id(), and call
bpf_map_get_fd_by_id_opts() with NULL as opts argument, to request
read-write permissions (current behavior).

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/lib/bpf/bpf.c            | 12 +++++++++++-
 tools/lib/bpf/bpf.h            | 10 ++++++++++
 tools/lib/bpf/libbpf.map       |  7 ++++++-
 tools/lib/bpf/libbpf_version.h |  2 +-
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 1d49a0352836..4b03063edf1d 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -948,19 +948,29 @@ int bpf_prog_get_fd_by_id(__u32 id)
 	return libbpf_err_errno(fd);
 }
 
-int bpf_map_get_fd_by_id(__u32 id)
+int bpf_map_get_fd_by_id_opts(__u32 id,
+			      const struct bpf_get_fd_opts *opts)
 {
 	const size_t attr_sz = offsetofend(union bpf_attr, open_flags);
 	union bpf_attr attr;
 	int fd;
 
+	if (!OPTS_VALID(opts, bpf_get_fd_opts))
+		return libbpf_err(-EINVAL);
+
 	memset(&attr, 0, attr_sz);
 	attr.map_id = id;
+	attr.open_flags = OPTS_GET(opts, open_flags, 0);
 
 	fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, attr_sz);
 	return libbpf_err_errno(fd);
 }
 
+int bpf_map_get_fd_by_id(__u32 id)
+{
+	return bpf_map_get_fd_by_id_opts(id, NULL);
+}
+
 int bpf_btf_get_fd_by_id(__u32 id)
 {
 	const size_t attr_sz = offsetofend(union bpf_attr, open_flags);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9c50beabdd14..38a1b7eccfc8 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -365,7 +365,17 @@ LIBBPF_API int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_map_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_btf_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_link_get_next_id(__u32 start_id, __u32 *next_id);
+
+struct bpf_get_fd_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 open_flags; /* permissions requested for the operation on fd */
+	__u32 :0;
+};
+#define bpf_get_fd_opts__last_field open_flags
+
 LIBBPF_API int bpf_prog_get_fd_by_id(__u32 id);
+LIBBPF_API int bpf_map_get_fd_by_id_opts(__u32 id,
+					 const struct bpf_get_fd_opts *opts);
 LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2b928dc21af0..8721829f9c41 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -367,4 +367,9 @@ LIBBPF_1.0.0 {
 		libbpf_bpf_map_type_str;
 		libbpf_bpf_prog_type_str;
 		perf_buffer__buffer;
-};
+} LIBBPF_0.8.0;
+
+LIBBPF_1.1.0 {
+	global:
+		bpf_map_get_fd_by_id_opts;
+} LIBBPF_1.0.0;
diff --git a/tools/lib/bpf/libbpf_version.h b/tools/lib/bpf/libbpf_version.h
index 2fb2f4290080..e944f5bce728 100644
--- a/tools/lib/bpf/libbpf_version.h
+++ b/tools/lib/bpf/libbpf_version.h
@@ -4,6 +4,6 @@
 #define __LIBBPF_VERSION_H
 
 #define LIBBPF_MAJOR_VERSION 1
-#define LIBBPF_MINOR_VERSION 0
+#define LIBBPF_MINOR_VERSION 1
 
 #endif /* __LIBBPF_VERSION_H */
-- 
2.25.1


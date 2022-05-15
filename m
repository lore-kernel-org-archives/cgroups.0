From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH bpf-next v2 3/7] libbpf: Add support for rstat flush progs
Date: Sun, 15 May 2022 02:35:00 +0000
Message-ID: <20220515023504.1823463-4-yosryahmed@google.com>
References: <20220515023504.1823463-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+WjPdyMxAdY9z5Dvu+MUV583iy9AH2h8aY84f8u+NlQ=;
        b=drK5May8XtsY9ItuFqGUPfYPZSwPFC2vfWpY3F0n+trY0R+YgtulCP7PaD0tTJYX87
         /AQzQdehzBXCX/m9XBVR+UEuQM1EiQOLyBQFDJn4AEtc6yk4IHGVD6xEuPAit6b3utLc
         pexcE8FmNCBHJ3vKjD3Wuv4qRyCvS8bOd9hQ3GKXf6M92KdyaHgvs6OqDSt/PCZsV7zJ
         6k2Y0w02FfG3VXu16UcaUq+7hUYRzXqUDru05kCE3TYBetyhT54RS2zi6TSof9r0Hzxu
         PS3sd/eymY2do0BX/aNeXkVD9XqdOm59MkVD8or9jMJzISh5c1W9Xkbe0G/miCcx/pVQ
         EnQw==
In-Reply-To: <20220515023504.1823463-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add support to attach RSTAT_FLUSH programs.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/lib/bpf/bpf.c      |  1 -
 tools/lib/bpf/libbpf.c   | 40 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5660268e103f..9e3cb0d1eb99 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -870,7 +870,6 @@ int bpf_link_create(int prog_fd, int target_fd,
 		attr.link_create.tracing.cookie = OPTS_GET(opts, tracing.cookie, 0);
 		if (!OPTS_ZEROED(opts, tracing))
 			return libbpf_err(-EINVAL);
-		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4867a930628b..b7fc64ebf8dd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8998,6 +8998,7 @@ static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_
 static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_link **link);
+static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 
 static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("socket",		SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -9078,6 +9079,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/setsockopt",	CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
+	SEC_DEF("rstat/flush",		RSTAT_FLUSH, 0, SEC_NONE, attach_rstat),
 };
 
 static size_t custom_sec_def_cnt;
@@ -11784,6 +11786,44 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
 	return libbpf_get_error(*link);
 }
 
+struct bpf_link *bpf_program__attach_rstat(const struct bpf_program *prog)
+{
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int err, prog_fd, link_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return libbpf_err_ptr(-ENOMEM);
+	link->detach = &bpf_link__detach_fd;
+
+	/* rstat flushers are currently the only supported rstat programs */
+	link_fd = bpf_link_create(prog_fd, 0, BPF_RSTAT_FLUSH, NULL);
+	if (link_fd < 0) {
+		err = -errno;
+		pr_warn("prog '%s': failed to attach: %s\n",
+			prog->name, libbpf_strerror_r(err, errmsg,
+						      sizeof(errmsg)));
+		free(link);
+		return libbpf_err_ptr(err);
+	}
+
+	link->fd = link_fd;
+	return link;
+}
+
+static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link)
+{
+	*link = bpf_program__attach_rstat(prog);
+	return libbpf_get_error(*link);
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	struct bpf_link *link = NULL;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 21984dcd6dbe..f8b6827d5550 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -662,6 +662,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_rstat(const struct bpf_program *prog);
+
 /*
  * Libbpf allows callers to adjust BPF programs before being loaded
  * into kernel. One program in an object file can be transformed into
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 008da8db1d94..f945c6265cb5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -449,6 +449,7 @@ LIBBPF_0.8.0 {
 		bpf_program__attach_kprobe_multi_opts;
 		bpf_program__attach_trace_opts;
 		bpf_program__attach_usdt;
+		bpf_program__attach_rstat;
 		bpf_program__set_insns;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
-- 
2.36.0.550.gb090851708-goog


From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 4/5] selftests/bpf: Add new cgroup helper open_classid()
Date: Sun,  3 Sep 2023 14:27:59 +0000
Message-ID: <20230903142800.3870-5-laoar.shao@gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693751294; x=1694356094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5k29RdSdgFGrpvgVrSsKwz4bkGSk589c/WSq1cJmNg=;
        b=UeRpMoL3RZo/I6HJpcYqS1LGiile/X+MgCuNlDOKMNRtUE6jqnjPceQQttncvAEK2+
         aYcJ8+J7L+V6f2gFhH+unfJ90KOwHhJRqPjeWjpyF5OVbadZkibzHnC1VzgZ4EOx5DGd
         m4EMWLXBON//VOBc3USZEo623Bt5+Qzf97HwkchdwJDhAQQ5lutidD1qGLm019WVnfU2
         hs38f59fE1QvY0MHvfFsn9vtiVoPC1B0IbLF9/O0Ll0u2bZceeAzR0pMF7iYsSyljDI7
         i/0ZPzjS7dz8G5d9ySjiPXB52qZiJ3PIqKqt1mii7arGXDPhTZm7V1rDrcF3W/SlwgIU
         MkVA==
In-Reply-To: <20230903142800.3870-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add a new cgroup helper open_classid() to get the net_cls cgroup fd.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 16 ++++++++++++++++
 tools/testing/selftests/bpf/cgroup_helpers.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index f68fbc6..2631efe 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -578,6 +578,22 @@ int join_classid(void)
 }
 
 /**
+ * open_classid() - Open a cgroupv1 net_cls classid
+ *
+ * This function expects the cgroup work dir to be already created, as we
+ * open it here.
+ *
+ * On success, it returns the file descriptor. On failure it returns -1.
+ */
+int open_classid(void)
+{
+	char cgroup_workdir[PATH_MAX + 1];
+
+	format_classid_path(cgroup_workdir);
+	return open(cgroup_workdir, O_RDONLY);
+}
+
+/**
  * cleanup_classid_environment() - Cleanup the cgroupv1 net_cls environment
  *
  * At call time, it moves the calling process to the root cgroup, and then
diff --git a/tools/testing/selftests/bpf/cgroup_helpers.h b/tools/testing/selftests/bpf/cgroup_helpers.h
index 5c2cb9c..ebc0513 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.h
+++ b/tools/testing/selftests/bpf/cgroup_helpers.h
@@ -31,6 +31,7 @@ int write_cgroup_file_parent(const char *relative_path, const char *file,
 /* cgroupv1 related */
 int set_classid(unsigned int id);
 int join_classid(void);
+int open_classid(void);
 
 int setup_classid_environment(void);
 void cleanup_classid_environment(void);
-- 
1.8.3.1


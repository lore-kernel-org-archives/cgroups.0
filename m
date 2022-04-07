From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] selftests: cgroup: return the errno of write() in
 cg_write() on failure
Date: Thu,  7 Apr 2022 22:42:42 +0000
Message-ID: <20220407224244.1374102-3-yosryahmed@google.com>
References: <20220407224244.1374102-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pAk5rXzYOgjs6QN7PF4DKfEiueSRXqJopL6r+G+SYMg=;
        b=qv/ZfWS96JL8ToxxS9HkzUsNxcgjDjomFpfz2944+t+BaDBFk//TDRRG0EQou1qHv2
         eqtDQoRcsXpquUS0GLLciQ+s6RJpZuc5N56AEikJDuC/RYBBajToGFWwv8SSCf70AJn5
         nAvqvnMqE3DpzvAAnlizcVl8NObJlzGhEZrLv1CqOzM7NbEyFhaP9l17bP/X/kcgXvqH
         Z383gcxcH0YzFx6TkICE9yiq1GpgaghTRTqqOm1KrLlQVkWbnwK1LdgyPxl33cFL/TQS
         APv0PQrKflod2nwRa68HyFfut0wbUsxWxrxhZDN+gvGGIijQIlAlL739L4M7oVvMtwlR
         WQkQ==
In-Reply-To: <20220407224244.1374102-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently, cg_write() returns 0 on success and -1 on failure. Modify it
to return the errno of write() syscall on failure.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index dbaa7aabbb4a..ef76db6026aa 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -48,6 +48,8 @@ static ssize_t write_text(const char *path, char *buf, ssize_t len)
 
 	len = write(fd, buf, len);
 	if (len < 0) {
+		/* preserve the errno of write() */
+		len = errno;
 		close(fd);
 		return len;
 	}
@@ -177,17 +179,16 @@ long cg_read_lc(const char *cgroup, const char *control)
 	return cnt;
 }
 
+/* Returns 0 on success, or the errno of write() on failure. */
 int cg_write(const char *cgroup, const char *control, char *buf)
 {
 	char path[PATH_MAX];
-	ssize_t len = strlen(buf);
+	ssize_t len = strlen(buf), ret;
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
 
-	if (write_text(path, buf, len) == len)
-		return 0;
-
-	return -1;
+	ret = write_text(path, buf, len);
+	return ret == len ? 0 : ret;
 }
 
 int cg_find_unified_root(char *root, size_t len)
-- 
2.35.1.1178.g4f1659d476-goog


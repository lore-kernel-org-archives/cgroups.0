From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v2 01/12] cgroup: Update the comment on cgroup_get_from_fd
Date: Thu, 18 Aug 2022 14:31:07 +0000
Message-ID: <20220818143118.17733-2-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=efDyAXQ6g+bmM4mO4s9FEnX/G1io8w/Sb/p1agZBS8OYl+4qzSpqCOAmCv3KAH464o
         yqXHdmbv31M0qS0KPcZ+AfpgUlngTmPnP1urpMeb2TYvCM7sALpSLDshkSIVSeLrLRoF
         9QRaSQEbHv1F0yKOy1EsV9/6nosGOpeu+xYijhMJZB5j2CwYWyjafJJPw/2wgoPOAmX9
         LusMGoVPGPBLhQCbR4KB1vFQXYKGb7ro+K46rcWNOd67jWtcnaicVx8TbJZBi/u+VF8e
         xfkjVg6/1RxyOP6+vO8uXbp3X4dJAawiUTncBQeH7ADAUdm0lWBNB61oEHpzTJH5pQ32
         5q8Q==
In-Reply-To: <20220818143118.17733-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

After commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
we can open a cgroup1 dir as well. So let's update the comment.

Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f4502a..b7d2e55 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6625,7 +6625,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
 
 /**
  * cgroup_get_from_fd - get a cgroup pointer from a fd
- * @fd: fd obtained by open(cgroup2_dir)
+ * @fd: fd obtained by open(cgroup_dir)
  *
  * Find the cgroup from a fd which should be obtained
  * by opening a cgroup directory.  Returns a pointer to the
-- 
1.8.3.1


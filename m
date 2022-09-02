From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 01/13] cgroup: Update the comment on cgroup_get_from_fd
Date: Fri,  2 Sep 2022 02:29:51 +0000
Message-ID: <20220902023003.47124-2-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7uI5yxQ2IficxCafBouZLQeDm3f9EVu1uBy3AFKC6gc=;
        b=OFJXxBSBYOssoMkoywl9EoB3k6QrkEaHd8YL02U+QnpsTC0UA4fodDgpSL5b5LWBLX
         nLgkHuPVwidqPfsnsj8JHUDLGBuIyEEBczjpRgWekusWdvlQ7O5GLfNXILnfWwkwAPMJ
         hcJ2ifQutv33yG3kxTre9B7m3UTbVLhx74iQdT6qSkb9YwbhX7EK8Gsn17MRAfi/hNG1
         6Svh8N4fpVQKpD4jLnAFBmhHGs6Pbi/lGpjyvsVXTIgrjPlqDpEWOT1O2plNLLZMq3/C
         Pyiw6ih9zAawcl99mJzJSBR019T2VD/ls6nn2v1UxhwxYmwSSUpvlAAX2eLUKf3JXR6f
         eZMg==
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>, Yosry Ahmed <yosryahmed@google.com>

After commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
we can open a cgroup1 dir as well. So let's update the comment.

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
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


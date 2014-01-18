From: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] cgroup: place newline before function opening brace
Date: Sat, 18 Jan 2014 16:56:48 +0900
Message-ID: <1390031808-31818-2-git-send-email-sj38.park@gmail.com>
References: <1390031808-31818-1-git-send-email-sj38.park@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vCrpF3PAs1pKP9TWeXRz6JAEUz2+UdmN8vl+lCxGCbE=;
        b=vtNWq1CptGh4HnH+REbVA3KTX0zWZzdEyozLz+kHtnfjdFUt3fjEiv4r42iGIxC08s
         h9oyrY9Hy2ppFsh0h/BJLpqsKGpSuzsnkVs6kFnXtgvbf+SFfP1FFKUXNKjJn0LKiBHl
         tyjTu386/vS54cXvTUWUb44aK+DE1oGmwvNNTyW15C6b7zO9zQp/WodWYlyEoaj3HZ7/
         lsYtYAEexyVt7gihsryAg/uC1EiynGkRLffFa1jwP7C9Lyacfp9QriuMcaEWcanMwML5
         IOABmu4Kaf8TMCWjkjtMHH0oKi2UGBZ9fxe3Kap6bH4h4mqjdara8a05TEpqhqo8Xifj
         LIIA==
In-Reply-To: <1390031808-31818-1-git-send-email-sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4e47e28..e2f46ba 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1679,7 +1679,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	return ERR_PTR(ret);
 }
 
-static void cgroup_kill_sb(struct super_block *sb) {
+static void cgroup_kill_sb(struct super_block *sb)
+{
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgrp_cset_link *link, *tmp_link;
-- 
1.8.3.2

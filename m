From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] cgroup: use parent directly instead of cgroup_parent()
Date: Mon,  4 Oct 2021 08:49:28 +0000
Message-ID: <20211004084928.17622-4-richard.weiyang@gmail.com>
References: <20211004084928.17622-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OexIHL7yzlEUfmmS4I0SOBuDrj/gY0LWs9jL52+pYx8=;
        b=dVemWq3a+2beKnz+1YiJJNW7FjJjN+OMKxBI84+hIT78TOpTeokN1DKavY06NryK/G
         NSlkpM3BEIz/E0QR0Vuc1mDjYlW2qc1JQNFOx+uPebZib3UiQj5abKYXuW2qS6/CFWXw
         9ekjXV0RAfOt9Z/qAg14xStUshEMGk6hfUd5u7jhudiQdowDJ7WpYKwaTkPx8bXwIcHU
         CAOrs1p0ezq+CElVjzy/BjgVVOdKTohTdD31IHlhuQrjkGYO8VsGRwtkJ1CXydpypGPD
         ENSepy47rm13rLAIbt02xFUF42yUX/VjML4/KvrY/JsnMN9iz7sukRqSYIuX/rp+dqBt
         jBDg==
In-Reply-To: <20211004084928.17622-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

During cgroup_create(), we are sure who is our parent.

Let's use parent directly instead of fetch it from cgroup hierarchy.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 457353aeb0ca..694b1c7803c2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5368,7 +5368,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 	cgrp->self.serial_nr = css_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
-	list_add_tail_rcu(&cgrp->self.sibling, &cgroup_parent(cgrp)->self.children);
+	list_add_tail_rcu(&cgrp->self.sibling, &parent->self.children);
 	atomic_inc(&root->nr_cgrps);
 	cgroup_get_live(parent);
 
-- 
2.23.0


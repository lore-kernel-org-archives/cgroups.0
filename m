From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-5.5] cgroup: fix incorrect WARN_ON_ONCE() in
 cgroup_setup_root()
Date: Thu, 14 Nov 2019 14:54:08 -0800
Message-ID: <20191114225408.GO4163745@devbig004.ftw2.facebook.com>
References: <CA+G9fYviReoG+gq=Jm8yQOMd01j2opae5p+VTGGMK7aLn0xWgw@mail.gmail.com>
 <20191114224213.GN4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XRuK6d7TnHtLQBOfr1sWZbQMCgbijX/fPo8dKPOxUls=;
        b=hNHpsL9SI8tkmXRDnJ6SofChw4EGguY7Ld+bMb4T6laRexKpu3RuJzK0JBK27sIkns
         oP8bU+fX4FNl8grxlbg30jPD6X3Oi7kMqGRN9nvULSiW8PZCTVwjAyfefaISq4Po5MBw
         gR/IYgZUI3ENRxoTml7vlWhMJtbir4YEDVxKtkrAr+hR9SJIZWXqFRAFpZ/0TIxd1xeq
         N27Q4dHVhRxWeBTW4JVFqruSgofTf5hvUL0dC8uNFtFe6JViTTR4jBhQZNojXfUmqzDf
         oSoqnt+Xc09OazjqQyJA6dQNNZ5FXWs6MeXDvr7KPOpQoZXwXmuHCnLx3knuTyutLIim
         PbyA==
Content-Disposition: inline
In-Reply-To: <20191114224213.GN4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: cgroups@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, namhyung@kernel.org, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, lizefan@huawei.com, hannes@cmpxchg.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>

Never mind.  I just failed to see the warning on x86_32.  The warning
is spurious and fixed with the following commit.  Applied to
cgroup/for-5.5.

Thanks.

------ 8< ------
From d7495343228f30d8206e92dccfd1c41adcfa142d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Nov 2019 14:46:51 -0800

743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID") added WARN
which triggers if cgroup_id(root_cgrp) is not 1.  This is fine on
64bit ino archs but on 32bit archs cgroup ID is ((gen << 32) | ino)
and gen starts at 1, so the root id is 0x1_0000_0001 instead of 1
always triggering the WARN.

What we wanna make sure is that the ino part is 1.  Fix it.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c12dcf7dc432..53098c1d45e2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1966,7 +1966,7 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 		goto exit_root_id;
 	}
 	root_cgrp->kn = root->kf_root->kn;
-	WARN_ON_ONCE(cgroup_id(root_cgrp) != 1);
+	WARN_ON_ONCE(cgroup_ino(root_cgrp) != 1);
 	root_cgrp->ancestor_ids[0] = cgroup_id(root_cgrp);
 
 	ret = css_populate_dir(&root_cgrp->self);
-- 
2.17.1


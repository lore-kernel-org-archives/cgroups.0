From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.13-fixes] cgroup: fix error return value from
 cgroup_subtree_control()
Date: Sun, 23 Jul 2017 08:14:15 -0400
Message-ID: <20170723121415.GA1498614@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mQD4IbCKKJ3MlxFOTjZ291wgChu7weyeAFUa7OabOuY=;
        b=p0w1PFLswOpu/QwYGV4mEtP8+TKN9lFz363i5T8enpW9uT3AAITjbmMiTV1kZLp0ex
         jihGEYiTXtJg+VRzqhDrsrju4c8hzEoEuW3rbw9JtuBSQQM/C/liMKnqpGVvNH1/EmD3
         YqrWNYU3Wo0Xel48Px5wiIgSlDSvOJHc9nQawwpNoMlI2QUAR4uPofIcuVChwMcmEq7l
         Kv9nxX0YKwVIcJTFVvJdaz4UQpkKeFyfsVZhXXZwNm9lwpwKdAzPCO09Bv4u3DrROYyD
         4ePYqQPuCgZxOxCYPVvmN0RxDgg28T6w/vZQeLPC1AusGMCcGEXNJzlqJDxYrGA1Ppl7
         RWgA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

While refactoring, f7b2814bb9b6 ("cgroup: factor out
cgroup_{apply|finalize}_control() from
cgroup_subtree_control_write()") broke error return value from the
function.  The return value from the last operation is always
overridden to zero.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v4.6+
---
 kernel/cgroup/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3119,11 +3119,11 @@ static ssize_t cgroup_subtree_control_wr
 	cgrp->subtree_control &= ~disable;
 
 	ret = cgroup_apply_control(cgrp);
-
 	cgroup_finalize_control(cgrp, ret);
+	if (ret)
+		goto out_unlock;
 
 	kernfs_activate(cgrp->kn);
-	ret = 0;
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;

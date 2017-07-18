From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.13-fixes] cgroup: create dfl_root files on
 subsys registration
Date: Tue, 18 Jul 2017 17:57:46 -0400
Message-ID: <20170718215746.GG3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
 <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
 <20170718205009.GE3365493@devbig577.frc2.facebook.com>
 <20170718210658.GF3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tEebydgxZIPI63c7/CldSstE6qd+9pLl/Ru4YY7CKcs=;
        b=D2FB/KP5fo0HvErKeJAWTstna7jBbavpDcbMxEH3GRPwKivJrw5KUuwBvYtZaA5gHy
         JciWng129CYVE8Hxj9iaNNmd6fVCFrT1FkfTCQeoN4bShX1H1UOr1AZGqcaIEuYEFMmU
         49fw8XaqZ/yhrF6vot2SSO3cUPU5zA11H/iS0WFrMd3mvECwyTkjpfo19x5zlYHwwIV2
         93b1p6PiZpCOfQLp7RIm6CHkl7/BoJRiVgR5hQsS3zrAFBLTt3cVI/FLChr3f813BDlK
         9ixRqrg1lv8GQniYivu4d30ZgNmSarfZT9GFTCmuvy8MjVgwEXm57d37+xfQPAy9Nd7T
         Ia8Q==
Content-Disposition: inline
In-Reply-To: <20170718210658.GF3365493@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On subsystem registration, css_populate_dir() is not called on the new
root css, so the interface files for the subsystem on cgrp_dfl_root
aren't created on registration.  This is a residue from the days when
cgrp_dfl_root was used only as the parking spot for unused subsystems,
which no longer is true as it's used as the root for cgroup2.

This is often fine as later operations tend to create them as a part
of mount (cgroup1) or subtree_control operations (cgroup2); however,
it's not difficult to mount cgroup2 with the controller interface
files missing as Waiman found out.

Fix it by invoking css_populate_dir() on the root css on subsys
registration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v4.5+
---
Hello, Waiman.

Can you please verify that this fixes the bug?

Thanks.

 kernel/cgroup/cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 620794a..9d33108 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4669,6 +4669,10 @@ int __init cgroup_init(void)
 
 		if (ss->bind)
 			ss->bind(init_css_set.subsys[ssid]);
+
+		mutex_lock(&cgroup_mutex);
+		css_populate_dir(init_css_set.subsys[ssid]);
+		mutex_unlock(&cgroup_mutex);
 	}
 
 	/* init_css_set.subsys[] has been updated, re-hash */

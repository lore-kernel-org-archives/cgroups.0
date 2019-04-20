From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fix for v5.1-rc5
Date: Fri, 19 Apr 2019 17:28:34 -0700
Message-ID: <20190420002834.GJ374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=whM287JCYRLKjBUtoh/GKWmrgoB+ad0LTio69nyTqYU=;
        b=sYQ21R2lr6tXtIJkDpuTpN2tO2/MTL4ii3ThQAIVlgKQEovrSC7Jm+mQOnpHAcgQsK
         SMskNuaol0CtSLXyldsY8iOWusbwYuSRdCh+2aqgLv1xNC2Ro/lQFqjD8EwZvwq5FBFv
         aLRCDr5BuhM5YkTPNDCx9toYAi9/yT2SXxjR1EVvprVO2xASE4dGn4nCVxvF9LgDCT5m
         xaOVXFCpMlhvGCM2APJs4E9kofjI+wA7fwrxsBk5ADRNzWolVyEsh7QqR2+El04Lylx1
         TIiquBSb9L5Xav/SkmVaqbcZ39hHXVQB9DP3JsiMJrKOmSqPrnwzwC4V6v3EJ+rKGvXT
         imZw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

A patch to fix a RCU imbalance error in the devices cgroup
configuration error path.

Thanks.

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.1-fixes

for you to fetch changes up to 0fcc4c8c044e117ac126ab6df4138ea9a67fa2a9:

  device_cgroup: fix RCU imbalance in error case (2019-03-19 10:46:15 -0700)

----------------------------------------------------------------
Jann Horn (1):
      device_cgroup: fix RCU imbalance in error case

 security/device_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index cd97929fac66..dc28914fa72e 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -560,7 +560,7 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
 			rc = dev_exception_add(devcg, ex);
 			if (rc)
-				break;
+				return rc;
 		} else {
 			/*
 			 * in the other possible cases:

-- 
tejun

From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Trivial correction to reflect controller.
Date: Sat,  5 Mar 2016 11:30:56 +0530
Message-ID: <1457157656-5605-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=SnSLqBadRGRO82sh24oTyS2OAuFic8RwDC/EAy03qog=;
        b=LpEqtWpWpAfIP9gBCgKgBF9KFVsDEuP8utsSkyPaHLnhtNy3vj3EYIjxdzn0jPuUys
         P++7dLjleFoIfEHK3H/wruNPhq5uGLmuR6PMLx0itVEmnumytOqOpa4RkhgB6YrXn9Gz
         F5NGikjPYvvrUGaoDtukPtv6Ln3e1F9E/v0NWjYMghlp+evG+UoE1qbV+11JQdkOMAiD
         4wiaLhefONgEWUDAF6oRG9L5ZMPxIRjhr8qmAe1merBoQnA1Bh/zButHHYnwBUmu08Df
         SsAXPCreNPWsQg93WLpXzvTWnmMn3Qf4I4eEAzWEusmxNEjdcW+jIp2Jwdsiy9wlZ1ML
         t+Sw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Trivial correction in menuconfig help to reflect PIDs as
controller instead of subsystem to align to rest of the text
and documentation.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 2232080..9fefb8e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1047,10 +1047,10 @@ config CGROUP_PIDS
 	  is fairly trivial to reach PID exhaustion before you reach even a
 	  conservative kmemcg limit. As a result, it is possible to grind a
 	  system to halt without being limited by other cgroup policies. The
-	  PIDs cgroup subsystem is designed to stop this from happening.
+	  PIDs controller is designed to stop this from happening.
 
 	  It should be noted that organisational operations (such as attaching
-	  to a cgroup hierarchy will *not* be blocked by the PIDs subsystem),
+	  to a cgroup hierarchy will *not* be blocked by the PIDs controller),
 	  since the PIDs limit only affects a process's ability to fork, not to
 	  attach to a cgroup.
 
-- 
1.8.3.1

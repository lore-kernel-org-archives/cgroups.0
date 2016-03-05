From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Documentation: cgroup v2: Trivial heading correction.
Date: Sat,  5 Mar 2016 11:20:58 +0530
Message-ID: <1457157058-4116-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=sm0wCFGTFBK8srYvXYWlAPPJK4gvr53iD4uo+2Hrweg=;
        b=WNvBADpsJhpkSTlarkd8hlh3KSKtq8159gQEdJiMDisQdBIEaaNBLRfDvOOUrkPbi2
         4ix/gqWZw/Mdlko5U2u2hxKzRA4oBAWdumoc8dj/6nmscKv5bfkMVSsm8Vdb7fM1q7+v
         x4GXov0DurSnFHHvoY0HO871h4lxY9L/683WvpuslcIcrZgyBgaW2NU6aQ9EejWG+9NO
         iTgvP0LRpDU0Wz3ZjCs2DZY+GJA489kWT+BT5bzkEz0m3yix5eei0n5TstE9gaHrNhli
         bTtN9ktOBritI32dckxAwgc/RjhkK6twCc8gVKDq7QUwqkbYG6GuXn/7tdah8JcOm8Yr
         0dXw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Corrected the heading to match with index.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroup-v2.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 3922ae1..6039d41 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -898,7 +898,7 @@ PAGE_SIZE multiple when read back.
 	limit, anonymous meomry of the cgroup will not be swapped out.
 
 
-5-2-2. General Usage
+5-2-2. Usage Guidelines
 
 "memory.high" is the main mechanism to control memory usage.
 Over-committing on high limit (sum of high limits > available memory)
-- 
1.8.3.1

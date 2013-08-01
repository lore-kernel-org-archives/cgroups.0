From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V5 8/8] memcg: Document cgroup dirty/writeback memory statistics
Date: Thu,  1 Aug 2013 20:00:43 +0800
Message-ID: <1375358443-10817-1-git-send-email-handai.szj@taobao.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=4ycYd4HqWSL4W7TVJ+l3FivV3qlNk/p9uTN+wnzd0VU=;
        b=qH/CSa2u8j3Rc6atCM67CmJnvGy5zpYdX5qJwV9jP6Nb61kOPiDqIUi90b2sYLtMih
         1DDE+G0URD6t7axPxHt3bLln9OvaIxIaqtz8RTwpb5IN5KiVv1ooq7MxNy2Nr5ZNkXe+
         R0Ew1jm5E3K8RhRTGpqCdJ5A94zH7bsoT3oEBFjZLU7CG99FuUljqKeN7VGVoo6VTwdx
         0krrkVXAtZn5c9C1Ar9Ahh8ST/5mosGi6yPayVlJuXhi3YnJf2Gz0QqK7Jnf317wAcsZ
         ba+HApuRBgEIqXyqPu4K9FOWx7yQHO8LzHN/4SfbqSnVt/WGRTLgOAW15HiWahj0derU
         XNfA==
In-Reply-To: <1375357402-9811-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 327acec..7ed4fa9 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -490,6 +490,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+dirty          - # of bytes of file cache that are not in sync with the disk copy.
+writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.9.5

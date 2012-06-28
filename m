From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] memcg: update cgroup memory document
Date: Thu, 28 Jun 2012 18:57:35 +0800
Message-ID: <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=VIz9CCJWCk9Ip6ao9lt+oJOB7pNPPqphlBhYWIrR63I=;
        b=rWIgxu2sTBjjZH+wmIuhkBF2taAQ8IDGpYORBb44AcwJHLdA4n2+a3UhB35QUQ/WpM
         dmuPv8QMY7L/d+op42aIcx4rS3tqRZvb+aU6/QDbVSYXGWRpUObCENa164Xm5WAkKiso
         J65/NtcgnmQtaaoZF9i3fZ5l6bzA8bS/qnNj/SgyvMhrPSohI3+LwSOOZPCfQQ3u+/pn
         ugVNZ0EQCijgKp6tXq8FTx1khhyEbrHTJZuCJPDpt7Pks2VZGKBOpcvDAOx6r3evnDbf
         nYTsQiPv7nJVdqobXAadCYKuhRL/2HmabeSjvqLZNQYfzBtuoqRTkv+2yvPI8oB2FO5A
         R05A==
In-Reply-To: <1340880885-5427-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Document cgroup dirty/writeback memory statistics.

The implementation for these new interface routines come in a series
of following patches.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd88540..24d7e3c 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -420,6 +420,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+dirty		- # of bytes that are waiting to get written back to the disk.
+writeback	- # of bytes that are actively being written back to the disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.1

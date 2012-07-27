From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 6/6] memcg: Document cgroup dirty/writeback memory statistics
Date: Fri, 27 Jul 2012 18:31:42 +0800
Message-ID: <1343385102-20282-1-git-send-email-handai.szj@taobao.com>
References: <1343384432-19903-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=XEnx6ZzSgJQqctt1W9Q2vJ4QvB65BE/UR02eCimgh4c=;
        b=SU3FIEDb2NluTW51xYOhEM667w+p9nT+j91D5S4QTW7Tak3VWH2T5mM8Z00+BkbsSb
         jRP7f1UkPJRcrlmQ6JkSwJHd5aEpFzkkdtue0nI13B/LJXLizUsklnQQL2bA6up5nfZL
         CU1+J+nNtPu3kktfF1+2vHlRIgg7ScJdDWlyhfXEZCFSEIlek/DsdqC71sc4qP23hxI0
         D7n88N6aukbg/aQR6b0vPv52VBXYdY+trxP/J01FwL/yiM0OqUIOQKAoYEcA+dcifvpX
         lGGlBspeBhgY9nUSKqfAVtWJlUGTJbadgaMt+WKuk0sDVQtvb2Zx39MTJ+xW/9UOYL/E
         PAuQ==
In-Reply-To: <1343384432-19903-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Ackedy-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd88540..f4b5778 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -420,6 +420,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+dirty		- # of bytes of file cache that are not in sync with the disk copy.
+writeback	- # of bytes of file/anon cache that are queued for syncing to disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.1

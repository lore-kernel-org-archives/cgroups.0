From: David Rientjes <rientjes@google.com>
Subject: [patch 01/11] fork: collapse copy_flags into copy_process
Date: Tue, 4 Mar 2014 19:58:41 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041953570.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=YDoXJ3AVf1ZssOUUqCx7Ji3XqlgyMHZZoCxIWFgNBPA=;
        b=JB5vPbJZUeTteNl18876JMafj+IYbfjIRfSZuwXU/jyH1S507fQShd0I64VrQPSBrN
         eDQMSvIDec5W3tYC5fyosZsiKtibcU79WXVfYlNrUv5125oPiV6VmFyOTQqyykVNO+Pu
         rX7I3peGADJfN+o1I1gm4ufv8oVNP/E8Bdy2OLlIpOoYDTZbwZcePnqe/DZYjUU8vnGA
         my5FkT1OoGPmuMrh6au1fmoD3msEhtD7/M+nEOzJGGySfD7O0WEUQSw7zhQC1SFNur8q
         tG1XMJj8h8MHnRyNjzlUxtR7tH42EpA5NXwfWIC57xyDijlc1DpXqcsDMuL+Zqsz52Q0
         4cKg==
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

copy_flags() does not use the clone_flags formal and can be collapsed
into copy_process() for cleaner code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/fork.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1069,15 +1069,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static void copy_flags(unsigned long clone_flags, struct task_struct *p)
-{
-	unsigned long new_flags = p->flags;
-
-	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
-	new_flags |= PF_FORKNOEXEC;
-	p->flags = new_flags;
-}
-
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1227,7 +1218,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_count;
 
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
-	copy_flags(clone_flags, p);
+	p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+	p->flags |= PF_FORKNOEXEC;
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

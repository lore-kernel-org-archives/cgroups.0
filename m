From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 1/5] mm: invoke oom-killer from remaining unconverted page
 fault handlers
Date: Fri, 19 Jul 2013 00:22:38 -0400
Message-ID: <20130719042238.GD17812@cmpxchg.org>
References: <20130710182506.F25DF461@pobox.sk>
 <20130711072507.GA21667@dhcp22.suse.cz>
 <20130714012641.C2DA4E05@pobox.sk>
 <20130714015112.FFCB7AF7@pobox.sk>
 <20130715154119.GA32435@dhcp22.suse.cz>
 <20130715160006.GB32435@dhcp22.suse.cz>
 <20130716153544.GX17812@cmpxchg.org>
 <20130716160905.GA20018@dhcp22.suse.cz>
 <20130716164830.GZ17812@cmpxchg.org>
 <20130719042124.GC17812@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130719042124.GC17812-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

[already upstream, included for 3.2 reference]

A few remaining architectures directly kill the page faulting task in an
out of memory situation.  This is usually not a good idea since that
task might not even use a significant amount of memory and so may not be
the optimal victim to resolve the situation.

Since 2.6.29's 1c0fe6e ("mm: invoke oom-killer from page fault") there
is a hook that architecture page fault handlers are supposed to call to
invoke the OOM killer and let it pick the right task to kill.  Convert
the remaining architectures over to this hook.

To have the previous behavior of simply taking out the faulting task the
vm.oom_kill_allocating_task sysctl can be set to 1.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Vineet Gupta <vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>   [arch/arc bits]
Cc: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>
Cc: Chen Liqin <liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org>
Cc: Lennox Wu <lennox.wu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 arch/mn10300/mm/fault.c  | 7 ++++---
 arch/openrisc/mm/fault.c | 8 ++++----
 arch/score/mm/fault.c    | 8 ++++----
 arch/tile/mm/fault.c     | 8 ++++----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 0945409..5ac4df5 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -329,9 +329,10 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	printk(KERN_ALERT "VM: killing process %s\n", tsk->comm);
-	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR)
-		do_exit(SIGKILL);
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR) {
+		pagefault_out_of_memory();
+		return;
+	}
 	goto no_context;
 
 do_sigbus:
diff --git a/arch/openrisc/mm/fault.c b/arch/openrisc/mm/fault.c
index a5dce82..d78881c 100644
--- a/arch/openrisc/mm/fault.c
+++ b/arch/openrisc/mm/fault.c
@@ -246,10 +246,10 @@ out_of_memory:
 	__asm__ __volatile__("l.nop 1");
 
 	up_read(&mm->mmap_sem);
-	printk("VM: killing process %s\n", tsk->comm);
-	if (user_mode(regs))
-		do_exit(SIGKILL);
-	goto no_context;
+	if (!user_mode(regs))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff --git a/arch/score/mm/fault.c b/arch/score/mm/fault.c
index 47b600e..6b18fb0 100644
--- a/arch/score/mm/fault.c
+++ b/arch/score/mm/fault.c
@@ -172,10 +172,10 @@ out_of_memory:
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
-	printk("VM: killing process %s\n", tsk->comm);
-	if (user_mode(regs))
-		do_group_exit(SIGKILL);
-	goto no_context;
+	if (!user_mode(regs))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 25b7b90..3312531 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -540,10 +540,10 @@ out_of_memory:
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
-	pr_alert("VM: killing process %s\n", tsk->comm);
-	if (!is_kernel_mode)
-		do_group_exit(SIGKILL);
-	goto no_context;
+	if (is_kernel_mode)
+		goto no_context;
+	pagefault_out_of_memory();
+	return 0;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
-- 
1.8.3.2

From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] KVM: Move VM's worker kthreads back to the original cgroup
 before exiting.
Date: Thu, 17 Feb 2022 06:16:16 +0000
Message-ID: <20220217061616.3303271-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+ImC79Dcr6MPcSexLv46tRLEGOitgoCcctAfOPO5qjY=;
        b=YNCjCeuT5YwOr8Vwll+nu+pLmG5IRCsOmwtIXVBSpZ9mO3kW7DRPbjJPbhz36fdUtf
         Y+5Z2xT0WVGttuPyK/7l91ZtKqwGZar8SyzqEtQ1kYlfu6yDD1CA1q0W6WuMCHCbX+By
         jFkNLehZQjKpcbJqc/Bbr4VeR55M+Q8TCVdKl3jAodvkAXAELlXZEA4U/5QOslMZQDI0
         /x4Iq4ezjYggiFwXGZ4j0ZVduynMWRU+TnVpaqNXcXC81Vo+azZa4t6v23aNJBQpkmJr
         EHNBQD6OWHFtMqqBfQgg+NJysxYuTnbJMOjqK8qCstomIvIxxiTsK9eWe8ya3vqYxkLE
         Fpwg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

VM worker kthreads can linger in the VM process's cgroup for sometime
after KVM terminates the VM process.

KVM terminates the worker kthreads by calling kthread_stop() which waits
on the 'exited' completion, triggered by exit_mm(), via mm_release(), in
do_exit() during the kthread's exit.  However, these kthreads are
removed from the cgroup using the cgroup_exit() which happens after the
exit_mm(). Therefore, a VM process can terminate in between the
exit_mm() and cgroup_exit() calls, leaving only worker kthreads in the
cgroup.

Moving worker kthreads back to the original cgroup (kthreadd_task's
cgroup) makes sure that the cgroup is empty as soon as the main VM
process is terminated.

Signed-off-by: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

v3:
- Use 'current->real_parent' (kthreadd_task) in the
  cgroup_attach_task_all() call.
- Revert cgroup APIs changes in v2. Now, patch does not touch cgroup
  APIs.
- Update commit and comment message

v2: https://lore.kernel.org/lkml/20211222225350.1912249-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
- Use kthreadd_task in the cgroup API to avoid build issue.

v1: https://lore.kernel.org/lkml/20211214050708.4040200-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

 virt/kvm/kvm_main.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83c57bcc6eb6..2c9dcfffb606 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5813,7 +5813,7 @@ static int kvm_vm_worker_thread(void *context)
 	struct kvm *kvm = init_context->kvm;
 	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
 	uintptr_t data = init_context->data;
-	int err;
+	int err, reattach_err;
 
 	err = kthread_park(current);
 	/* kthread_park(current) is never supposed to return an error */
@@ -5836,7 +5836,7 @@ static int kvm_vm_worker_thread(void *context)
 	init_context = NULL;
 
 	if (err)
-		return err;
+		goto out;
 
 	/* Wait to be woken up by the spawner before proceeding. */
 	kthread_parkme();
@@ -5844,6 +5844,23 @@ static int kvm_vm_worker_thread(void *context)
 	if (!kthread_should_stop())
 		err = thread_fn(kvm, data);
 
+out:
+	/*
+	 * Move kthread back to its original cgroup to prevent it lingering in
+	 * the cgroup of the VM process, after the latter finishes its
+	 * execution.
+	 *
+	 * kthread_stop() waits on the 'exited' completion condition which is
+	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
+	 * kthread is removed from the cgroup in the cgroup_exit() which is
+	 * called after the exit_mm(). This causes the kthread_stop() to return
+	 * before the kthread actually quits the cgroup.
+	 */
+	reattach_err = cgroup_attach_task_all(current->real_parent, current);
+	if (reattach_err) {
+		kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
+			__func__, reattach_err);
+	}
 	return err;
 }
 

base-commit: db6e7adf8de9b3b99a9856acb73870cc3a70e3ca
-- 
2.35.1.265.g69c8d7142f-goog


From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Date: Tue, 22 Feb 2022 09:35:04 +0100
Message-ID: <53d4b30e-2563-c13b-eadc-8372ae965fcb@redhat.com>
References: <20220222054848.563321-1-vipinsh@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645518909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E30WgXgAZRS6lQUJeUsCZdCeBdcikCP7h9EfQ36uBTo=;
        b=UJMzrzulJM+sJcwYbHJ7oHygzi6LHm2GPOWWkp8P9E2wBv6YBEGMbFbr4cFubqKiuUOdZZ
        WWWs+4WvIobdLTQMQJuNtl2SRcTfep1422bJql3B1s/ySvb5xOwvpW+rBa7xovpQ9VBf7s
        z8uJNIENFv1/EpH+NQ5+6BREwyFPGyA=
Content-Language: en-US
In-Reply-To: <20220222054848.563321-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vipin Sharma <vipinsh@google.com>, seanjc@google.com
Cc: mkoutny@suse.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2/22/22 06:48, Vipin Sharma wrote:
> VM worker kthreads can linger in the VM process's cgroup for sometime
> after KVM terminates the VM process.
> 
> KVM terminates the worker kthreads by calling kthread_stop() which waits
> on the 'exited' completion, triggered by exit_mm(), via mm_release(), in
> do_exit() during the kthread's exit.  However, these kthreads are
> removed from the cgroup using the cgroup_exit() which happens after the
> exit_mm(). Therefore, A VM process can terminate in between the
> exit_mm() and cgroup_exit() calls, leaving only worker kthreads in the
> cgroup.
> 
> Moving worker kthreads back to the original cgroup (kthreadd_task's
> cgroup) makes sure that the cgroup is empty as soon as the main VM
> process is terminated.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---

Queued, thanks.

Paolo

> Thanks Sean, for the example on how to use the real_parent outside of the RCU
> critical region. I wrote your name in Suggested-by, I hope you are fine with
> it and this is the right tag/way to give you the credit.
> 
> v4:
> - Read task's real_parent in the RCU critical section.
> - Don't log error message from the cgroup_attach_task_all() API.
> 
> v3: https://lore.kernel.org/lkml/20220217061616.3303271-1-vipinsh@google.com/
> - Use 'current->real_parent' (kthreadd_task) in the
>    cgroup_attach_task_all() call.
> - Revert cgroup APIs changes in v2. Now, patch does not touch cgroup
>    APIs.
> - Update commit and comment message
> 
> v2: https://lore.kernel.org/lkml/20211222225350.1912249-1-vipinsh@google.com/
> - Use kthreadd_task in the cgroup API to avoid build issue.
> 
> v1: https://lore.kernel.org/lkml/20211214050708.4040200-1-vipinsh@google.com/
> 
>   virt/kvm/kvm_main.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..cdf1fa3c60ae 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5810,6 +5810,7 @@ static int kvm_vm_worker_thread(void *context)
>   	 * we have to locally copy anything that is needed beyond initialization
>   	 */
>   	struct kvm_vm_worker_thread_context *init_context = context;
> +	struct task_struct *parent;
>   	struct kvm *kvm = init_context->kvm;
>   	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
>   	uintptr_t data = init_context->data;
> @@ -5836,7 +5837,7 @@ static int kvm_vm_worker_thread(void *context)
>   	init_context = NULL;
>   
>   	if (err)
> -		return err;
> +		goto out;
>   
>   	/* Wait to be woken up by the spawner before proceeding. */
>   	kthread_parkme();
> @@ -5844,6 +5845,25 @@ static int kvm_vm_worker_thread(void *context)
>   	if (!kthread_should_stop())
>   		err = thread_fn(kvm, data);
>   
> +out:
> +	/*
> +	 * Move kthread back to its original cgroup to prevent it lingering in
> +	 * the cgroup of the VM process, after the latter finishes its
> +	 * execution.
> +	 *
> +	 * kthread_stop() waits on the 'exited' completion condition which is
> +	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
> +	 * kthread is removed from the cgroup in the cgroup_exit() which is
> +	 * called after the exit_mm(). This causes the kthread_stop() to return
> +	 * before the kthread actually quits the cgroup.
> +	 */
> +	rcu_read_lock();
> +	parent = rcu_dereference(current->real_parent);
> +	get_task_struct(parent);
> +	rcu_read_unlock();
> +	cgroup_attach_task_all(parent, current);
> +	put_task_struct(parent);
> +
>   	return err;
>   }
>   
> 
> base-commit: 1bbc60d0c7e5728aced352e528ef936ebe2344c0


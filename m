From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Tue, 28 Dec 2021 17:17:41 +0000
Message-ID: <YctGtWzYcNP2iTaN@google.com>
References: <20211222225350.1912249-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ivoEdS/CxNoGT7D8SqF0HNjUYAr9Hq6dlyJRhMADj5U=;
        b=mE6AwGIQ3sval0uBHIKCCq+gF2bQ7hglSjPsTsleu2wn0+ggU2al7iWlZSUBWYp6/U
         L2ClRIPzUoRTvHwD/IoZcmKsJvbS5ND/UrnQl+3+TfS3g6V8fIkCuLr2Fle/F2GL6D1y
         E6BXtrTkjuOBPsiaG0tMdkhQy+RW1SwuGVTxXj1KuwQaLfRc6I2IN+GUMo93p1EVtVyJ
         2FUGCZzPjE//OZQsKHMVP2fQbmyeOWU82IN/kXeEizDHzXnvqCziCoOIRj3799XlISo5
         aENIZTOWJLYG1KnocCv8m3Me3F4WGRrooPpJjvRFa6iM92TmU0WyOvaSVg6CdAuCgUPb
         l6ug==
Content-Disposition: inline
In-Reply-To: <20211222225350.1912249-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 22, 2021, Vipin Sharma wrote:
> kthreadd_task is not an exported symbol which causes build errors if KVM
> is built as a loadable module. Both users (kvm_main & vhost) of
> cgroup_attach_task_all(), have the same issue, therefore, using
> kthreadd_task as a default option is chosen when the API is called with
> NULL argument.

...

> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 81c9e0685948..81d4b2f2acf0 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -51,6 +51,8 @@ bool cgroup1_ssid_disabled(int ssid)
>   * @from: attach to all cgroups of a given task
>   * @tsk: the task to be attached
>   *
> + * If @from is NULL then use kthreadd_task for finding the destination cgroups.
> + *
>   * Return: %0 on success or a negative errno code on failure
>   */
>  int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
> @@ -58,6 +60,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
>  	struct cgroup_root *root;
>  	int retval = 0;
>  
> +	if (!from)
> +		from = kthreadd_task;

Rather than sully cgroup_attach_task_all() with this behavior, can't KVM do

	cgroup_attach_task_all(current->real_parent, current)

since AFAICT real_parent is guaranteed to point at kthreadd_task.

> +
>  	mutex_lock(&cgroup_mutex);
>  	percpu_down_write(&cgroup_threadgroup_rwsem);
>  	for_each_root(root) {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b0f7e6eb00ff..f7504578c374 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5785,7 +5785,7 @@ static int kvm_vm_worker_thread(void *context)
>  	init_context = NULL;
>  
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	/* Wait to be woken up by the spawner before proceeding. */
>  	kthread_parkme();
> @@ -5793,6 +5793,19 @@ static int kvm_vm_worker_thread(void *context)
>  	if (!kthread_should_stop())
>  		err = thread_fn(kvm, data);
>  
> +out:
> +	/*
> +	 * We need to move the kthread back to its original cgroups, so that it

Please state what is being done, not what "needs" to be done.  The need to do
something is implicit, otherwise we wouldn't be doing it.

> +	 * doesn't linger in the cgroups of the user process after the user
> +	 * process has already terminated.
> +	 *
> +	 * kthread_stop() waits on 'exited' completion condition which is set
> +	 * in exit_mm(), via mm_release(), in do_exit(). However, kthread
> +	 * is removed from cgroups in the cgroup_exit() which is called after
> +	 * exit_mm(). This causes lingering of kthreads in cgroups after main
> +	 * VM process has finished.
> +	 */
> +	WARN_ON(cgroup_attach_task_all(NULL, current));

This should not WARN, cgroup_attach_task_all() needs to perform allocations and
will fail with -ENOMEM even in the absense of kernel bugs.

>  	return err;
>  }
>  
> 
> base-commit: 5e4e84f1124aa02643833b7ea40abd5a8e964388
> -- 
> 2.34.1.307.g9b7440fafd-goog
> 

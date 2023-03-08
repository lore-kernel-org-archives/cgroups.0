From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Date: Wed, 8 Mar 2023 06:50:27 -0700
Message-ID: <cd4eee4d-fb29-e8b7-1212-e8840af6b44f@kernel.dk>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678283429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGMh7z+uu7UWSjKT1r63vloQOO9D03iCCkuaAImHSZE=;
        b=ood+JQd114oTw8IWazm67avBWKR6V6c14YJMJkcOAkP0PpHWd5KpMG/b3eRMLVojwB
         exzew6I3c8kM2IPAJCvhyRw2Uh0yzJjYcDx3Kxr4dHJ8BqKs5HuajQ3UpehfQFhgJfPV
         DU8lF1t7FRLcbXW6ki9gxFeq82aXmMsu/Y3nQb+2rP29C8BBWcz6ykcyZQtFNcYtNu7q
         iTBaRSbbqZTmTmkWWOyMrvTs7mcjWZdoqKf4ARQSL/twL5TvCt3aidsvBkGws6Udg0DF
         Tl0+chI7Vlg+t2hDS09pG8RjQDLINIu/+5px4+O18e9lDbgmyPrJXpB9jf+Fyoa9j104
         qCGw==
Content-Language: en-US
In-Reply-To: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On 3/8/23 4:42?AM, Daniel Dao wrote:
> Hi all,
> 
> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
> worker threads are running. Here are the steps to reproduce the failure
> on kernel 6.1.14:
> 
> 1. Remove cpuset from subtree_control
> 
>   > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>   > cat /sys/fs/cgroup/cgroup.subtree_control
>   cpu io memory pids
> 
> 2. Run any applications that utilize the uring worker thread pool. I used
>    https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
> 
>   > cargo run -- -a -w 2 -t 2
> 
> 3. Enabling cpuset will return EINVAL
> 
>   > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>   +cpuset
>   tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
> 
> We traced this down to task_can_attach that will return EINVAL when it
> encounters
> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
> 
> This seems like an unexpected interaction when enabling cpuset for the subtrees
> that contain kthreads. We are currently considering a workaround to try to
> enable cpuset in root subtree_control before any io_uring applications
> can start,
> hence failure to enable cpuset is localized to only cgroup with
> io_uring kthreads.
> But this is cumbersome.
> 
> Any suggestions would be very much appreciated.

One important thing to note here is that io_uring workers are not
kthreads, but like kthreads, they set PF_NO_SETAFFINITY which prevents
userspace from moving them around. We do have an explicit API for
setting the affinity of workers associated with an io_uring context,
however.

But you are not the first to come across this, and I'm pondering how we
can improve this situation. io-wq blocks changing the CPU affinity
because it organizes workers within a node, but this is purely an
optimization and not integral to how it works.

One thing we could do is simply check the cpumask of the worker after it
went to sleep, and if it woke up due to a timeout (eg not to handle real
work). That'd lazily drop workers that are now not affinitized
correctly. With that, I think it'd be sane to drop the PF_NO_SETAFFINITY
mask from the worker. Something like the below, would be great if you
could test.


diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 411bb2d1acd4..669f50cb4e90 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -616,7 +616,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
+	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -632,8 +632,11 @@ static int io_wqe_worker(void *data)
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
+		/*
+		 * Last sleep timed out. Exit if we're not the last worker,
+		 * or if someone modified our affinity.
+		 */
+		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
@@ -652,7 +655,11 @@ static int io_wqe_worker(void *data)
 				continue;
 			break;
 		}
-		last_timeout = !ret;
+		if (!ret) {
+			last_timeout = true;
+			exit_mask = !cpumask_test_cpu(smp_processor_id(),
+							wqe->cpu_mask);
+		}
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -704,7 +711,6 @@ static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 	tsk->worker_private = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
-	tsk->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);

-- 
Jens Axboe


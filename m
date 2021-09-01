From: Hao Xu <haoxu@linux.alibaba.com>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding sqpoll
 cpu
Date: Wed, 1 Sep 2021 20:31:26 +0800
Message-ID: <bd6e3eef-b4ba-b185-f8bc-23f8b5886235@linux.alibaba.com>
References: <20210901101833.69535-1-haoxu@linux.alibaba.com>
 <20210901101833.69535-3-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
In-Reply-To: <20210901101833.69535-3-haoxu@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

在 2021/9/1 下午6:18, Hao Xu 写道:
> Since sqthread is userspace like thread now, it should respect cgroup
> setting, thus we should consider current allowed cpuset when doing
> cpu binding for sqthread.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7cc458e0b636..414dfedf79a7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -79,6 +79,7 @@
>   #include <linux/pagemap.h>
>   #include <linux/io_uring.h>
>   #include <linux/tracehook.h>
> +#include <linux/cpuset.h>
>   
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>
> @@ -7102,6 +7103,14 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
>   	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>   }
>   
> +static inline int io_sq_bind_cpu(int cpu)
> +{
> +	if (test_cpu_in_current_cpuset(cpu))
> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +
> +	return 0;
Ah, no need to return value anymore, even no need to have this function
here. I'll resend a new version.
> +}
> +
>   static int io_sq_thread(void *data)
>   {
>   	struct io_sq_data *sqd = data;
> @@ -7112,11 +7121,9 @@ static int io_sq_thread(void *data)
>   
>   	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>   	set_task_comm(current, buf);
> -
>   	if (sqd->sq_cpu != -1)
> -		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
> -	else
> -		set_cpus_allowed_ptr(current, cpu_online_mask);
> +		io_sq_bind_cpu(sqd->sq_cpu);
> +
>   	current->flags |= PF_NO_SETAFFINITY;
>   
>   	mutex_lock(&sqd->lock);
> @@ -8310,8 +8317,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>   			int cpu = p->sq_thread_cpu;
>   
>   			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>   				goto err_sqpoll;
> +
>   			sqd->sq_cpu = cpu;
>   		} else {
>   			sqd->sq_cpu = -1;
> 


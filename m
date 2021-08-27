From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
Date: Fri, 27 Aug 2021 07:26:00 -1000
Message-ID: <YSkgKN/LviOvmeVH@slm.duckdns.org>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JexU7pxLZh7dMrL0m6OI3CAh+vKRYotj43WZBu/Ai/M=;
        b=VInnHdsRt8LuVmniN9Y4sXNbMaVM8sWuIIwu0Kl5P7zmaTdTFC9Z9vUrnwPa6aujcT
         +T9xfC3lBEJNM0IjEdcdxaWsr0YxqQy4CL1LvP6XZOAECIEUOiQ3HBiwUQrNhITef2FH
         MRMJJ/j22tkoT95SIk+tzjYIIQx7Ubhb8jw/5T+2w1ykCqjYH3PF8+GwodNUy5pHza42
         DcMMAw+bPX2VET+gAZyrS3p4TmIOdcvT3r0jmdRQjicuthvWPavG5kOAP0D4DUMpNhBK
         dI5eTuSAmKwZPNTLWC3in791lzjiJplOm9FblTLRQtGB3UZjKVba1nbGZXHfY18/unqm
         vGdQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210827141315.235974-1-haoxu@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <haoxu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>, Waiman Long <longman@redhat.com>

Hello,

On Fri, Aug 27, 2021 at 10:13:15PM +0800, Hao Xu wrote:
> +static int io_sq_bind_cpu(int cpu)
> +{
> +	if (!test_cpu_in_current_cpuset(cpu))
> +		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
> +	else
> +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +
> +	return 0;
> +}
...
> @@ -8208,8 +8217,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>  				goto err_sqpoll;

Given that sq_thread is user-like thread and belongs to the right cgroup,
I'm not quite sure what the above achieves - the affinities can break
anytime, so one-time check doesn't really solve the problem. All it seems to
add is warning messages. What's the expected behavior when an io thread
can't run on the target cpu anymore?

Thanks.

-- 
tejun

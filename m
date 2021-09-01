From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Date: Wed, 1 Sep 2021 06:41:34 -1000
Message-ID: <YS+tPq1eiQLx4P3M@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3lCl2Zr4586JDbLss9c1Hxd0EDusuIq7XoCp7hO6f+s=;
        b=m3Y2MP55Y3bNEL27hIHDl3XWn7dr4Z1bU+Luwd0dxdd1NhsNWmuniHYfQxc6eVVuA6
         82IN4oQo6EAZAp0DcliksCcUhUHerSeV1Y67Fb4QDRMjuh6oCc6h7Gkf/1CceA3PNuEu
         ojvOFF2T48OlAWDnb82P4XCf7gfZY4N1hvbcxOgLT2CEkjei7Zn+wkzsL612q5ZnlmZT
         GjU65Zz70GKduLdcxpvIwBpnFQ2kvpHWdU+1P1NfKTlXE4W/5go5W21dZ9WykriCs7oN
         wwym1FkUsSrzuqyrbydk9oHWWSSqOXAzaJJspnPT5CwA88XNP8THGGmqQQycGcXjdoJp
         Ki3w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210901124322.164238-3-haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hello,

On Wed, Sep 01, 2021 at 08:43:22PM +0800, Hao Xu wrote:
> @@ -7112,11 +7113,9 @@ static int io_sq_thread(void *data)
>  
>  	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>  	set_task_comm(current, buf);
> +	if (sqd->sq_cpu != -1 && test_cpu_in_current_cpuset(sqd->sq_cpu))
>  		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
> +

Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
afterwards?

> @@ -8310,8 +8309,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
> +			    !test_cpu_in_current_cpuset(cpu))
>  				goto err_sqpoll;
> +

Failing operations on transient conditions like this may be confusing. Let's
ignore cpuset for now. CPU hotplug is sometimes driven automatically for
power saving purposes, so failing operation based on whether a cpu is online
means that the success or failure of the operation can seem arbitrary. If
the operation takes place while the cpu happens to be online, it succeeds
and the thread gets unbound and rebound automatically as the cpu goes
offline and online. If the operation takes place while the cpu happens to be
offline, the operation fails.

I don't know what the intended behavior here should be and we haven't been
pretty bad at defining reasonable behavior around cpu hotplug, so it'd
probably be worthwhile to consider what the behavior should be.

Thanks.

-- 
tejun

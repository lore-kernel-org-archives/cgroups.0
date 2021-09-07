From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Date: Tue, 7 Sep 2021 06:54:42 -1000
Message-ID: <YTeZUnshr+mgf5GS@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
 <c49d9b26-1c74-316a-c933-e6964695a286@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7X+MAD+O4i6lx7LuI7hH2on7g8eQNGgU/wJ36NpdYh4=;
        b=eubzwKVVC4VzgcIyTRLt0pLO0CCnZWAqROHlGfIrLGLWAWPaAY7wEQANFU9gvN95Qe
         +TOfD7/ccTYy+P00LLTJhWiJEa6BwfYgmPrrKECC5dS/vWSv30uJpL8oAQE4J2kM6B5q
         yxFR37qDVhzUg/OrwyaRADeaW5QiTucbod20aglj3guXezrQML+P6UJAc/3AsDO6LWRC
         cgtdRKlH8zoxr2XXhyl9p1k9vyODaGdEhhB8Ey5p6RQ1eTziKxQgcLkjMGT/l1g92HsS
         00FJ7AZANZADEmq2sKjR4xKRVbWuYS72GmV36DO2FYswoL9oeTTNIFs070pXCwdbk2lD
         ++EA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c49d9b26-1c74-316a-c933-e6964695a286-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hello,

On Fri, Sep 03, 2021 at 11:04:07PM +0800, Hao Xu wrote:
> > Would it make sense to just test whether set_cpus_allowed_ptr() succeeded
> > afterwards?
> Do you mean: if (sqd->sq_cpu != -1 && !set_cpus_allowed_ptr(current,
> cpumask_of(sqd->sq_cpu)))
> 
> I'm not familiar with set_cpus_allowed_ptr(), you mean it contains the
> similar logic of test_cpu_in_current_cpuset?

It's kinda muddy unfortunately. I think it rejects if the target cpu is
offline but accept and ignores if the cpu is excluded by cpuset.

> This is a bit beyond of my knowledge, so you mean if the cpu back
> online, the task will automatically schedule to this cpu? if it's true,
> I think the code logic here is fine.
>
> > offline and online. If the operation takes place while the cpu happens to be
> > offline, the operation fails.
> It's ok that it fails, we leave the option of retry to users themselves.

I think the first thing to do is defining the desired behavior, hopefully in
a consistent manner, rather than letting it be defined by implementation.
e.g. If the desired behavior is the per-cpu helper failing, then it should
probably exit when the target cpu isn't available for whatever reason. If
the desired behavior is best effort when cpu goes away (ie. ignore
affinity), the creation likely shouldn't fail when the target cpu is
unavailable but can become available in the future.

Thanks.

-- 
tejun

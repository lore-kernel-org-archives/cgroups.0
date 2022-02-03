From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning
Date: Thu, 3 Feb 2022 06:06:24 -1000
Message-ID: <Yfv9gBps4FU7QgLz@slm.duckdns.org>
References: <20220203033103.773030-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Egk8ptnkjCf/i7Q94WgOkfmqeEgzwPogxM8QtrgBZYM=;
        b=WCquLTl47IgfLUUw0s5GBcjV6TNgPToIqQtfdlzNi5SiIdfzkOGCmId4jUQ6vC965+
         gqhh8aoHnYpa2MAwFLNMnUAJiUVo92O+2/95zawyzBPJgGeY/wUXT0FdJab5g7yZKsrp
         2ueB3eOJf1tQmxbDJYHn94zjBV52wbghhrlXZQuw84NR5hGHa7rKmxykwWI9dKPoK29+
         YTCnIDIMv7Cd6t9OqKmQ6X3Yt/gPnCAgu6I+gjnxC+iUugLLqw5+8GOXCAPZ+AdWJDOq
         xVeiLeSuqNhpl2PrDyiHHWQYxoyDp4VlH/GxSY/vYMJYnvF047ntdJqK1opMWEYigJtD
         sB4A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220203033103.773030-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 02, 2022 at 10:31:03PM -0500, Waiman Long wrote:
> It was found that a "suspicious RCU usage" lockdep warning was issued
> with the rcu_read_lock() call in update_sibling_cpumasks().  It is
> because the update_cpumasks_hier() function may sleep. So we have
> to release the RCU lock, call update_cpumasks_hier() and reacquire
> it afterward.
> 
> Also add a percpu_rwsem_assert_held() in update_sibling_cpumasks()
> instead of stating that in the comment.
> 
> Fixes: 4716909cc5c5 ("cpuset: Track cpusets that use parent's effective_cpus")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.17-fixes.

Thanks.

-- 
tejun

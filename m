From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH linux-next] cgroup: fix suspicious
 rcu_dereference_check() usage warning
Date: Wed, 9 Mar 2022 08:10:29 -1000
Message-ID: <YijtlXG1L0cS/3EL@slm.duckdns.org>
References: <20220305034103.57123-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gwB5ul7ug54L0VuMLgVdXhYXbW5z5+vlezaYRrDt3pk=;
        b=Smg69TaCEAFM4UcbwfjW0Sb6bBoNfiS3bSVBjeqfS1HLAUTS3+ZD9/kstjcPZT8jf+
         ZioEdEM9xhJe2i864YcvhkeqUmhixiqi17hg8awoiQv3+8GzIj/SqZR6beNw+7vdv76O
         UaToexqeCfRPh9+BzsOV5QGOXc/TXlN/bU9FJwH56V4zCpNmI7iuUH9+pqLA/UFy1zsm
         Hv9Ng+D4k/8Sf1gNC5WsxDWOj8FGbr6ad+LoxvumyjVE+6poyRSC7Hurq52udeFAQuP+
         oPWVKX9XM1mSnRnDmKfy+16Ja8HL17kw4cw7A7UlTMaCQuXAKHg98L4uQhZUrt8oOjcT
         hJSw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220305034103.57123-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, peterz@infradead.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Linux Kernel Functional Testing <lkft@linaro.org>, syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com, Zhouyi Zhou <zhouzhouyi@gmail.com>

On Sat, Mar 05, 2022 at 11:41:03AM +0800, Chengming Zhou wrote:
> task_css_set_check() will use rcu_dereference_check() to check for
> rcu_read_lock_held() on the read-side, which is not true after commit
> dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
> commit drop explicit rcu_read_lock(), change to RCU-sched read-side
> critical section. So fix the RCU warning by adding check for
> rcu_read_lock_sched_held().
> 
> Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Reported-by: syzbot+16e3f2c77e7c5a0113f9@syzkaller.appspotmail.com
> Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>  include/linux/cgroup.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1e356c222756..0d1ada8968d7 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -450,6 +450,7 @@ extern struct mutex cgroup_mutex;
>  extern spinlock_t css_set_lock;
>  #define task_css_set_check(task, __c)					\
>  	rcu_dereference_check((task)->cgroups,				\
> +		rcu_read_lock_sched_held() ||				\
>  		lockdep_is_held(&cgroup_mutex) ||			\
>  		lockdep_is_held(&css_set_lock) ||			\
>  		((task)->flags & PF_EXITING) || (__c))

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

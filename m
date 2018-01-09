From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 9 Jan 2018 05:44:48 -0800
Message-ID: <20180109134448.GE3668920@devbig577.frc2.facebook.com>
References: <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
 <20180109042016.GR9671@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eiJ/re04C3wDb2n6hXA3iAbqd3NkGxQm+mirVd5+yog=;
        b=dCKlt3PDYAmjw6M+f2YZ4Usowt3cs1ItMwosAgCZGvqwh9Yq3q5sH2ehUwLsu1sN5G
         r/iLl5kSP3GjObqTbjQw+gxs3ZjlO+LpCC9JPaX8d3W8BfdU8SLgmPfmki+dL3yGUQ6q
         Bq2w1cNxRdx35sReY3aoXxktRV/BgYNAQEBdc4jOuPQSn2ht2s4h2Uf+MmRNoIBcL+Uy
         6lWAXCNxRilKmCzrwkA+ta9t5VA4i/ADc4SNUjgVG0X9CSMMF1FQPWk27zCLWOVfvFFY
         QyBGTqS+UmBNAbRLeA9/Kc5v2tdKJhU1SQoEHQpMdGI13pdT5fj9Gu2UWEDMYdfHy4k9
         LL0g==
Content-Disposition: inline
In-Reply-To: <20180109042016.GR9671@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, Paul.

On Mon, Jan 08, 2018 at 08:20:16PM -0800, Paul E. McKenney wrote:
> OK, so I can put WQ_MEM_RECLAIM on the early boot creation of RCU's
> workqueue_struct as shown below, right?

Yes, this looks good to me.  Just one question.

> +struct workqueue_struct *rcu_gp_workqueue;
> +
>  void __init rcu_init(void)
>  {
>  	int cpu;
> @@ -4298,6 +4300,10 @@ void __init rcu_init(void)
>  		rcu_cpu_starting(cpu);
>  		rcutree_online_cpu(cpu);
>  	}
> +
> +	/* Create workqueue for expedited GPs and for Tree SRCU. */
> +	rcu_gp_workqueue = alloc_workqueue("rcu_gp", WQ_MEM_RECLAIM, 0);
> +	WARN_ON(!rcu_gp_workqueue);

The code was previously using both system_power_efficient_wq and
system_workqueue (for the expedited path).  I guess the options were
either using two workqueues or dropping POWER_EFFICIENT.  I have no
idea how big an impact this will make or whether it'd even be
noticeable but maybe it'd be worthwhile to mention that in the
description?

Thanks.

-- 
tejun

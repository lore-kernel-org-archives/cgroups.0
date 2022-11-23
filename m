From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] cgroup: remove rcu_read_lock()/rcu_read_unlock() in
 critical section of spin_lock_irq()
Date: Wed, 23 Nov 2022 07:17:20 -1000
Message-ID: <Y35VoCelSK7b8MOw@slm.duckdns.org>
References: <20221123144514.21178-1-tianran_trtr@163.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jBz/jPEo0AdygTb0AMG6NqgeBrl1ABCdg1oxZbrfO3k=;
        b=c0ud+PEDpPrVVxb2HtgXI/Cy/uAjLetHga7MsVSR0VVQeQKxY2YLimB9yXCvuNQvW3
         nOxOU2OgeEMc5K/bz9SnyvZ7wOZb3EA5ey7ks9SXpi6Fe59HZ70cZvIEOOOAGqMHU3kp
         yGUOQyDbVMW2DpjTANip8QhOCPxkvmjSqWINcfvOI7BPFwTUWrx2BI9XwYMi94BVH9cI
         IlgjkVE1J1mHPovoNjiUWlUlqkR1HKziHkr77ZZHgyLU+xeawTkeBmPgPWYuVRCGb3Sk
         eyGWY8qYCdrB6eppQNYpVRoXOVlpmYn2xwC4FzruO4qJ2UYAaVw+srAC+lqFDLNQIygw
         KUCw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221123144514.21178-1-tianran_trtr@163.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tianran_trtr@163.com
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, brauner@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

On Wed, Nov 23, 2022 at 10:45:14PM +0800, tianran_trtr@163.com wrote:
> From: Ran Tian <tianran_trtr@163.com>
> 
> spin_lock_irq() already disable preempt, so remove rcu_read_lock().
> 
> Signed-off-by: Ran Tian <tianran_trtr@163.com>

Applied to cgroup/for-6.2.

Thanks.

-- 
tejun

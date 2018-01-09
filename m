From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 9 Jan 2018 07:37:52 -0800
Message-ID: <20180109153752.GI3668920@devbig577.frc2.facebook.com>
References: <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <20180102174408.GM7829@linux.vnet.ibm.com>
 <20180102180119.GA1355@linux.vnet.ibm.com>
 <20180108122823.GL3668920@devbig577.frc2.facebook.com>
 <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
 <20180109042016.GR9671@linux.vnet.ibm.com>
 <20180109134448.GE3668920@devbig577.frc2.facebook.com>
 <20180109152112.GT9671@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z0k/ytaEmce44GZjz/Bvhg/RN6wShJMjhMBnBa7LjCU=;
        b=K3R7p1KQifbtyXIAdpzo3giKqa4lNq5jVCzVRDGPgO7EfsjoNJD2HJ+m+kiKEQoTjx
         Vc7ifgjeeVlTWtDmmihJ9U8zvb+6QnhA2Lwr8svtG3sNpAEO2O7aDnSVy3JsCMjHgjXD
         LPak5xvTueOt4wvNr57mEag0CGSsooU36UgcPMMHG3azoLgHCuochCaV0nFhZ3jlDVxQ
         k2wcxMssLrMwrw1lVdlxmKHvrLPCoWETcUEhhXYd6wJua3Om4icN2bKxl3gQckFe0uWZ
         ulWJM5zEeG5QpQgpY45uQdHswekR9uYBhb9eUzlHVoyFa/RyHAurIbfYByzdgE0G2y/4
         09WQ==
Content-Disposition: inline
In-Reply-To: <20180109152112.GT9671@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Prateek Sood <prsood@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, Paul.

On Tue, Jan 09, 2018 at 07:21:12AM -0800, Paul E. McKenney wrote:
> > The code was previously using both system_power_efficient_wq and
> > system_workqueue (for the expedited path).  I guess the options were
> > either using two workqueues or dropping POWER_EFFICIENT.  I have no
> > idea how big an impact this will make or whether it'd even be
> > noticeable but maybe it'd be worthwhile to mention that in the
> > description?
> 
> Good point!  How about if I change the last paragraph of the commit
> log to read as follows?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> This commit also causes SRCU to use this new RCU-specific
> workqueue_struct.  Note that SRCU's use of workqueues never blocks them
> waiting for readers, so this should be safe from a forward-progress
> viewpoint.  Note that this moves SRCU from system_power_efficient_wq
> to a normal workqueue.  In the unlikely event that this results in 
> measurable degradation, a separate power-efficient workqueue will be
> creates for SRCU.

Sounds good.  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

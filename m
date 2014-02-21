From: Tejun Heo <tj@kernel.org>
Subject: Re: [cgroup/task_lock] INFO: suspicious RCU usage.
Date: Fri, 21 Feb 2014 10:40:25 -0500
Message-ID: <20140221154025.GB460@htj.dyndns.org>
References: <20140221021622.GB13515@localhost>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jX2dsGiI+Se5saGCqFWKX1WU5JCULjNuWSO3A7rn8ug=;
        b=jtNdtVvsXZTSN+FeMjVtxfysikkfMK/p5cphs26InvgJwP6iVUoR563mu9KhYH9RE8
         kstmwoE1F/z6e5R6YKIFV1vCu9ZlLa8BqRGWmQXSN28HjAAmFQIQH/JLuaip/wxrgizE
         5HbyHNtU3nZTeZP0sjvlrCZEUYK7DKJja4qisX1t43QLf791A071YJOWjV24G4W5Wojs
         yMc/eFaUbomo2IXjU/CnxGDEIReTZ1CBrH5IQ8xBkF8YM7k47sk99tYT2jYTOazh6MdD
         dgX4x0tbubrGMNxdCIWo+HwXWRsQenVGW2faYHfqqujPkUe+RzArjFBy3t/4UfRh6JPP
         BcTA==
Content-Disposition: inline
In-Reply-To: <20140221021622.GB13515@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>

Hello,

On Fri, Feb 21, 2014 at 10:16:22AM +0800, Fengguang Wu wrote:
> commit fb47fea7a59cf3d6387c566084a6684b5005af83
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Thu Feb 13 15:16:35 2014 -0500
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Thu Feb 13 15:16:35 2014 -0500
> 
>     cgroup: drop task_lock() protection around task->cgroups
>     
>     For optimization, task_lock() is additionally used to protect
>     task->cgroups.  The optimization is pretty dubious as either
>     css_set_rwsem is grabbed anyway or PF_EXITING already protects
>     task->cgroups.  It adds only overhead and confusion at this point.
>     Let's drop task_[un]lock() and update comments accordingly.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> [main] Setsockopt(1 2b 80d1000 4) on fd 223 [17:2:768]
> [   27.030764] 
> [   27.031119] ===============================
> [   27.031833] [ INFO: suspicious RCU usage. ]
> [   27.032536] 3.14.0-rc3-02458-g837caba #2 Not tainted
> [   27.033378] -------------------------------
> [   27.044237] include/linux/cgroup.h:697 suspicious rcu_dereference_check() usage!
> [   27.045795] 
> [   27.045795] other info that might help us debug this:
> [   27.045795] 
> [   27.047114] 
> [   27.047114] rcu_scheduler_active = 1, debug_locks = 0
> [main] Setsockopt(1 c 80d1000 4) on fd 225 [39:5:0]
> [   27.048751] 2 locks held by trinity-c0/4479:
> [   27.049478]  #0:  (callback_mutex){+.+...}, at: [<81118395>] cpuset_cpus_allowed+0x1e/0x123
> [   27.051132]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<8111839c>] cpuset_cpus_allowed+0x25/0x123
> [   27.052788] 
> [   27.052788] stack backtrace:
> [   27.053528] CPU: 0 PID: 4479 Comm: trinity-c0 Not tainted 3.14.0-rc3-02458-g837caba #2
> [   27.064971]  00000000 00000000
>  919eff28 81877cc3[main] Setsockopt(1 7 80d1000 4) on fd 226 [1:5:1]

So, this is from removing task_lock from task_css_set_check() and
adding rcu_read_lock() in cpuset_cpus_allowed() should fix it.  I'm
not sure how much of task_lock() locking we currently have in cpuset
is actually necessary tho.  Shouldn't we be able to do most with just
callback_mutex, if not cpuset_mutex?  Li, any ideas?

Thanks.

-- 
tejun

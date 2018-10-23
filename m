From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] cgroup, netclassid: add a preemption point to
 write_classid
Date: Tue, 23 Oct 2018 12:58:48 -0700
Message-ID: <20181023195848.GC4182586@devbig004.ftw2.facebook.com>
References: <20181018085617.28456-1-mhocko@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gdSq9bF0nedG9Ber+aOH1to6mh30wA2VJb0a3wsWazw=;
        b=nqaiSjv40eEZfi2hLDuh+E0hMknzXjzR3nElOJYcdjE7GLcbrhJTsAXifLlqGi5Z/O
         WVfxCKSV2x4CfGZqUw7BQd6b8Kfk7PLQR5X9rNIno+SWjg91tBV/WyNJBcX+HuvLE5UZ
         SPUHkXstZtcE7UExcHviwr39MGKM2T8bZiXmITfFeLAVN2sOuHhR1M8CQjTyGmtIZWLS
         n5tqJpkw24cQMGg+g6ohFIi2Oz+zfe/spdwj4shrq8/ohevq9ecSBh4WUpDrlXFxTpo1
         eeUiGUTlrFVF/2wNFwmjQa7RvAkt6eYHIZpczABgZe7+e2gvrLGUaSo5RToGURIVBJ10
         ogbg==
Content-Disposition: inline
In-Reply-To: <20181018085617.28456-1-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

On Thu, Oct 18, 2018 at 10:56:17AM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> We have seen a customer complaining about soft lockups on !PREEMPT
> kernel config with 4.4 based kernel
...
> If a cgroup has many tasks with many open file descriptors then we would
> end up in a large loop without any rescheduling point throught the
> operation. Add cond_resched once per task.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Applied to cgroup/for-4.20.

Thanks.

-- 
tejun

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET REPOST for-4.15] cgroup, sched: cgroup2 interface for
 CPU controller (on basic acct)
Date: Fri, 29 Sep 2017 14:31:14 -0700
Message-ID: <20170929213113.GA3301751@devbig577.frc2.facebook.com>
References: <20170925160019.683562-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kAQCReZxPZr2v3BwgxdUDZHMAWQ03Jd4zOKTRLFn8ao=;
        b=UD1u538u5+O2oNpFx9DVRXsC3r66hw2LDuq7cntQ0ruOZzfukgUSAcUuhIuWoL793m
         hR8jojafcvqIHBXK7rvuEMcSrPXtlyeJBqO2hpxgl65dOsjLaVpZlSwLvMGbuCw+Ck+u
         ulUouLgycszH0hPD1o490kItbYuHp2ITQBB6ZUPJiqgempOhztwLG73OBa/telK2qhM6
         RYmouk4uBp1gTkz3yxyx1emyM9UuKKr+70ZFGymV+bN4o2F6KHW98HmgLElI0v8Jf9w2
         jC21pjZlT2NRDigF5Zp/cEDTHLrc6QqKRYULJT9mgMTVFoHSG9Alkkp9DLRaFNpr7qc9
         nx4Q==
Content-Disposition: inline
In-Reply-To: <20170925160019.683562-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com
Cc: longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Mon, Sep 25, 2017 at 09:00:17AM -0700, Tejun Heo wrote:
> Hello,
> 
> (Rebased on cgroup/for-4.15, no real changes.  Once acked, I think
>  it'd be easiest to route these through the cgroup branch;
>  alternatively, we can pull cgroup/for-4.15 to a sched branch and
>  apply these there.)
> 
> These are two patches to implement the cgroup2 CPU controller
> interface.  Changes from the last revision[L].

Applied to cgroup/for-4.15.

Thanks.

-- 
tejun

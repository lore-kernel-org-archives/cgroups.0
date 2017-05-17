From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Wed, 17 May 2017 17:47:18 -0400
Message-ID: <20170517214718.GH942@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rHFhjOunvtSv0aV+K6DTFHHLXvU4p/kxHh6l8au5QXs=;
        b=P7nzV+m0XxsBGehLVd80A3794myHPZ9uDna3URKkfs5dOli0GW8IGSBOiln/dRhr2f
         hkaRLZhGJL0osKtmygR3g6qMj/ewCmaaRMyF9D4hU/a51S9tmdQ3upkTAVhS29rV5KOc
         a2WAZHyhdEG2GYnF/jRrC9LhIVAq5mSP97aLMC4RwVT+laY8u9fFR6rX+qE3F3yra69A
         H5bu5gOhLB6BIl6RXrb5mwKymsJ6878zwnToPj3ix4xugSys1fx+/scIhzeC5WtgOtNW
         tdIypdKOpUqTwThx8VC+xgnSDtxPwdqMQnt9aCadBUk/PsPD8chFMhVx4dxvvBWWW8Sz
         vmZw==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-12-git-send-email-longman@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

On Mon, May 15, 2017 at 09:34:10AM -0400, Waiman Long wrote:
> The current thread mode semantics aren't sufficient to fully support
> threaded controllers like cpu. The main problem is that when thread
> mode is enabled at root (mainly for performance reason), all the
> non-threaded controllers cannot be supported at all.
> 
> To alleviate this problem, the roles of thread root and threaded
> cgroups are now further separated. Now thread mode can only be enabled
> on a non-root leaf cgroup whose parent will then become the thread
> root. All the descendants of a threaded cgroup will still need to be
> threaded. All the non-threaded resource will be accounted for in the
> thread root. Unlike the previous thread mode, however, a thread root
> can have non-threaded children where system resources like memory
> can be further split down the hierarchy.
> 
> Now we could have something like
> 
> 	R -- A -- B
> 	 \
> 	  T1 -- T2
> 
> where R is the thread root, A and B are non-threaded cgroups, T1 and
> T2 are threaded cgroups. The cgroups R, T1, T2 form a threaded subtree
> where all the non-threaded resources are accounted for in R.  The no
> internal process constraint does not apply in the threaded subtree.
> Non-threaded controllers need to properly handle the competition
> between internal processes and child cgroups at the thread root.
> 
> This model will be flexible enough to support the need of the threaded
> controllers.

I do like the approach and it does address the issue with requiring at
least one level of nesting for the thread mode to be used with other
controllers.  I need to think a bit more about it and mull over what
Peterz was suggesting in the old thread.  I'll get back to you soon
but I'd really prefer this and the earlier related patches to be in
its own patchset so that we aren't dealing with different things at
the same time.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

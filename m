From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET REPOST for-4.15] cgroup, sched: cgroup2 interface for
 CPU controller (on basic acct)
Date: Fri, 29 Sep 2017 20:29:25 +0200
Message-ID: <20170929182925.GW6524@worktop.programming.kicks-ass.net>
References: <20170925160019.683562-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=28MogGizIUhnP7OeySNRGmr07Y+aXcuYSXt8a0d5K6w=; b=kwyFZNRCjuT1g/nu3vCOhJi9T
        K37PhgrR9vQhD5C6h4dNyXPkJWqMvlKdtWN1h07YvZYYragW80RfFW7boalRUy25cEFFbRO0OXxgE
        2VU1+6mfYo9QY4iO9yojK1ITbTK8TQcI2j0XglkxHAvAMVhAEMFf4mRSC9EPmEW5GDqVqnpMACFq2
        VrWFpTUmH3CSEJxC9qOm6pbL8y4v1dS1a1m5FlLK4qjChTf89f6KyXFumyIGHUUyT5Egn79zMxjza
        TCtn/QC196X6VwsYRMp//nixegN1BbzwIZQgLQ/RCGbE5MvR5cOPPk0LgF0NvtxXdJ0dyL/wPP2K2
      
Content-Disposition: inline
In-Reply-To: <20170925160019.683562-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

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
> 
> * Updated on top of the cgroup2 basic resource accounting patchset[B]
>   and now uses cgroup2's CPU accounting instead of cpuacct as stat
>   source.
> 
> * cpuacct is no longer necessary and not converted.
> 
> This patchset contains the following two patches.
> 
>  0001-sched-Misc-preps-for-cgroup-unified-hierarchy-interf.patch
>  0002-sched-Implement-interface-for-cgroup-unified-hierarc.patch
> 
> It's on top of the cgroup2 basic resource accounting patchset, which
> has been merged to cgroup/for-4.15, and available in the following git
> branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-cpu-on-basic-acct
> 
> diffstat follows.  Thanks.
> 
>  Documentation/cgroup-v2.txt |   36 ++------
>  kernel/sched/core.c         |  179 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 187 insertions(+), 28 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

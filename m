From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Sat, 10 Mar 2018 14:16:47 +0100
Message-ID: <20180310131647.GB4043@hirez.programming.kicks-ass.net>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
 <20180309221736.GB5926@hirez.programming.kicks-ass.net>
 <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yD3G8mTXjU0b7ycsLVYnXALPUmH4/XVvwugFZ6Ka4CA=; b=Xm5mbCmhuJ0JZmJYyE3TGxHGN
        ZuOnRbgemhy6gMshHekJ1zEKA5wYOh2UmaY/ZQKcTUjM3nsAeE0mT03cWAnQ8SduEUnsk2KqaZaYK
        bx0vXlz8FO85h0fvfZ9/s+cl7BQH58Bv0tFvD93Qk/eHBp4mknpiunIrTFu9gUr2bSZ6ts9JjSzSC
        R/d7yIzsW0ajdQ60faBXRtc/rrNXIAByxtQXDM2QpmgF0dc6jIpVXkieor5ccdufhVNLi7wgq03xK
        7oIfvthSXfp0++3F/INfOL08uBF45tFOW0PgeKSR+yCB1+bzh/sPP0l+6LlbP/wvTyk66D14gzK1U
    
Content-Disposition: inline
In-Reply-To: <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Fri, Mar 09, 2018 at 06:06:29PM -0500, Waiman Long wrote:
> So you are talking about sched_relax_domain_level and

That one I wouldn't be sad to see the back of.

> sched_load_balance.

This one, that's critical. And this is the perfect time to try and fix
the whole isolcpus issue.

The primary issue is that to make equivalent functionality available
through cpuset, we need to basically start all tasks outside the root
group.

The equivalent of isolcpus=xxx is a cgroup setup like:

        root
	/  \
  system    other

Where other has the @xxx cpus and system the remainder and
root.sched_load_balance = 0.

Back before cgroups (and the new workqueue stuff), we could've started
everything in the !root group, no worry. But now that doesn't work,
because a bunch of controllers can't deal with that and everything
cgroup expects the cgroupfs to be empty on boot.

It's one of my biggest regrets that I didn't 'fix' this before cgroups
came along.

> I have not removed any bits. I just haven't exposed
> them yet. It does seem like these 2 control knobs are useful from the
> scheduling perspective. Do we also need cpu_exclusive or just the two
> sched control knobs are enough?

I always forget if we need exclusive for load_balance to work; I'll
peruse the document/code.

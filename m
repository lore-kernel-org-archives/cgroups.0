From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 11:50:55 -1000
Message-ID: <Y9wwP4LF9vgreO3U@slm.duckdns.org>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
 <d630ca53-71f0-c735-fbc3-e826479aa86b@redhat.com>
 <Y9wSC1Wxlm8CKKlN@hirez.programming.kicks-ass.net>
 <2bc730db-704d-080b-6869-02f6d0035fad@redhat.com>
 <Y9whrU4IUeleqdrt@slm.duckdns.org>
 <75de91db-d3bc-0c0e-6199-ef00591e8878@redhat.com>
 <8787b5f7-9822-e49b-0357-d0ce224ca920@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lyvgXXfLdb8BqZbi4tqxl6AzdTG+8pKKl4n84qa8mHw=;
        b=FLARCyjXgCWruhv8HxY2D5u3alu0rFNTa28H7ltJbldeBu+27e3g7SsbgllMXeH6wc
         IchjL6Q5AgVhtRULvKVvTSdrhps+qiuYSVxaw7Ph9ZiKz7rTLwcR9lvtCtQiTaUEecnr
         BhpWtyT24fdu0gq7RUEn2DfHm/BR3zfVa2fs+WOUa9JeTTG7H9IlAbp1IBcnyYpv42xz
         tcddBjqKwnNaTZTaiedcXvaZwKWG3VhVBNi601iKp72PEot/UPog3ESgRLSBl2Dxyp+o
         fS+QRYK1upK+Ixt60oiHU+Ax5uR2vMb+G7pMO3yqreEVMZahc0/jqs+Xyu7rglFu3Uo1
         BNRg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8787b5f7-9822-e49b-0357-d0ce224ca920-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 02, 2023 at 04:05:14PM -0500, Waiman Long wrote:
> 
> On 2/2/23 15:53, Waiman Long wrote:
> > 
> > On 2/2/23 15:48, Tejun Heo wrote:
> > > On Thu, Feb 02, 2023 at 03:46:02PM -0500, Waiman Long wrote:
> > > > > > I will work on a patchset to do that as a counter offer.
> > > > > We will need a small and simple patch for /urgent, or I will need to
> > > > > revert all your patches -- your call.
> > > > > 
> > > > > I also don't tihnk you fully appreciate the ramifications of
> > > > > task_cpu_possible_mask(), cpuset currently gets that quite wrong.
> > > > OK, I don't realize the urgency of that. If it is that urgent, I
> > > > will have
> > > > no objection to get it in for now. We can improve it later on.
> > > > So are you
> > > > planning to get it into the current 6.2 rc or 6.3?
> > > > 
> > > > Tejun, are you OK with that as you are the cgroup maintainer?
> > > Yeah, gotta fix the regression but is there currently a solution
> > > which fixes
> > > the regression but doesn't further break other stuff?
> > 
> > I believe there is a better way to do that, but it will need more time
> > to flex out. Since cpuset_cpus_allowed() is only used by
> > kernel/sched/core.c, Peter will be responsible if it somehow breaks
> > other stuff.
> 
> Maybe my cpuset patch that don't update task's cpumask on cpu offline event
> can help. However, I don't know the exact scenario where the regression
> happen, so it may not.

Neither patch looks like they would break anything. That said, the patches
aren't trivial and we're really close to the merge window, so I'd really
appreciate if you can take a look and test a bit before we send these
Linus's way. We can replace it with a better solution afterwards.

Thanks.

-- 
tejun

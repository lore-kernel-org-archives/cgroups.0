From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Date: Fri, 27 Apr 2012 08:45:02 -0700
Message-ID: <20120427154502.GM27486@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dpdxSLyXr+N25OO6v2DhAwULQ4aS4/yOtChEeWXGU2k=;
        b=hY2yLffJQyYlGJ/C9ON3nzV/ln4dUDScPUfi375q+d8GOYWW7aIQKq/AqwJi2WajSn
         7oun2tuc6FUYawDmiPIsISY4X4UPvxvwvNuNOe4KrSgEm6UXV8DOHAmsEy/qJ2/6DhPj
         5ZhoY5L+O7Tw5oNXpv7jI+PQKT3qRXVDmq/sdO07ro8yB4qZJ41oE+ZdQsd1fNAeXp6q
         IbtlfJG9Vo/SKLlHGnAuq1YqUZQivkCMxsg6ZWODkfoFZRajmOWtPeh9oLTkGFcNLg9w
         lhBMnMr7e3MEyW8VoRLZdGqEr39jJ13bV01JPSrdTJ8gKOOm3gsQxqsakY4PSv7Kjo7m
         R7Eg==
Content-Disposition: inline
In-Reply-To: <20120427154033.GJ10579-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Fri, Apr 27, 2012 at 11:40:34AM -0400, Vivek Goyal wrote:
> On Fri, Apr 27, 2012 at 08:02:17AM -0700, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Apr 27, 2012 at 10:54:01AM -0400, Jeff Moyer wrote:
> > > > This patch implements per-blkg request_list.  Each blkg has its own
> > > > request_list and any IO allocates its request from the matching blkg
> > > > making blkcgs completely isolated in terms of request allocation.
> > > 
> > > So, nr_requests is now actually nr_requests * # of blk cgroups.  Is that
> > > right?  Are you at all concerned about the amount of memory that can be
> > > tied up as the number of cgroups increases?
> > 
> > Yeah, I thought about it and I don't think there's a single good
> > solution here.  The other extreme would be splitting nr_requests by
> > the number of cgroups but that seems even worse - each cgroup should
> > be able to hit maximum throughput.  Given that a lot of workloads tend
> > to regulate themselves before hitting nr_requests, I think it's best
> > to leave it as-is and treat each cgroup as having separate channel for
> > now.  It's a configurable parameter after all.
> 
> So on a slow device a malicious application can easily create thousands
> of group, queue up tons of IO and create unreclaimable memory easily?
> Sounds little scary. 

Malicious application may just jack up nr_requests.

Thanks.

-- 
tejun

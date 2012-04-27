From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Date: Fri, 27 Apr 2012 10:25:19 -0700
Message-ID: <20120427172519.GB26595@google.com>
References: <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
 <20120427155140.GN27486@google.com>
 <20120427155612.GK10579@redhat.com>
 <20120427162012.GP27486@google.com>
 <20120427172110.GM10579@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qbI/DFThB4jpgPsnhDq/9L2G6BrBGg6TVkyaUimKswg=;
        b=Y48v5IUVTDLogAJ7NBsPKSzmShDKfmhtwgf2E2jfDCz8nzA/njLtvqtUPPvo9ljkl8
         eliRIkqhVcFqXX+/UfdORmG0w9d9pyihAd5tYXoydIsucAfsos1m1YnA+fLyyPmrusWc
         Y5dAUuLHW9wjd/T9094a0diKrtnsAp4eTZd8xHy9Wl1pEuEk3JLnUzoj+IjFS0nav1KN
         Y6i39f1N1I8KvCLYZD54Nd6vNr1ylgJ0/7Lrs8INZeY6eNl/HtdtMOOjg2ttp94tfq4c
         64QcAf/ckrTqoR0ujstt+kLanVl3RjY6XsfvW/9086ef61ORxnTLNo23Nb7g6EoHoy8C
         /XPA==
Content-Disposition: inline
In-Reply-To: <20120427172110.GM10579-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Apr 27, 2012 at 01:21:10PM -0400, Vivek Goyal wrote:
> For non-priviliged users, something along the lines of per session
> cpu autogroup might make sense.  But even then if some IO is submitted
> from that autoblkgroup, kernel can't claim that memory till IO is
> completed.
> 
> So per cgroup number of request will probably be a problem even if
> kenrel managed those completely.

My point was that trying to solve all the policy decisions in kernel
proper is not a very good idea.

> So are you planning to put a patch in kernel to disallow cgroup creation
> for non-priviliged users?

No, I'm not gonna break the current users.  It's just not the
direction I want to take cgroup towards and the current breakages will
remain broken.

Thanks.

-- 
tejun

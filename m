From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v14 4/4] cgroup: implement the PIDs subsystem
Date: Tue, 14 Jul 2015 17:31:48 -0400
Message-ID: <20150714213148.GD2273@mtj.duckdns.org>
References: <1433849530-22845-1-git-send-email-cyphar@cyphar.com>
 <1433849530-22845-5-git-send-email-cyphar@cyphar.com>
 <20150610045304.GJ11955@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=N2U6XGD7OLU1oN+ubAsHZE+GJY0j3MvKFEr+p3RyvvE=;
        b=YHqWsQFwfWActMaTP1tWR4QFKjTPDTdNJkRNXTGjYGbqr9MibKunEMVTrO2+MPcmDl
         ccugsjDZIpoNhnJsIMJwIaabV8MpQiaQbVDlIFsmVaznTiOc5ijHVBS+5UEQFlEZ8jkc
         mZY9V5XeLbTgDIVsvOGnsfxE1rXtX12pjoaJmuCN4jMyVn0Lz2I9NCK+rscZ24cQWfwU
         US6rZiDMkAx1NzP4VAczg24oU5MtvUfFEvSE13X+5C4BnVCVN7BvUwkhptC9iPPtyMRq
         6+Gvy6Oc3tR/K4T/bcISbmDA+0y0W5TRyperKcpCdc//DRSXZfWOd6HLQl1JTBIZvn4t
         tUNw==
Content-Disposition: inline
In-Reply-To: <20150610045304.GJ11955-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 10, 2015 at 01:53:04PM +0900, Tejun Heo wrote:
> On Tue, Jun 09, 2015 at 09:32:10PM +1000, Aleksa Sarai wrote:
> > Adds a new single-purpose PIDs subsystem to limit the number of
> > tasks that can be forked inside a cgroup. Essentially this is an
> > implementation of RLIMIT_NPROC that applies to a cgroup rather than a
> > process tree.
> > 
> > However, it should be noted that organisational operations (adding and
> > removing tasks from a PIDs hierarchy) will *not* be prevented. Rather,
> > the number of tasks in the hierarchy cannot exceed the limit through
> > forking. This is due to the fact that, in the unified hierarchy, attach
> > cannot fail (and it is not possible for a task to overcome its PIDs
> > cgroup policy limit by attaching to a child cgroup -- even if migrating
> > mid-fork it must be able to fork in the parent first).
> > 
> > PIDs are fundamentally a global resource, and it is possible to reach
> > PID exhaustion inside a cgroup without hitting any reasonable kmemcg
> > policy. Once you've hit PID exhaustion, you're only in a marginally
> > better state than OOM. This subsystem allows PID exhaustion inside a
> > cgroup to be prevented.
> 
> Patches 3-4 look good to me.  Will apply once v4.3 dev window opens.

Applied 3-4 to cgroup/for-4.3.

Thanks.

-- 
tejun

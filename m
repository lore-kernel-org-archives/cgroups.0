From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cfq-iosched: remove @gfp_mask from
 cfq_find_alloc_queue()
Date: Tue, 9 Jun 2015 12:01:47 +0900
Message-ID: <20150609030147.GK21465@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-6-git-send-email-tj@kernel.org>
 <x498ubuhulf.fsf@segfault.boston.devel.redhat.com>
 <x49sia2gd41.fsf@segfault.boston.devel.redhat.com>
 <20150608211930.GA20918@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uwyrr7sv+7LbrKnU8HkQY72oVsIlM2w+E8WfjfX9sdc=;
        b=MQ9YNZIQd6lYeVScZlqcbA+2eCSCQucZe/23EgV/XGW7hEzy/tYoqJzaneikrVja2U
         tqwU3ElnfjCGEijwCUiMLVOgJ4KjnPbCIIpEGVdD4yLhn3zZwkwwYFTT+9pZo1FtkoYB
         Q+q+6pmORl9G1DZFSdpCs7rJ1DLTI9XXbyW5O+GS2fyQW9xGsAuPlA/pz2WeT0his8IZ
         ExGaMZchWEs6Us7/3nqEN2FSUXTIyTH7N98sUIjp1fMo89RvO3epWE/zJ6pBOhLFnw2r
         DFDb2hsxXO7GvbaUi679BOlAh8rz+Gdy5qxNj8L0ZSmzo5QL4waHcKbIMnU7wz6SL6cs
         4xNg==
Content-Disposition: inline
In-Reply-To: <20150608211930.GA20918-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Jun 08, 2015 at 05:19:30PM -0400, Vivek Goyal wrote:
> Whatever we end up using, may be it is a good idea to use same policy
> for block group allocation too. Right now we use GFP_ATOMIC for blkcg
> allocation.
> 
> So this will be equivalent of that when memory is low, we don't provide
> service differentiation.

Yeap, I'll add a patch to convert all optional allocations to
GFP_NOWAIT.

Thanks.

-- 
tejun

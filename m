From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup kernel API question
Date: Thu, 4 Aug 2016 15:01:30 -0400
Message-ID: <20160804190130.GA9516@htj.duckdns.org>
References: <CF4362088901AA4FAA2113B97CB826F0197B26CB@SUSHDC8002.TD.TERADATA.COM>
 <20160804143446.GA4748@htj.duckdns.org>
 <CF4362088901AA4FAA2113B97CB826F0197B2F76@SUSHDC8002.TD.TERADATA.COM>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tBWv44dRCsLSodra5ZgjA1u9W2GF3bZwtQdE6hl0LiU=;
        b=R12/fwUTt6BPtW4LWVQSav/j+UjQ5zv/ExxCTG22Cm6dCIZdr4Z5uQ8FIXtIJOOumG
         Im7Eishmu/PQF9/DcXnrxsD4Nqx3C73oiZgdNBfdiYMfH5wPsdiceUllLULZOrsLml0j
         bqGOtEu37NnlwwuT63nRioMKbSpN7q8L+DogzonZbv7QamNkPx2ob/aLOvT/kYjGNuHI
         1jlRKRtHc3GTQCZuZESu/KrC9i9+P1BOtltw7avGHXNqM/ZceiJiYz8kx2v9/1V1T2kL
         PQIO/JGyA2Rw1/XIkRkh5AVRoBiTndFVrZ72QmQ/d/yt40q2khQZatQc3lqjkLuJQNsE
         hDCw==
Content-Disposition: inline
In-Reply-To: <CF4362088901AA4FAA2113B97CB826F0197B2F76-LMkq1lB6rBEUEZHej5tRBl+mfx6fdgmEV6yJEvX+wlw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Joshi, Venu" <Venu.Joshi-Iz5qeGvAONRWk0Htik3J/w@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Aug 04, 2016 at 05:58:42PM +0000, Joshi, Venu wrote:
> Our database server creates a sub directory (say TeradataCgroup)
> under the root cgroup and manages all processes/tasks and ensures
> proper synchronization across multiple accessors.  These

Your application may be doing that but what's preventing userland from
being in the middle of racing cgroup operations?  This may work for a
particular setup but given the current interface it's difficult to
expose something like this as a part of general API.

> processes/tasks may create further sub-directories under
> /root-cgroup/TeradataCgroup/ with different cpu.share values.  The
> tasks constantly migrate to different cgroups at different
> hierarchical levels based on the priority of the user

This isn't a particularly good way to use cgroup because migrations
are expensive and possibly high-latency operations.  It often is that
there are trade-offs between migration overhead and hot path overhead
and obviously lowering hot path overhead takes precedence.  Another
factor is that some resources are stateful and migrating don't migrate
the existing charges messing up accounting.  From cgroup's pov, it'd
be better to have a per-cgroup workerpool and dispatching jobs to them
accordingly.

> SQL/query/request.  All this happens when the tasks have trapped
> into the kernel mode via a syscall.
> 
> Our Teradata Database server is a highly parallel application and
> uses kernel mode synchronization APIs (spinlocks etc.,) via a kernel
> mode driver extension to achieve synchronization.  Hence we mostly
> try to use Kernel API for key operations.  In our application,
> cgroup operations are never done in userland to avoid the problem
> you mentioned below (severely confusing userland that is trying to
> use the cgroups too).

I'm not sure how performing operations from kernel improves the
situation tho.

Thanks.

-- 
tejun

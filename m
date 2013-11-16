From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.10.16 cgroup css_set_lock deadlock
Date: Sat, 16 Nov 2013 14:18:54 +0900
Message-ID: <20131116051854.GB5618@mtj.dyndns.org>
References: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115081929.GA11530@mtj.dyndns.org>
 <5286355A.9060509@hp.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wu7yIRD+RIY3TcVNVdN35YNL706qNkCZrOgtvJE0ffQ=;
        b=Mxsu8gZQX1OkStX97LCVer0PcJtDeLBvVXEysycu00Ole0nwgup1xSeC2hmpwB8Q/O
         CqtVA3N/1WIHYsfTbQO++pohsQjLC5kYg1JDh6DzeiaZAlntdVCMI8GAxcRlE6K5MwOs
         yZBteEzxAddR1HDdCsOp2jA4IXuIW+zI5zt11T0JAn6YUDOHHHO6ZS59R/3PvEL+NvWm
         9oKmR9VzcdmQMfTfjJh+Y7WHvqHz1S4ItqI3girS1pq8M9JO2kJwMXuTV7pkLDrnu/k5
         50EgOcTUpglbw52q26RUpSSwKBhFpB94VI5QVhb+DZ+7AXJBqezzO0gX/Xtr5Ix9TaEZ
         gYQw==
Content-Disposition: inline
In-Reply-To: <5286355A.9060509-VXdhtT5mjnY@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Don Morris <don.morris-VXdhtT5mjnY@public.gmane.org>
Cc: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

Hello,

On Fri, Nov 15, 2013 at 09:53:14AM -0500, Don Morris wrote:
> Are we getting some other thread from while_each_task()
> repeatedly keeping us in the loop? Or is there something
> else going on? The gut instinct is that calling something
> like while_each_task() on an exiting thread would either
> reliably give other threads in the group or quit [if the
> thread is the only one left in the group or if an exiting
> thread is no longer part of the group], but since that would
> make the continue work, obviously I'm missing something.

Thread group leaders are stable at that point because threadgroup_lock
is held and are guaranteed to show up in while_each_thread traversal;
however, !leaders may already be in the process of exiting by the time
control reaches that point and may not show up in the iteration.  As
RCU lock is held, it'll be *safe* to initiate or continue iteration
from it but when the iteration comes around, there's no guarantee that
it'll be included in it and the term condition depends on it showing
up again.  That's what I remember anyway.  Li, please correct me if
I'm mistaken.

Thanks.

-- 
tejun

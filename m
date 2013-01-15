From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't show pid list on tasks/procs in ascending
 order
Date: Tue, 15 Jan 2013 07:43:32 -0800
Message-ID: <20130115154332.GA2598@htj.dyndns.org>
References: <50F4E902.20202@oracle.com>
 <20130115062507.GA21358@sergelap>
 <50F4F76D.2050409@oracle.com>
 <20130115063412.GA25338@sergelap>
 <50F4FD99.7070406@oracle.com>
 <20130115140811.GA4082@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=z0tAVWcMqVOMyPprYDxj7qRQHL5cj6L/4/FrNTKLp7I=;
        b=V9T1P0fDyiovEMN4J5YvnIwLDU7CG59J0k797f4caTYqvNGRqvc+mZA6WaE/SQxw1k
         2i4WP/cD7Z30N2q0W2o+8g1ssoi0wlvD8zCm1do/So/UwDCkqUUSHQHop2Y5C2nHVFpV
         tFXai3QXjZPi466Fch2no+6aUNh+O8vaGGjg8SPVkV36gbVTijiZiy7+C/eAblyFc+DD
         WJQ4xmtWPfKGez4LU3oojEKQs0R0TYvYQLOiYXG9zcd5xTob1o0KuWaRp2+ST/3TYEvs
         1qbiE4b0EKnas3ISDI7Yii4gMnSJkMgimwleFOjNADHdDxyM4UX5lMXxHwvQVXhMwMnq
         1aRw==
Content-Disposition: inline
In-Reply-To: <20130115140811.GA4082@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, guys.

On Tue, Jan 15, 2013 at 08:08:11AM -0600, Serge Hallyn wrote:
> > I did this for two reasons, one is for the documents, another is per
> > Cgroup TODO list from Tejun -- https://lkml.org/lkml/2012/9/13/542
> > 
> > . Misc issues
> > 
> >   * Sort & unique when listing tasks.  Even the documentation says it
> >     doesn't happen but we have a good hunk of code doing it in
> >     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
> >     don't like it, scream.
> 
> Yeah, I figured, and since he also wants to move to a place where
> cgroups are always manipulated using a library, not by hand, it
> would make sense to get rid of the overhead there.  I just don't
> really like either one of those :)  And in the list of things to
> clean up in cgroups, this seems like one that can wait.

I want it gone but last time I pinged there were some people depending
on it, so I don't think I can.  I think we'll have to put it on ice
for now at least.  :(

Thanks.

-- 
tejun

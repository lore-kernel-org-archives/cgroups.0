From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Wed, 4 Sep 2013 12:07:23 -0400
Message-ID: <20130904160723.GC26609@mtj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=b9TUS58mmgOw1fwrpbLTtfT0bcZHMxolbopMFPaI+2Y=;
        b=Ww2ZH9wmHUDtv0+ZAiYWywh3Sm3U6YOQ32+HN96il7ktcmcuEepDLbfGjDoQ8L9VUP
         GuLGgM9nUvqp6k32nVL4cZ2XkRzdRQ804s1qVeVbPdsm4rbLpOTjQhm1uSIeX0IGP3Yo
         xMuLSzUV5R/5+k1Oz1NC0elo6rf/BAE3SWurlHCKSaQR+aezwe8VOojo+pllv1Zdjigb
         AadX0wUvXdgDZ8hJl1BMvMHbiqesiI/toD6BF12sxefALf9a5rzSDk6wGaJR//BORIc2
         HwySC4L6LqJ6YdGMjYQmBlwcnYZDS0akcLH3yNWjL07NfgRno7Uuyvf5el81musf1R9a
         DAMw==
Content-Disposition: inline
In-Reply-To: <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello,

On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
> I am not an expect in block code, so I have a few questions here:
> 
> - are we sure that this operation is atomic? What if blkg->q becomes
> dead right after we checked it, and blkg->q->queue_lock got invalid so
> we have the same crash as before?

request_queue lock switching is something inherently broken in block
layer.  It's unsalvageable.  Maybe we can drop lock switching once
blk-mq is fully merged.

> - do we need to check blk_queue_dying() in every single place where we
> iterate over blkcg->blkg_list?
> 
> - would it be better to remove block cgroup from blkcg->blkg_list
> before queue marked as dead?

I have no idea.  No matter what we do, it's working around something
fundamentally broken in a half-assed way.  Hmmm... there was an effort
to remove the lock switching.  I don't think it actually happened
tho. :(

Thanks.

-- 
tejun

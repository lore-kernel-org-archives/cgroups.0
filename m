From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Date: Wed, 18 Jun 2014 21:46:00 -0400
Message-ID: <20140619014600.GA20100@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ia98EJ5yy8msm18C/7Sv1NxMI+soVgIRXp48ULoq1jQ=;
        b=pTs6g5peDQouBWh2dg+IigjBqbwc2gj5+0uhDN3csZP/tPnlqhYXTUz0DlBacK6iOJ
         rg9P9rkDNFo6jIREwsrbPz02xHJs0vJiozWBA/M5pFKCDEEkaT2+auqHHYakwrMWCsc+
         eXK7oyJ4sIcNIJkv9f+gzeeIsYstdJ5fMcNmDHg40vSxoc9rYMGDL0B5DFbGj+aLmqzK
         iW1sBhZd1210nPa8O5+QgJG7wiQKIRVVR8Omw86jPaMXRrPv6oIVYXAEMu+D3kdLd8JM
         iD7M6g1qE8Is0d+D+AqW+oocLrkQLIND9py+8wgbyTmXxOZME8U61I3oTpvetcta7sXh
         6eLg==
Content-Disposition: inline
In-Reply-To: <0A5218F8-0215-4B4F-959B-EE5AAEFC164A-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jun 17, 2014 at 05:55:57PM +0200, Paolo Valente wrote:
> In general, with both a smooth but messy and a sharp but clean
> transformation, there seems to be the following common problems:
>
> 1) The main benefits highlighted by Jens, i.e., being able to move
> back and forth and easily understand what works and what does not,
> seem to be lost, because, with both solutions, intermediate versions
> would likely have a worse performance than the current version of
> cfq.

So, the perfectly smooth and performant transformation is possible,
it'd be great, but I don't really think that'd be the case.  My
opinion is that if the infrastructure pieces can be mostly maintained
while making logical gradual steps it should be fine.  ie. pick
whatever strategy which seems executable, chop down the pieces which
get in the way (ie. tear down all the cfq heuristics if you have to),
transform the base and then build things on top again.  Ensuring that
each step is logical and keeps working should give us enough safety
net, IMO.

Jens, what do you think?

> 2) bfq, on one side, does not export some of the sysfs parameters of
> cfq, such as slice_sync, and, on the other side, uses other common
> parameters in a different way. For example, bfq turns I/O priorities
> into throughput shares in a different way than cfq does. As a
> consequence, existing configurations may break or behave in
> unexpected ways.

This is why I hate exposing internal knobs without layering proper
semantic interpretation on top.  It ends up creating unnecessary
lock-in effect too often just to serve some esoteric cases which
aren't all that useful.  For knobs which don't make any sense for the
new scheduler, the appropriate thing to do would be just making them
noop and generate a warning message when it's written to.

As for behavior change for existing users, any change to scheduler
does that.  I don't think it's practical to avoid any changes for that
reason.  I think there already is a pretty solid platform to base
things on and the way forward is making the changes and iterating as
testing goes on and issues get reported.

Thanks.

-- 
tejun

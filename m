From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups
 statistics
Date: Wed, 26 Jun 2013 18:23:47 -0700
Message-ID: <20130627012347.GH4536@htj.dyndns.org>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
 <20130626204540.GA4536@htj.dyndns.org>
 <20130626210820.GA17564@redhat.com>
 <CAOS58YP_Umud2DTY+3tc4m02FywGNOEALSN1An4OLXczcmsQ4Q@mail.gmail.com>
 <CAOMFOmVqevNSKgWR5keT8u7vsCRpHhYROejM6OucyNeeA6j6zQ@mail.gmail.com>
 <20130627012304.GG4536@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GcIA8hGkPBi4NTj2e/Pk7jF+5FJiHuvOWda8JvYV8yg=;
        b=uWVF0umlj7EstGCwm/+X6FoFTDvgUz7FojkU0/aYZ7fFKE6iTLdTNv3sWZzOa1xdWn
         dvUaN43MFcsmqqmukiUV68DEA3ip4yBCxcn2/FZUkg3mBEqJ/oAnkkcIg5kBBkGKYaOJ
         S0mOoE0AILa7RwiIUK891Dsv8qeNHanaTcZ2RLoLrTaRwRfRJ6Ai0aHFTH2QSRHeC+J7
         2qBtkFMpTpISovTKDh6uhiuFgUE3hODzLaQdR07ywvHwThHIiYWP6iOpsIq4vtTjElGV
         SVfqvC2eCqjyvVp8YaeXjuUP8vBDzxG7UzKklUAoUZXa7jCvoVGAVJ5dVbVoglQkAdBS
         gKCQ==
Content-Disposition: inline
In-Reply-To: <20130627012304.GG4536-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

On Wed, Jun 26, 2013 at 06:23:04PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 26, 2013 at 05:37:38PM -0700, Anatol Pomozov wrote:
> > Bottom line: when we set weight for a device then it creates cfq_group
> > and initializes device stats with zero. Later that zero stat is shown
> > even if no activity happened on the device. Both CFQ and our custom IO
> > scheduler have this problem. And because we write set weight for all
> > devices in all cgroups we endup with a lot of zero useless stats.
> > 
> > What is the right fix in this situation?
> 
> Yeah, I think yours is fine.  You're just configuring each blkg during
> init.  Please just update the u64 case and repost.

BTW, if there are a lot of users which ignore 0 u64, it may be cleaner
to introduce a wrapper around the existing prfill.

Thanks.

-- 
tejun

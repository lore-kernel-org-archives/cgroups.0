From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 10:46:08 -0400
Message-ID: <20160405144608.GD7822@mtj.duckdns.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
 <20160405012504.GG24661@htj.duckdns.org>
 <CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
 <20160405140107.GB7822@mtj.duckdns.org>
 <CAG53R5V=-sRacw7kX-UhjRmr+LS3HF4u8yfQF16utAxo-YHnMw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TZQDjhq7S4u5BJyaTYHyutEGHks5E2J3j0mKyTEelh8=;
        b=0ybG2EAn1T93qy93EXoCuVTwKWjZa1Mlfmio9HiuZerQ4pX5/9OMsKWUIRtzm8DEwJ
         OgSjpKwmslTFvOkYLJE+YIXDlJpBXllLaQzLGSQa8TrxcSJOsL4ogkHxRHla7CZ3FWST
         zAUA3MihYKe14BPuAUTdCxifbaxnvRxlzo8M9omj+X4Y3/D2sc0P2b7PuSypaBjOaIHo
         NNaJYZGLTKZmADxsJtnAEFiDtmDbLb9F8JRvr18lm1E/J9OcCVveHnxe+pGU1UWWkaJn
         /33bYrVvodWs3D7vV8S7JcOJcB4Fa3NlFY5a6b4tMWqfuNwCsMKfo95W4b6nddVGudVu
         pHZg==
Content-Disposition: inline
In-Reply-To: <CAG53R5V=-sRacw7kX-UhjRmr+LS3HF4u8yfQF16utAxo-YHnMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Tue, Apr 05, 2016 at 07:25:11AM -0700, Parav Pandit wrote:
> > As it is a fairly isolated domain, to certain extent, it could be okay
> > to let it go.  At the same time, I know that these enterprise things
> > tend to go completely wayward and am worried about individual drivers
> > going crazy with custom attributes in a non-sensical way.
> 
> If its crazy at driver level, I am sure it will be equally crazy for
> any end-user too. Therefore no user would use those crazy resources
> either.

So, the above paragraph simply isn't true.  It's not difficult to
twist things bit so that things work in a hackish and often horrible
way and we know this happens quite a bit, especially in enterprise
settings.

> Intent is certainly not for the individual drivers as we agreed in
> past.

You and I agreeing to that doesn't really matter all that much.

> IB stack maintainers would be reviewing new enum addition
> anyway, whether its verb or hw resource (unlikely).

Well, if the additions are unlikely...

> > In the original review message, I mentioned creating an interface
> > which creates the hierarchy of objects as necessary and returns the
> > target pool with lock held, can you please give it a shot?  Something
> > like the following.
> 
> o.k. I will attempt. Looks doable.
> I am on travel so it will take few more days for me to turn around
> with below approach with tested code.

So, if you go with single mutex, you don't really need get_and_lock
semantics, you can just call the get function with mutex held.  Please
do whichever looks best.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 00:04:13 -0400
Message-ID: <20150911040413.GA18850@htj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zEU5/TtUxsGqQePuS3gVLyqdD89MDDNqD+gLt+ewhh0=;
        b=lrQfwpKHMCsPm8LzokFBs6n/70zh6TN53UpRLd/gA/xLts8RX70vHXZOeMYymDPs1l
         7w9N3ARFOgwq/RF2xRnx+1GKpwPwcNs7W6F616o8+7ismilxqUJfRUVBKm1MWiBz22k/
         NaUnlHWRk5lKI2i87kusU51kb0X8f8IE3lY/TF0O3E4y3paa5KDcFqeReI92ethDHwd4
         uKPtS373vk5k9cQPsKs7ZQXra49FTqUjgJGr6bDFHMF+P+iI16Od4hs867C14AzaW/mU
         Ol2PgAec8rNGfcaW2oLsOQGxCpqr2/Q09Iaf20MyMgGZyHxFH2ieIV9b0A+7vqh6H4/C
         Kxng==
Content-Disposition: inline
In-Reply-To: <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Fri, Sep 11, 2015 at 09:09:58AM +0530, Parav Pandit wrote:
> The fact is that user level application uses hardware resources.
> Verbs layer is software abstraction for it. Drivers are hiding how
> they implement this QP or CQ or whatever hardware resource they
> project via API layer.
> For all of the userland on top of verb layer I mentioned above, the
> common resource abstraction is these resources AH, QP, CQ, MR etc.
> Hardware (and driver) might have different view of this resource in
> their real implementation.
> For example, verb layer can say that it has 100 QPs, but hardware
> might actually have 20 QPs that driver decide how to efficiently use
> it.

My uneducated suspicion is that the abstraction is just not developed
enough.  It should be possible to virtualize these resources through,
most likely, time-sharing to the level where userland simply says "I
want this chunk transferred there" and OS schedules the transfer
prioritizing competing requests.

It could be that given the use cases rdma might not need such level of
abstraction - e.g. most users want to be and are pretty close to bare
metal, but, if that's true, it also kinda is weird to build
hierarchical resource distribution scheme on top of such bare
abstraction.

...
> > I don't know.  What's proposed in this thread seems way too low level
> > to be useful anywhere else.  Also, what if there are multiple devices?
> > Is that a problem to worry about?
>
> o.k. It doesn't have to be useful anywhere else. If it suffice the
> need of RDMA applications, its fine for near future.
> This patch allows limiting resources across multiple devices.
> As we go along the path, and if requirement come up to have knob on
> per device basis, thats something we can extend in future.

You kinda have to decide that upfront cuz it gets baked into the
interface.

> > I'm kinda doubtful we're gonna have too many of these.  Hardware
> > details being exposed to userland this directly isn't common.
> 
> Its common in RDMA applications. Again they may not be real hardware
> resource, its just API layer which defines those RDMA constructs.

It's still a very low level of abstraction which pretty much gets
decided by what the hardware and driver decide to do.

> > I'd say keep it simple and do the minimum. :)
>
> o.k. In that case new rdma cgroup controller which does rdma resource
> accounting is possibly the most simplest form?
> Make sense?

So, this fits cgroup's purpose to certain level but it feels like
we're trying to build too much on top of something which hasn't
developed sufficiently.  I suppose it could be that this is the level
of development that rdma is gonna reach and dumb cgroup controller can
be useful for some use cases.  I don't know, so, yeah, let's keep it
simple and avoid doing crazy stuff.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Peter Geis <pgwipeout-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] page allocation failure reading procfs ipv6 configuration
 files with cgroups
Date: Mon, 22 Feb 2021 18:40:15 -0500
Message-ID: <CAMdYzYojq--qWhxmpj4VL_feNjMFZcjN6q7mQL-+SWujScNzkQ@mail.gmail.com>
References: <d2d3e617-17bf-8d43-f4a2-e4a7a2d421bd@gmail.com> <20210220173605.GD2858050@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lu36EvNlVpZLf9vn0AKWWzvCVJacgGfuW8XvxcdcSYc=;
        b=MKjAdzGJEiG1GANzaNG8NQwv8A3zr3O9eiZt64ixz7q3fFUbHW+A/18gmHI0mqQkl4
         c0Czceg+s2X7DgJgR1QbTh5bRcInUFBql0hvlSazNZVog5hKHyIwhda+e0uTeGUs/zOR
         0K5hMHLjyjD/7J+bGPwFMw7RfvPNpnvk0f2ypbWwsM9jQeWrTsXl+bfSgDLg7Mjm3opO
         HpJxQgsLARFWgDehBIQ8B1nccgTfM3PpKxYNblTdH0/3mqgBpI4+Qj7827/GrCjL2iyI
         u5NZ5lCtHmkelBoVSzqMvg89VdBveFbLCSai7R259PBckLLhEQ3b5O3H4+r7AVCIt/FU
         EMNQ==
In-Reply-To: <20210220173605.GD2858050-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Feb 20, 2021 at 12:36 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Sat, Feb 20, 2021 at 12:29:18PM -0500, Peter Geis wrote:
> > Good Afternoon,
> >
> > I have been tracking down a regular bug that triggers when running OpenWRT in a lxd container.
> > Every ten minutes I was greeted with the following splat in the kernel log:
> >
> > [2122311.383389] warn_alloc: 3 callbacks suppressed
> > [2122311.383403] cat: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=lxc.payload.openwrt,mems_allowed=0
>
> You want this patch:
>
> https://lore.kernel.org/linux-fsdevel/6345270a2c1160b89dd5e6715461f388176899d1.1612972413.git.josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org/

I've tested this patch against 5.10.17 for 36 hours and can confirm it
solves the problem.
Thank you.

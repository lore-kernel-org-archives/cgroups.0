From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv11 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 25 Aug 2016 13:30:55 +0530
Message-ID: <CAG53R5UpqRYdngapS9Ti7A_=6sPZi3s357CuRk4xfnJg2-5L_Q@mail.gmail.com>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
 <20160824211747.GV8185@htj.duckdns.org> <20160825073226.GA18183@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4TRyW13/XOel0EibbRqgl2qwUaqAfH/Zn+VTLitwHYw=;
        b=h+jkM38TEtA3oRlmKhyiWmx6d07sEvyxpE/dHjLJxgmKu0BlXgmSRJg5+Vy3BhYr6x
         OjgT+EtQP+jH3Ss7I4LL/At1Nhg8CgaRGtEzFtvYY+0h0GQ1C+2JZlvN38O6SoDdC/Af
         XHHI4TCIyw7vu/ZRqO2U2R6mLT5xeCoCp7pBucLwH4F/X4s7qn277msJTG5kI8d1WWNH
         pD2Dy9VJHbeyvXZkw2uATeh19XP52Aht7Q7I73H1WLBgv2wgArua0a+NTGE2wwHWqQGb
         iEDqYmyPJ3XPV1Y9UuZcY9H3oYUwdmOUd42dnznHbgrzGYoO8KjL1gLMk9+ROUoRi89u
         toLQ==
In-Reply-To: <20160825073226.GA18183-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Christoph,

On Thu, Aug 25, 2016 at 1:02 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Wed, Aug 24, 2016 at 05:17:47PM -0400, Tejun Heo wrote:
>> Looks good to me.  I just have a nit in the documentation.  Christoph,
>> what do you think?
>
> Looks reasonable from a quick look, but I didn't do a full review yet.

Thanks for the quick review.
I need to generate new patch for 4 typo errors that Rami pointed out
and documentation addition that Tejun asked.
I will wait for your full review, in case if there are any comments,
so I can cover them in one patch.

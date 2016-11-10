From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 11:46:38 -0500
Message-ID: <20161110164638.GC26105@htj.duckdns.org>
References: <20161103180006.GL3617@leon.nu>
 <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jUCKke8ZU+38JoW30wQ4KnnzGuqQ3XmNCvw9RIFz9PE=;
        b=E6L3sZemf6Es+tabUKIuBtiP/WnR+OQpTxW732njAQvkxJEon1D+x3zQJzLfoXJRKR
         3BJpK7s+u8WdFOBcfYej2p5euuk6N9kjxBTIq4s8OpFygwj178VFWwHNf33B9Yoq1A6J
         DBN9x5qDhrIHWJkGZyEpyqMUXFIefAm6W2IEQ0Sk3AlzfNQ7lPR3sFmb2m6e4kiUL4ul
         hV6wcYSnCxJR0oi8NDu/9hY4Z3HCeyG3dFZ2JnstxFhurR+qWqnRNIItG+T2K//w6wiU
         LH+z/wt6boO35Obw/sDjf0MBVXekgDRDt6Qnsy1W8ZgVVzQ/dUeynb9983xqNiLFGhIU
         N4tg==
Content-Disposition: inline
In-Reply-To: <20161110163837.GE28957-2ukJVAZIZ/Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello,

On Thu, Nov 10, 2016 at 06:38:37PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 10, 2016 at 01:11:18PM +0530, Parav Pandit wrote:
> > Hi Leon, Tejun, Christoph, Liran,  Doug, Matan,
> >
> > So are you ok with below proposal?
> 
> I'm fine with it and it looks like very clean approach
> to solve our multi-object future.

No ojbection.  Parav, can you write up how the interface would look
like with examples?

Thanks.

-- 
tejun

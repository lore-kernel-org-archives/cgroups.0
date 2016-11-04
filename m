From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 10:17:55 +0530
Message-ID: <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
References: <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu> <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu> <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+0mr8x9ocwf922Yez9U/HD/KqWlCMDsIecUjeJ4HqDM=;
        b=T2ssgIKnxBtw8DtiHBrnBl1Qu8QTMXPyGn3Vd45rpbvRib5FKXaT3lpRbuCyuVzkiM
         ipBCki5QHCuwFzEDoty2/jsFTDmK0U6VUGOi/pWk6O7rsIv78RJkrlsglj07f0b6WPPA
         fx5OTDU2oSAk4mAXCOA9KDM+VhaoD2PC7F+BI99NgzQv7pQE4C65A5bcIxi+3XTgiAZ5
         C9AXMheA4/DDSBlMmLXMPIFncK18T8LbvOnMFr6aLijJMlnHIubMUctSPKlYkNJtip+a
         QPsGr9TpnwmGjNUjZ9+9T1LjQQ8JExjWt+YUCTa6BiBijt4a3Lzt08tf+qejO7tWTAvH
         xPfg==
In-Reply-To: <AM4PR0501MB2802030EE9E359133E04439CB1A20-dp/nxUn679jTOi/YP668sMDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Liran,

On Fri, Nov 4, 2016 at 9:50 AM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
>
>> We (Tejun, Christoph, Matan and me) had a face-to-face talk during KS/LPC and
>> decided that the best way to move forward is to export to user one object
>> (global HCA like) only and don't export anything else.
>>
>> All internal calculations will be based on this percentage.
>>
>> Once the cgroups users will come with reasonable justification why they need to
>> configure different unexposed objects, we will expose them.
>
> A global HCA metric is indeed in the right direction.
> However, rethinking this, I think that we should specify the metric in terms of RDMA objects rather than percentage.
> Basically, any resource that consumes an IDR is charged.
>
If metric definition is based on RDMA objects (count) and not based on
percentage, how would user specify the metric without really
specifying object type.
Current patch defines the metric as absolute numbers and objects as well.

Comment from Leon about his discussion with Matan, Tejun, Christoph
says opposite of this for user level configuration.
May be I am missing something.

> The reasons are:
> - Some HCAs can have a huge amount of resources (millions of objects), of which even a small percentage may consume a considerable amount of kernel memory.
> - We follow the same notion as FD limits, which accounts for numerous resource types that consume file objects in the kernel (files, pipes, sockets)
> - The namespaces for RDMA resources are large (usually 24 bits). So even large resource counts won't come nowhere close in depleting the namespace. (Compare that to the mere 64K socket port space...)
> - The metric measures the actual application usage of resources, rather than proportional to the resources of a given HCA adapter.
> - We can continue to use the cgroup mechanism for charging (just as in the original proposal)
>
> I have discussed this matter with Doug and Matan, and it seems like this is the right direction.
> --Liran
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

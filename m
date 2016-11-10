From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 13:11:18 +0530
Message-ID: <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
References: <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu> <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu> <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com> <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=YVMGgK+nMMnakKcQNmkNZ8Lr47E4zpLMu6nr8KNgEbY=;
        b=Ikd7TnJtCPNBtHXbQg4HkF3TGrAokURIw2vqy0B6PAMy6CuXN92nDeP/5r2LUncT51
         sB/Jvv9jyiNmbysCZANpWjaJc7qyWyu83Zg8YA0Zs8785Fcibtjq6ArmbMNpe82HY/Pn
         nbWajF5mggRmvHkVSA8x8wHyjbD8MRKevP1FhTSDg2TH5n/6cyXY0HFzYcxt5ZsNn04A
         osRI+4+LjB/mvenc36hoLLAMfGdxYM0fKLDXYb1CUWLXMZTGoCiBhXVIYcnJ+yHoPleT
         cmzt3mliiYRohJuyGsn6nIKv/D2VR81XAxhhwCM3MG3+9McQClxG2Gtp880XZbme6L1h
         sZoQ==
In-Reply-To: <HE1PR0501MB2812298C05431B08B0F408EEB1A60-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Leon, Tejun, Christoph, Liran,  Doug, Matan,

So are you ok with below proposal?

1. Define two resources by rdmacg.
(a) hca_handles (covers doorbell pages)
(b) hca_resources (mr, pd, qp, srq, vendor defined, all consolidated count)
Both cannot be combined as explained in [1].

2. User configures absolute count for above two resources (similar to
today's file descriptors, pid cgroup controller max limit)

Leon,
Let us know if you have any further discussions during LPC on
questions of [2] in using percentage based scheme or otherwise.

Parav

[1] https://www.spinics.net/lists/linux-rdma/msg42771.html
[2] https://www.spinics.net/lists/linux-rdma/msg42768.html



On Tue, Nov 8, 2016 at 1:42 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Parav Pandit [mailto:pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>
>> >
>> > Hmm..
>> > I guess that you are right.
>> >
>> > So we can add another count for "HCA handles",
>> I prefer this. This keeps it vendor agnostic and clean if we don't go percentage
>> route.
>
> OK; let's do it.
>
>> Would indirection table also fall in this category?
>>
>
> No. It's just another HCA resource...
>
>> > or alternatively, each provider will restrict the number of handles
>> > per device to a reasonable small number (which won't be treated as one of the
>> "HCA resources").
>> This would require vendor drivers to get the understanding of cgroup object
>> and pid and that breaks the modular approach. I like to avoid this.
>>
>> > Typically, a process shouldn't need to open more than a single handle...
>> Right. well behaved application won't do multiple handles.

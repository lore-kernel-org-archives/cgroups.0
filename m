From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 11:14:23 +0530
Message-ID: <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
References: <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu> <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu> <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com> <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Aao95wZSOCtonxm5hSRezC2sWFtiBkQQjuEqWISdcQ8=;
        b=A2xZs/sE5pDG5yr5S8PUaxhV1aHkbKvpOlYBGV0CIUsgj4hdlUtItLABofFNWqcEHH
         XV76M7Sr3KlbJEkZaGS45sa1ws0o/YxDtDNwfT4Gtwk51HI8K7IeHivFyUMZW/ObMktE
         uGHhSIj8GdC7f5ozll7Vqf59xiqWvgtnRij/4MZKX45++4Ds0RIAYOzk7hNaAXBgbYgi
         2i06FNHZo9eah9sKkxvjYjRdQY2tUxgxqT2GnjnMjfs5NveV+AW+X2bB/TxpUQKEKUhB
         6IhGVB6kvWEZkDeXLr5NXbNrjT/KqazEb8lIyAI7X8EXSyW7YJXTcHjOKsMKLYz1TDqj
         wUMA==
In-Reply-To: <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20-dp/nxUn679jTOi/YP668sMDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Liran,

On Fri, Nov 4, 2016 at 10:36 AM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Parav Pandit [mailto:pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>
>>
>> On Fri, Nov 4, 2016 at 10:22 AM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> >> From: Parav Pandit [mailto:pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> >
>> >> >
>> >> > A global HCA metric is indeed in the right direction.
>> >> > However, rethinking this, I think that we should specify the metric
>> >> > in terms of
>> >> RDMA objects rather than percentage.
>> >> > Basically, any resource that consumes an IDR is charged.
>> >> >
>> >> If metric definition is based on RDMA objects (count) and not based
>> >> on percentage, how would user specify the metric without really
>> >> specifying object type.
>> >> Current patch defines the metric as absolute numbers and objects as well.
>> >>
>> >
>> > That is the requested change. The absolute number would account for any
>> object allocation. We won't distinguish between types.
>> > Only a single counter (per device).
>> >
>>
>> In that case ucontext deserve a additional count. Because that is handful in
>> range of 256 to 1K.
>> If we give absolute consolidated number as 2000, one container will allocate all
>> the doorbell uctx and no other container can run.
>> Percentage works for this particular case.
>>
>
> Hmm..
> I guess that you are right.
>
> So we can add another count for "HCA handles",
I prefer this. This keeps it vendor agnostic and clean if we don't go
percentage route.
Would indirection table also fall in this category?

> or alternatively, each provider will restrict the number of handles per device to a reasonable small number (which
> won't be treated as one of the "HCA resources").
This would require vendor drivers to get the understanding of cgroup
object and pid and that breaks the modular approach. I like to avoid
this.

> Typically, a process shouldn't need to open more than a single handle...
Right. well behaved application won't do multiple handles.


>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

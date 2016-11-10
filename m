From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 23:26:28 +0530
Message-ID: <CAG53R5Wk2zbL=0_EcYCOXQ4dK-k_w=sLOFAKD98NnnbAAnu2=A@mail.gmail.com>
References: <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu> <20161110164638.GC26105@htj.duckdns.org>
 <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw@mail.gmail.com> <20161110173217.GD26105@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BPLEZ9C/0VKsPCIQx0ZTizo+dVqQp64iBqUMxdTGsTw=;
        b=coEmBnlh0+Hcf/leFWC2XJtxyohpDm8jdrhJCkuZSspOunApVKuoQJ3Jwza/Et/DAL
         B6B/CVTNcJkBRvy538MFv0EwhAVtTuoJYYb+uLTI7QbnTNALEzbN2YSAe2XUcU6qBRwd
         yxMlgJ8WyhIflcdp/qDi3K8cdOFGid3qBhPuydNnv29PSJdzYYEkWDPOXxyiI6nyjndJ
         zjYUzMv/LRF2F0LJijAo0VMKhHrJzkUVuSMAL5PWgDWh//T9WJnhZtIKyEr+kKo3YDr+
         bRD4Yvp3PV3tT5UDgWKq8EmOO1xQS5TXL+UMKmQX/pJkkvegQLi5cBp5KoE3phVh8boy
         4tlQ==
In-Reply-To: <20161110173217.GD26105-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,


On Thu, Nov 10, 2016 at 11:02 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Thu, Nov 10, 2016 at 10:34:44PM +0530, Parav Pandit wrote:
>> user-kernel interface:
>> ---------------------------
>> (a) rdma.current - Will continue to report resource count.
>> (b) rdma.max - will continue to accept hca_handles, and hca_objects as
>> absolute number.
>>
>> Instead of mr, pd, qp, ah, srq entries of patch_v12, it will have just
>> two entries for each device.
>> (1) hca_handles, (2) hca_objects.
>>
>> rdmacg - IB stack interface:
>> --------------------------------
>> cgroup_rdma.h will have two enum entries.
>>
>> RDMACG_RESOURCE_HCA_HANDLE
>> RDMACG_RESOURCE_OBJECT
>>
>> IB stack will charge either of the object.
>> When HCA handles are allocated/freed IB core will request charge/uncharge.
>> When standard verb resources such as PD, MR, CQ, QP, SRQ are
>> allocated/freed IB core will request for XX_OBJECT charge/uncharge.
>>
>> Currently defined APIs and interfaces just remains same.
>
> That looks great to me from cgroup side.  Do you have plans for
> exposing the maximum numbers available?
>
I thought more on this.
If I have to expose max limits, I need new file interface as rdma.limit.
Because once rdma.max is set, user space cannot get back the old value.
It needs to cache it. user space tools might have been restarted and
so on, so store in other file etc.
So such user space solutions are just ugly.

Getting and setting values in device agnostic way, through cgroup
files is desirable, however its not must. It can fallback on using
verb based API.

So if there is no objection, I prefer to have rdma.limit file as
incremental patch once base version is merged.


> Thanks.
>
> --
> tejun

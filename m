From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 22:34:44 +0530
Message-ID: <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw@mail.gmail.com>
References: <20161103180006.GL3617@leon.nu> <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu> <20161110164638.GC26105@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7o+dIcrQhfwATIxycWW3UkTAHEh8AMPvikGGdJ42cVg=;
        b=L1oTgHxYcLyilG8OtXwNx7d7rvedoFxHoLl2aBgghn9zpBVuy0WtUfmdA6zuCokzUX
         GnhYEx8Ch3cJY7hZJzx0InCW9fxHZ473jmjGATFvlouKJC61poNQAV+dE4XxSOS5iqod
         gN4UqCR/YErV5HeIfBdYepnpt4AHsl1FeQO8JqMUs/r/fpR45PVlTeAMKecJcgdxGahk
         IL3K/Nc+MMhvgHtUE10aI+nKM9XEx9XYMVqa9FNxwY6En09GGEEePjO7sUKMzmjsLguI
         TSm9gTvGMwcM7e3ZgLlKVsgz7oxz1FgOMX9qd3s6UEfzJVAa+2lFA0WRwqZ/U1z59Vpr
         i7zA==
In-Reply-To: <20161110164638.GC26105-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

On Thu, Nov 10, 2016 at 10:16 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Nov 10, 2016 at 06:38:37PM +0200, Leon Romanovsky wrote:
>> On Thu, Nov 10, 2016 at 01:11:18PM +0530, Parav Pandit wrote:
>> > Hi Leon, Tejun, Christoph, Liran,  Doug, Matan,
>> >
>> > So are you ok with below proposal?
>>
>> I'm fine with it and it looks like very clean approach
>> to solve our multi-object future.
>
> No ojbection.  Parav, can you write up how the interface would look
> like with examples?

Simplified version of v12 with no architecture change.
I will describe below.

user-kernel interface:
---------------------------
(a) rdma.current - Will continue to report resource count.
(b) rdma.max - will continue to accept hca_handles, and hca_objects as
absolute number.

Instead of mr, pd, qp, ah, srq entries of patch_v12, it will have just
two entries for each device.
(1) hca_handles, (2) hca_objects.

rdmacg - IB stack interface:
--------------------------------
cgroup_rdma.h will have two enum entries.

RDMACG_RESOURCE_HCA_HANDLE
RDMACG_RESOURCE_OBJECT

IB stack will charge either of the object.
When HCA handles are allocated/freed IB core will request charge/uncharge.
When standard verb resources such as PD, MR, CQ, QP, SRQ are
allocated/freed IB core will request for XX_OBJECT charge/uncharge.

Currently defined APIs and interfaces just remains same.

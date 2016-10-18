From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 19 Oct 2016 01:32:01 +0530
Message-ID: <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu> <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org> <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org> <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=K1rLAnRP9NNnENOjEVYDpTfKcdf17dHFuUO2ZecRh/A=;
        b=G9eim7H294r6BSQ0RdjG4YEKRccT6qAJ5EJJO1ZV4ZBkbcnYaUpjFQZ9tTim13DeuH
         w6Z8sbXVH5O/1caqSEa7diDTg9YGb6ScL0vW5CHOg182O5PQ/c8m8tKT/49FpJXLahh6
         UBYYvsHEEft4NEs4XN+UkTXMLOHlluvvAKS8vg5bqF+k96Qh9qfmoCoLKTcFXBkh2H+m
         bJ/ww5Z0PRFgD9ev6gYaWh2AepGWa4MQUZObAUWe1qF74ys6HS91wpwyMuwfki3W0N/4
         RpktcYyEQa+wmA6mnnbuq0OLRj3t8R8PO4err816fW5rTdKZINJTtx9Klqg6RaCdF8x/
         ejCw==
In-Reply-To: <20161013231413.GA32534-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

Sorry for the late response. I was traveling during weekend.

On Fri, Oct 14, 2016 at 4:44 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Mon, Oct 10, 2016 at 07:02:11PM +0530, Parav Pandit wrote:
>> Give me some more time, I will think more and take feeback from Leon
>> and others on
>> (a) how can we implement or want to implement weight like
>> functionality for non-work-conversing resource
>
> I think what you want is just a way to specify absolute limits using
> percentages of what's available at the time of configuration -
> e.g. being able to say "allow upto 30% of what's available in the
> parent".

Yes. I am concerned about how to configure < 1% value to avoid
floating point math in kernel as thats discouraged.
Configuring in range of 1 to 100% for a given resource limits to only
100 or less cgroup instances which I think is not desired.

> If so, the simplest way would be simply updating the
> existing knobs to accept % inputs in addition to absolute values on
> writes.

I was not sure to overload rdma.max file for accepting % inputs as
thats not done in other cgroups. So I was thinking more of weights
interface which avoids floating point problem and also allows much
wider configuration range.

>
> Thanks.
>
> --
> tejun

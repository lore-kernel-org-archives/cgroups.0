From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 20 Oct 2016 01:24:42 +0530
Message-ID: <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
References: <20161010122545.GA27360@mtj.duckdns.org> <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org> <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org> <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eu1IOe/hVKCN4yuCmR2Ptl6CDs/YQet0AF1PFhaPqLE=;
        b=mb9Xhkpk30T8770ji5tPtdmp+LqlGhkqyuCYtU03VLXz2C7IcJH4t2DmXMHXzfbmhe
         e0xSeQrbZ+m4f22TfY4e1nPntfFX5wWnmPFHCMM2c/JtZcXbkH4fBX5ZKZPapK+QhO1u
         9/WmT/nLQgX16zhLnQRihVjItdX8TcNDizo6oaQOiRt246SXlquR9LBrvjRyRXBgXcU8
         1Ctc43JyhZ+7aL8kIuu82PaJiRUZ1TM74bf0uFbdMQmIwSRPXEq9IjLpwVb4cuNeHNIX
         CnXa0HgpI+ZnHM5STcnA4FAEsfhJ8/K2yZwV5GOUEnHd1t3KvpmvdIEG9wuJnz6jLHSy
         MTpw==
In-Reply-To: <20161019192006.GB3044-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

On Thu, Oct 20, 2016 at 12:50 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Oct 20, 2016 at 12:33:53AM +0530, Parav Pandit wrote:
>> > or config changes in one of the ancestors?  What "max" means is "no
>> > limit is imposed" which is different from "limit it to 100% of what's
>> > currently available".
>>
>> Charging is hierarchical for rdmacg too.
>> rdma.max configuration exist at all the levels so ancestors change
>> won't affect its children.
>> rdma.max absolute (or future percentage) value is with reference to
>> the total device resources.
>
> Ah, right, the percentage is out of the total device resources
> regardless of the hierarchical restrictions.  I still don't think it's
> a good idea for rdmacg to deviate from the common interface
> conventions.  If you want to do the percentage calculation in the
> userland and the base numbers are system-wide numbers which are
> hardware dependent, it'd be best if there's an existing place where
> the numbers can be exposed naturally.  That'd be more in line with
> others too.  The amount of total resources available for the device
> isn't tied to cgroup after all.
>
userland can get the max numbers using other framework which is used
by control & data plane available in C library form or in form of
system tools.
I was preferring to get and set through same interface because,
It simplifies user land software which is often not written in C so
its likely that it needs to rely on system tools and parse the
content, iterate through devices etc.
Getting these info through rdma.max just makes it simple. There will
be logic built to read/write rdma.max in userland anyway, which can be
leveraged for percentage calculation instead of doing it from two
places.


> Thanks.
>
> --
> tejun

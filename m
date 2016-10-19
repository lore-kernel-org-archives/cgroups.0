From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 20 Oct 2016 01:48:27 +0530
Message-ID: <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
References: <20161010132014.GD29742@mtj.duckdns.org> <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org> <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=i3BS/khetWeXWqSmdOBnpLPe09HGa0pk/W7n6U+osRo=;
        b=sRbbQw0FgOrzd1+YABf72BGOA0YkLJOxeWwv2ElOzHtEI6QNWeOpsSrrBkIhp/eR2z
         Q9TwBioO9CUYR2HNfSI5tr6bPL6asbtJ5pvMMZKwJEETXH9NGv7b1Q/zClqo5bGQpeGO
         7SpPqk0rlGNvuUrY7mmrEawyB+HUtixsqWXwjmR4Kj0CrT4DmRcVSfeQhe+r+hsi4HlL
         6l2Rn9a3UXydWniHuTTUYg9iZewtqamlyLiFmK2g3ekG6ORxFEmQq5VRlJictf4fdbdF
         7U0/zNkLpwpZHvyarUMIshGoFI/cOCf+kRRsdtau2xqpG0Q+fsncHn/i1o+a5jNVWVng
         WRgw==
In-Reply-To: <20161019200536.GC3044-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On Thu, Oct 20, 2016 at 1:35 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Thu, Oct 20, 2016 at 01:24:42AM +0530, Parav Pandit wrote:
>> userland can get the max numbers using other framework which is used
>> by control & data plane available in C library form or in form of
>> system tools.
>> I was preferring to get and set through same interface because,
>> It simplifies user land software which is often not written in C so
>> its likely that it needs to rely on system tools and parse the
>> content, iterate through devices etc.
>> Getting these info through rdma.max just makes it simple. There will
>> be logic built to read/write rdma.max in userland anyway, which can be
>> leveraged for percentage calculation instead of doing it from two
>> places.
>
> Yeah, I get that this can be convenient in this case but it isn't a
> generic approach.  I'd much prefer keeping it in line with other
> resources.
>
Hmm. we don't have /proc/sys/kernel/pid_max type of simple interface
to get the max values for rdma resources.
rdma.max is close to that simplicity.




> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

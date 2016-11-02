From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 2 Nov 2016 10:04:01 +0530
Message-ID: <CAG53R5X5hY9BC52osKwjHt+5o5CULo4wL9irUDfhw80cF-VWKA@mail.gmail.com>
References: <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu> <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161101140732.GC3617@leon.nu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=P8k+HU7TROY/3wS6P/DcPg3p2i8jFbS0naqN0XWNNNE=;
        b=bPFdxHdJumCZNrpibX7zACTG/i3qAoIoXlih25qquGrr+G8pGzwdY7YBZZIzahe489
         rv479MzpNzij60Y6tDJBgOsAorw/IlkKiERt7bGL56O82r41x7RcYCMKeU0UAhpyOmgK
         a6yS7KBVNIc2q8Gv5vzNeYB3p3dOD56EyZHe5Z4/L2nd5twyJlaPhkZoeq1wRgCMQokt
         Gk97uPGFCs1MA2jVe86TAzf3y+XZxrxl2YuMGok/Zn3omwEgUg8vYd25foGP7bdyX3iL
         dJ1hynz/UY7psYc5GuUghXU6JB0uqtfzBvCJKjDnxZTTk0QN/cIElvskSH1I8OOTdTS/
         Nh5A==
In-Reply-To: <20161101140732.GC3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On Tue, Nov 1, 2016 at 7:37 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Nov 01, 2016 at 04:33:23PM +0530, Parav Pandit wrote:
>>
>> > 4. Cgroup configuration should be as close as possible to "standard" if
>> > such exists, so all infinite internet guides will work for RDMA too.
>> I didnt follow this comment. Can you please explain? Are you saying
>> rdma cgroup should have define all the objects of IB spec?
>
> It is not related to spec at all. There were comments from Tejun and you that
> other cgroups (CPU, ...) have different semantics and RDMA has something unique
> (I don't remember what was it). I want to see minimal uniqueness RDMA cgroups.
ok. Got it.
Its the weights interface which is is not suitable for stateful rdma
resources which cannot be reclaimed by other cgroup once allocated.

So proposing your idea in different way to have rdma.percentage
interface as described in previous email.
This is applicable for all the resources and allows generic
configuration for average user.

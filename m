From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 19 Oct 2016 16:05:36 -0400
Message-ID: <20161019200536.GC3044@htj.duckdns.org>
References: <20161010132014.GD29742@mtj.duckdns.org>
 <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org>
 <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
 <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZGr5J+ERQNwmBPRcmzOyKENwVaEPXpsB5vfqlaN4/Vs=;
        b=eTJJSFJndhEKRSjjvaghmm1snyclYFNLLRSyZSu6yz2oCiTFS+osC3kNGKfjrj6udE
         pfelVC5ulaYGisTrMAxLVeS/yQh8fLi7u/d9pwZcTBon5qFZhuYPqF1J4f051LRAqUWT
         xH0q6GKjTyXC9Dno7biWMGsYKsm/3UbSFtC7vgtKz/MUtoLtWGep3fbYkvEITot8PFKY
         4Pq9wweQ6d9Te4eY4gWrLOWzm5jQqWLoFi3R4dyFUPzKxT/QljjuItKFtrfCFBRozu68
         1WIKiU8WhM1tyoGm9NGn9DOu5kdHQ3fjxIDYpdB+lRXIA7Pe6tGRuM6/NfaqKNCHZGD1
         6tyw==
Content-Disposition: inline
In-Reply-To: <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Thu, Oct 20, 2016 at 01:24:42AM +0530, Parav Pandit wrote:
> userland can get the max numbers using other framework which is used
> by control & data plane available in C library form or in form of
> system tools.
> I was preferring to get and set through same interface because,
> It simplifies user land software which is often not written in C so
> its likely that it needs to rely on system tools and parse the
> content, iterate through devices etc.
> Getting these info through rdma.max just makes it simple. There will
> be logic built to read/write rdma.max in userland anyway, which can be
> leveraged for percentage calculation instead of doing it from two
> places.

Yeah, I get that this can be convenient in this case but it isn't a
generic approach.  I'd much prefer keeping it in line with other
resources.

Thanks.

-- 
tejun

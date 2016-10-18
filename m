From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 18 Oct 2016 17:51:34 -0400
Message-ID: <20161018215134.GB2761@htj.duckdns.org>
References: <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu>
 <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org>
 <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org>
 <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org>
 <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=URrUhpys8vWBT6kKc/0/wmVypf0+IWyGL17u/go0Kxc=;
        b=K0RheA/KayIuA0XJu9W3wQASu8pvBZj703aPInn6vAfDcx5cggFxDz8aCOuYjfElA/
         w1w1rrR9VdTU+71ujLPQtXYQFrqjpoLFNlyDstEMlNzPOSNGjioM4qVdjvvfKGbhAAag
         CkZRDEkqLB0M1d8LdbKU0XYM6fSJ3D/oJ/Nf34Eto+fw3d1OrzR1We8KBmwJUK+VHRX+
         AEMQ7c2K7tU3UKAOTMmk1nhqQkESefU/Dv95LRq1GGnIlCZW4TJR4G/3+N5O3IctToHE
         0+vSHDK8gKbU/1XgphbBJo7VMIownUK2KjIOBHKYJquJHo5UmFdPhBtI5SuQJbFoPJTq
         VRiQ==
Content-Disposition: inline
In-Reply-To: <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello,

On Wed, Oct 19, 2016 at 01:32:01AM +0530, Parav Pandit wrote:
> On Fri, Oct 14, 2016 at 4:44 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > I think what you want is just a way to specify absolute limits using
> > percentages of what's available at the time of configuration -
> > e.g. being able to say "allow upto 30% of what's available in the
> > parent".
> 
> Yes. I am concerned about how to configure < 1% value to avoid
> floating point math in kernel as thats discouraged.
> Configuring in range of 1 to 100% for a given resource limits to only
> 100 or less cgroup instances which I think is not desired.

Heh, we can go for per-mil and use %0 as the suffix if absolutely
necessary but is this a real issue?

> > If so, the simplest way would be simply updating the
> > existing knobs to accept % inputs in addition to absolute values on
> > writes.
> 
> I was not sure to overload rdma.max file for accepting % inputs as
> thats not done in other cgroups. So I was thinking more of weights
> interface which avoids floating point problem and also allows much
> wider configuration range.

I think it's a lot more consistent to implement all absoulte limits
through max.  weight is for actual proportional control which this
isn't.  It's just a fancy way of specifying absolute limits.

Thanks.

-- 
tejun

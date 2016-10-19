From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 19 Oct 2016 15:20:06 -0400
Message-ID: <20161019192006.GB3044@htj.duckdns.org>
References: <20161010122545.GA27360@mtj.duckdns.org>
 <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org>
 <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org>
 <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=euiiNsksHjnfs7he6feCHCkErE66VRW/NCILSOsQLKQ=;
        b=lBKicx5170pIElrs/1xplS8SvvCxoJuXpEBv1F9adqKGP2/Kp9rWEp5YJRQhravBu0
         h//z3CCdpAm1VmLS0vyJPWkOQETe5p0Jm4avlAGTiWFaKorqPMdYUIUEdOn0WprUiV6U
         3P2JWoYm0YtpUx2UlCcDPC4NN+a00xBBXzbqzCIV1Ek0EXWtG1kmUVYtEkZNF74lEIYj
         D5i7hzkrHGPxEx/WVSKbJYpAdLdUmnr6hbEOIVTCV9zLaC1/8JWafF1cTXRL/sWcdR57
         hPb4lJGeHF4bxgLdx+Um0uh6/ptVW84Onzj+FI0k0L5ckkKvO2f6GsFrFYaxzd9OUHlX
         FdOg==
Content-Disposition: inline
In-Reply-To: <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello,

On Thu, Oct 20, 2016 at 12:33:53AM +0530, Parav Pandit wrote:
> > or config changes in one of the ancestors?  What "max" means is "no
> > limit is imposed" which is different from "limit it to 100% of what's
> > currently available".
>
> Charging is hierarchical for rdmacg too.
> rdma.max configuration exist at all the levels so ancestors change
> won't affect its children.
> rdma.max absolute (or future percentage) value is with reference to
> the total device resources.

Ah, right, the percentage is out of the total device resources
regardless of the hierarchical restrictions.  I still don't think it's
a good idea for rdmacg to deviate from the common interface
conventions.  If you want to do the percentage calculation in the
userland and the base numbers are system-wide numbers which are
hardware dependent, it'd be best if there's an existing place where
the numbers can be exposed naturally.  That'd be more in line with
others too.  The amount of total resources available for the device
isn't tied to cgroup after all.

Thanks.

-- 
tejun

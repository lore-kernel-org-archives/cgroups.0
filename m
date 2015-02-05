From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Thu, 5 Feb 2015 17:25:22 -0500
Message-ID: <20150205222522.GA10580@htj.dyndns.org>
References: <xr93h9v8yfrv.fsf@gthelen.mtv.corp.google.com>
 <20150130062737.GB25699@htj.dyndns.org>
 <20150130160722.GA26111@htj.dyndns.org>
 <54CFCF74.6090400@yandex-team.ru>
 <20150202194608.GA8169@htj.dyndns.org>
 <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <20150204170656.GA18858@htj.dyndns.org>
 <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IzC42CtKuf3buTw4WUxm98Uwgqy2e4TneHYq4Re4n54=;
        b=mRYVmgCcsYvD3/a60nd7BkQ3eranZM7i6m1coOUzwioTLAmtoy/jcy3FQTt0A4/Bi6
         I7/Rizl1/u/DZeoQcFrI7s6Vovtcl/bNFna7pZY5TRJj8Qa68nMulrnk0nBBHnAKiLAd
         vLz3DabcyR2tA0iuIUKcZoViFxvu9AaVVnEBkoWTC48txQLOo+upL31sag/M9S77IwNq
         iBqKBxZyOW4FEgGHJ8MIR0wZxchJ6jenrvF8hs7wgaaxDQsYSMmWhIDOzfW+a9i4vnom
         CaABtxjGCP7lUvmgsohcEe1ht8kQRe3y06Z0Klu1BtBB0812iaYSJZRp3vvcsBxfyi0Q
         xnlQ==
Content-Disposition: inline
In-Reply-To: <xr93siekt3p3.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey,

On Thu, Feb 05, 2015 at 02:05:19PM -0800, Greg Thelen wrote:
> >  	A
> >  	+-B    (usage=2M lim=3M min=2M hosted_usage=2M)
> >  	  +-C  (usage=0  lim=2M min=1M shared_usage=2M)
> >  	  +-D  (usage=0  lim=2M min=1M shared_usage=2M)
> >  	  \-E  (usage=0  lim=2M min=0)
...
> Maybe, but I want to understand more about how pressure works in the
> child.  As C (or D) allocates non shared memory does it perform reclaim
> to ensure that its (C.usage + C.shared_usage < C.lim).  Given C's

Yes.

> shared_usage is linked into B.LRU it wouldn't be naturally reclaimable
> by C.  Are you thinking that charge failures on cgroups with non zero
> shared_usage would, as needed, induce reclaim of parent's hosted_usage?

Hmmm.... I'm not really sure but why not?  If we properly account for
the low protection when pushing inodes to the parent, I don't think
it'd break anything.  IOW, allow the amount beyond the sum of low
limits to be reclaimed when one of the sharers is under pressure.

Thanks.

-- 
tejun

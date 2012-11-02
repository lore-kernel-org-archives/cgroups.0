From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: fix hotplugged memory zone oops
Date: Fri, 2 Nov 2012 16:31:18 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1211021626150.11106@eggly.anvils>
References: <505187D4.7070404@cn.fujitsu.com> <20120913205935.GK1560@cmpxchg.org> <alpine.LSU.2.00.1209131816070.1908@eggly.anvils> <507CF789.6050307@cn.fujitsu.com> <alpine.LSU.2.00.1210181129180.2137@eggly.anvils> <20121018220306.GA1739@cmpxchg.org>
 <alpine.LNX.2.00.1211011822190.20048@eggly.anvils> <20121102102159.GA24073@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=4iZ/DC/zeAVorP0BPVTCEF1pU4trKTuDgJcAoR5qzkI=;
        b=H7Q4L+19LZYC8eFiabTag9BDHprNjmr4UIXtOcv6Mn947wCAVtM0/4hhOyF0IU5Ci0
         3IWRc2aeIncR6Jw9YB7n9Amrnlunl0U9GBGvdIaNT8PjO1aRNMOkD4xY28CFnt1kexV7
         ZwfAVxoCKqGDPnRhQTxZtz8eTQS/2PYCxF76Cy4ZzXrx0YatLIHisceJwIRo1X06SaCQ
         ztZZ181qL0DD/PjWgVgrydMRFbToa3fNo0u+8KGV64cyHwizIRPFQXxAfG4w8nEePd9r
         KDiSKOIIXaEOZlx3WN9GV84qV1P+EdnhgldO0MzWj8Z7wdJ/6/WDOnJ/L+tXzl7SpRty
         40AQ==
In-Reply-To: <20121102102159.GA24073-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Wen Congyang <wency-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jiang Liu <liuj97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Fri, 2 Nov 2012, Michal Hocko wrote:
> 
> OK, it adds "an overhead" also when there is no hotadd going on but this
> is just one additional mem access&cmp&je so it shouldn't be noticable
> (lruvec->zone is used most of the time later so it not a pointless
> load).

I think so too.

> It is also easier to backport for stable.

Yes.

> But is there any reason to fix it later properly in the hotadd hook?

I don't know.  Not everybody liked it fixed this way: it's not
unreasonable to see this as a quick hack rather than the right fix.

I was expecting objectors to post alternative hotadd hook patches,
then we could compare and decide.  That didn't happen; but we can
certainly look to taking out these lines later if something we
agree is better comes along.  Not high on anyone's agenda, I think.

> 
> Anyway
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks,
Hugh

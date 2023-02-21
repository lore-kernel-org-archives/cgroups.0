From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Tue, 21 Feb 2023 16:21:17 +0100
Message-ID: <Y/ThbQNqrdny4+Pf@dhcp22.suse.cz>
References: <20230210094550.5125-1-haifeng.xu@shopee.com>
 <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
 <82918a12-d83e-10c0-0e04-eec26657b699@shopee.com>
 <Y/S3GHT1P6awZaPb@dhcp22.suse.cz>
 <99bdfbec-2de4-b432-9649-09557d3f95d6@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676992877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gzHiHoqH1FZ2e8or4vCjWdlBkU2/7QX1hNdRkugFVaM=;
        b=LgKqeo2yQ2b1D0vJPE7Wjp9MTcodIdE2vXEn1gZ//a8FuhQ9ii4mh4H5rDAL/Tr1f9SzFB
        sB8OPFP2fFPTN1KhtaaEvkMNx1gadQSAqlS9PRt1QrX4dncGI7ulO5iOTfM1uRSUZvsKU7
        12M7ip+L/P6NrUrHbV8prJjVsYRv7Kk=
Content-Disposition: inline
In-Reply-To: <99bdfbec-2de4-b432-9649-09557d3f95d6-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 21-02-23 22:21:45, Haifeng Xu wrote:
[...]
> >> The test result show that with or without the patch, the time taken is almost the same.
> > 
> > This is in line with my expectation. So the question is whether the
> > additional check is really worth it. 
> 
> This patch doesn't bring any obvious benifit or harm, but the high
> limit check in root memcg seems a little weird.  Maybe we can add this
> check

Well, I do not see the code to look weird TBH. There is nothing wrong in
doing the check for the root memcg. It is a bit pointless but it is not
incorrect.

> It all depends on your viewpoint.

From my POV, I prefer changes that either fix something (correctness
issue or a performance issue/improvement) or improve readbility. The
check doesn't fix anything and I am not convinced about an improved
readabilit either.

Thanks for the patch anyway!
-- 
Michal Hocko
SUSE Labs

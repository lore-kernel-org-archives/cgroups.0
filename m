From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 14 Aug 2023 14:18:31 -1000
Message-ID: <ZNrEV1qEcQMUgztn@slm.duckdns.org>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com>
 <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com>
 <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-9QzY-a40A@mail.gmail.com>
 <CABWYdi0+0gxr7PB4R8rh6hXO=H7ZaCzfk8bmOSeQMuZR7s7Pjg@mail.gmail.com>
 <CAJD7tkaf5GNbyhCbWyyLtxpqmZ4+iByQgmS1QEFf+bnEMCdmFA@mail.gmail.com>
 <CAJD7tkb=dUfc=L+61noQYHymHPUHswm_XUyFvRdaZemo80qUdQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692058714; x=1692663514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iI/z3p1z+oyuvkMoGO3dhSMxAz4pa3XR9N0pfdyH1rA=;
        b=ZetMe4wDM/zQ8LujISpxiJVpdhExK6n4UGgEYvahiHieWe6yvAO7zOlZjAC4rxGbwY
         g9SSYLFu5SjRyBybonkHUitUBuUvIQfMnTG7/Gyyj2c6NYX/Q4pbztzk9ZD/hIlHO9Dy
         hzLIsjmH1AezKGQfiDXTcKQmND/UMj7JD5sUVN27ODMpHKC9P5wTJspfkuj1SINQIm0U
         2Ye1n8dCGUvAEU68VXJ2qZ0uWcqjcFETeQQD94DHYJEtIodWwMujb3desP5BXnCnwY9K
         MqGr+SM97wwe6DnNprIF1WgArQITtdv5QCv290li2MZYGkyzF7V8Sbn1B/tB3dAMZJTQ
         56fw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkb=dUfc=L+61noQYHymHPUHswm_XUyFvRdaZemo80qUdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Aug 11, 2023 at 05:01:08PM -0700, Yosry Ahmed wrote:
> There have been a lot of problems coming from this global rstat lock:
> hard lockups (when we used to flush atomically), unified flushing
> being expensive, skipping flushing being inaccurate, etc.
> 
> I wonder if it's time to rethink this lock and break it down into
> granular locks. Perhaps a per-cgroup lock, and develop a locking
> scheme where you always lock a parent then a child, then flush the
> child and unlock it and move to the next child, etc. This will allow
> concurrent flushing of non-root cgroups. Even when flushing the root,
> if we flush all its children first without locking the root, then only
> lock the root when flushing the top-level children, then some level of
> concurrency can be achieved.
> 
> Maybe this is too complicated, I never tried to implement it, but I
> have been bouncing around this idea in my head for a while now.
> 
> We can also split the update tree per controller. As far as I can tell
> there is no reason to flush cpu stats for example when someone wants
> to read memory stats.

There's another thread. Let's continue there but I'm a bit skeptical whether
splitting the lock is a good solution here. Regardless of locking, we don't
want to run in an atomic context for that long anwyay.

Thanks.

-- 
tejun

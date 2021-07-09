From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Fri, 9 Jul 2021 11:17:56 -0400
Message-ID: <20210709151756.u3su4vleiowd5tky@oracle.com>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
 <20210702200742.wuhdg4dhpolher3t@oracle.com>
 <CA+PpKPmN2E5zCjP3mkurNA2GANtLCUmoPG+_4mUq3E8cxOhuhQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=otqpN61pViFGHMc2ANP/EZDomhNwidHWFEwCBXECaPs=;
 b=xr4GBFVdfMDdwtnPhatONZaOOkeGeXJrDaWuKq7GUr2xD5EcN/fYjALRP/8JQiB/Csph
 cTABRGgBGZgI7OF9Z/pf7oT4Eg1aiBNnoF220mLQk6kEiWuGXvapLHmtzIaPN20HDU+x
 Zpmmzdcxp3UooFd+APJuVAbLpvjgWZQOdew6Emgy/UCaH93ySZk7FY2wq4w6oqyRwbTa
 r2IGupwBuaY+gs4hlDi/rOeiy4Hooa9ZlvDORFpIVatJhPIEGULBdrqkZhANLUaDwq9M
 KFC9iFGMj7kVjluRz0SiUQQWTZGPF5uVRah7shGuIU0U+KQn38AhegZJKRnW3xQQ4StC WA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otqpN61pViFGHMc2ANP/EZDomhNwidHWFEwCBXECaPs=;
 b=PSca18f2tFoIAyZNkbCnYiwuLN5mivGbMn2tyAjQXqvAmp+Rsyj7xGozCA5qHAi0z98in/hg+1mGZvYhTQ+oaCGx7PdiENRki2VXupnZs8v81ync84jNc3mIALraGsMOT/BBC/PQ93rRJ18XLrKrKl7RhrzZSE+zM+QMcSi5Ml4=
Content-Disposition: inline
In-Reply-To: <CA+PpKPmN2E5zCjP3mkurNA2GANtLCUmoPG+_4mUq3E8cxOhuhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi,

[only replying now b/c I was out most of this week]

On Sun, Jul 04, 2021 at 12:18:22AM +0800, Hao Lee wrote:
> On Sat, Jul 3, 2021 at 4:07 AM Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > So naturally, I'm curious about your use case and how it may be
> > different from these others. What kworkers would you like to account?
> 
> Thanks. We use a workqueue to perform asynchronous reclaim for cgroups.
> The kworker may consume lots of CPU cycles if the cgroup memory pressure
> is extremely high, so we want to charge the cpu usage to the related
> cgroup for which the kworker works. Otherwise, the reclaim kworker will
> steal cpu time from the system level, which breaks the resource isolation.

Ok, that helps.

> I also have a question here. Are the back-charging and remote charging
> the same thing?

Basically yes.

> > The only one I'm aware of
> > that's like that is net rx, where the work to process packets has to
> > start before their ultimate destination, and therefore cgroup, is known.
> 
> Sorry. Is this a typo?  It seems the word "known" should be "unknown"...

What I'm saying is, the work to process packets starts when the cgroup
is unknown.

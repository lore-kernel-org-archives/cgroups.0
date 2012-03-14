From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: What's the progress of per cgroup background reclaim?
Date: Wed, 14 Mar 2012 17:32:09 +0900
Message-ID: <4F605789.7070007@jp.fujitsu.com>
References: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

(2012/03/14 16:53), Zhu Yanhai wrote:

> Hi all,
> Just a quick question, could you please tell me what's the current
> status of the development of per cgroup background reclaim? This topic
> seems to be silent after Han Ying's patchset V7
> (http://lwn.net/Articles/440073/) and Kame's async reclaim patchset V3
> (https://lkml.org/lkml/2011/5/26/20), and I can't find it in
> memcg-devel tree either.
> Is anyone still working on this?


I'll do and have a plan. But there are several ongoing projects as

 a) per lruvec lock
 b) page cgroup diet
 c) kmem accounting
 d) hugetlb accounting
 e) some fixes in cgroup
 f) more tweaks in vmscan.c
 g) writeback and dirty ratio.

I think it will come after a) and b), at least. And it's better
to have g) before kswapd-for-memcg.


Thanks,
-Kame

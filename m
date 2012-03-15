From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: What's the progress of per cgroup background reclaim?
Date: Thu, 15 Mar 2012 10:09:12 +0900
Message-ID: <4F614138.10609@jp.fujitsu.com>
References: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com> <CALWz4iyqyQD3g27J=wLvQ=WN0enXLB3rmHDAb51UJaLPJDz5BA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALWz4iyqyQD3g27J=wLvQ=WN0enXLB3rmHDAb51UJaLPJDz5BA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/15 1:17), Ying Han wrote:

> On Wed, Mar 14, 2012 at 12:53 AM, Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi all,
>> Just a quick question, could you please tell me what's the current
>> status of the development of per cgroup background reclaim? This topic
>> seems to be silent after Han Ying's patchset V7
>> (http://lwn.net/Articles/440073/) and Kame's async reclaim patchset V3
>> (https://lkml.org/lkml/2011/5/26/20), and I can't find it in
>> memcg-devel tree either.
>> Is anyone still working on this?
> 
> There were some discussions on going w/ per-memcg kswapd thread or
> workqueue by that time. And now I think we agree to go w/ the
> per-memcg thread model. 


I think agreed, too.

Thanks,
-Kame

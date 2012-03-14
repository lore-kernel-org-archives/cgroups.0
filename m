From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: What's the progress of per cgroup background reclaim?
Date: Wed, 14 Mar 2012 09:17:01 -0700
Message-ID: <CALWz4iyqyQD3g27J=wLvQ=WN0enXLB3rmHDAb51UJaLPJDz5BA@mail.gmail.com>
References: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=UldMUl5JnR5O23tu+XwXCH54lyDZ/ygEELSKn+zRNV4=;
        b=fnZ/YbXVDOcUV2scX7ZTw72LtYiD4MEf4H99iS55+Xv46wFU+OvwVTATBYg5aDrmXQ
         TV42XYOuNNG7ekgEELENIwQIgp6q9hJw+XoWYiZX4Ehh1yGePb+CmT2+g/LyHuLWagqe
         C7JjmI4T4vLMZr5N+YxkKsM8xAdQGNVqqjFatL1bkX9gUPqWsS72dcBlX/Au2++pBQzN
         gFN8RA3bMUTcQsSZzXxUg4Ff1gXEnrtmC/rqLX+W7Wcmvil1Ic6vf/7O1WIiuw3ClxTT
         wmbrnhyMnnOOO2IW3zJ3UAZFqy97QY2Md5hhf69Oxo5nwtwQ3A9PKpok8iN7WiBW84m0
         cg6Q==
In-Reply-To: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Wed, Mar 14, 2012 at 12:53 AM, Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi all,
> Just a quick question, could you please tell me what's the current
> status of the development of per cgroup background reclaim? This topic
> seems to be silent after Han Ying's patchset V7
> (http://lwn.net/Articles/440073/) and Kame's async reclaim patchset V3
> (https://lkml.org/lkml/2011/5/26/20), and I can't find it in
> memcg-devel tree either.
> Is anyone still working on this?

There were some discussions on going w/ per-memcg kswapd thread or
workqueue by that time. And now I think we agree to go w/ the
per-memcg thread model.  I haven't done much work since then, and one
of questions is to demonstrate the need of this feature.

I am glad you are asking, do you have workload showing problems w/o it?

--Ying

>
> Thanks,
> Zhu Yanhai

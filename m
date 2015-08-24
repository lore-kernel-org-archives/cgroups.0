From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 17:17:07 -0400
Message-ID: <20150824211707.GJ28944@mtj.duckdns.org>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RYBDm8ffNFZofCC4qnvWhwEGJe6YjPOJItVcI+UDV64=;
        b=tCov+pai3vQvoz4Zypc4Wy4yixByi506zAofY/Vr3wtCnFADg1+ehmotypPMWiAx0q
         Pg0bKgnb5c0YvGU2ZmGHuSs51r+Mk3oMvpD1WTIcdI1QqBHpcG0csU+PwwKeb7JbLdJU
         MUIRzYlj7DzP1bxuFccrZ7d/L9i1cYy1V/xzT+JgCspX6xV8tsSetotOua2DsyQ/ehVg
         RU0SGcbw31K/m/YbT137y0+9YsL5QnnjrBCDef4UUiMWQDIJs9h04eVtDRaBclIMn0hK
         G+0PEw3u8NpQnHzNiFAJozaoSOM0NCrk9GGaeMfAjBzHnBJ2uweEiQR/KaEI741/k6ZT
         vAYA==
Content-Disposition: inline
In-Reply-To: <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Aug 24, 2015 at 02:10:17PM -0700, Paul Turner wrote:
> Suppose that we have 10 vcpu threads and 100 support threads.
> Suppose that we want the support threads to receive up to 10% of the
> time available to the VM as a whole on that machine.
> 
> If I have one particular support thread that is busy, I want it to
> receive that entire 10% (maybe a guest is pounding on scsi for
> example, or in the thread-pool case, I've passed a single expensive
> computation).  Conversely, suppose the guest is doing lots of
> different things and several support threads are active, I want the
> time to be shared between them.
> 
> There is no way to implement this with nice.  Either a single thread
> can consume 10%, and the group can dominate, or the group cannot
> dominate and the single thread can be starved.

Would it be possible for you to give realistic and concrete examples?
I'm not trying to play down the use cases but concrete examples are
usually helpful at putting things in perspective.

Thanks.

-- 
tejun

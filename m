From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 15:35:39 -0400
Message-ID: <20200417193539.GC43469@mtj.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
 <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=luHo+qUc09xAb9CYN0R3dmgiGU/S+4Wd99hWa0GXwKA=;
        b=MBiKVb7DJCLk4GQ1nbBSQtQCKFUt+l6LpeFFuWqf3xwbWP4o5818o68yYbWoq6Fz/U
         8HjE5xb1+4bkeoJgjgyx7XeZ/7ls6NNzpT8nar90SqfK+md4ewztH2VASHSBYvEkBzoR
         TNPPR9Wnux0nZrPgnm/zI8w2c//1uhhd0Hxra6MHoSmH9rCQiPhBoDwR8Uydc1yZCnc3
         s/OtZhegf9pY2WyoZP7Hwj6JY6gVy8cM67GVCm1n7b/EVAFFUt1IZHPkQHtJY1gdy3jY
         bU+ZiTxDlY3SNjlIOwz7OhzqR1/KsGQ/qDY/dXoLnl4QG6zd9SvwHxjecQVs7pZIxthJ
         Nl5Q==
Content-Disposition: inline
In-Reply-To: <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Apr 17, 2020 at 10:51:10AM -0700, Shakeel Butt wrote:
> > Can you please elaborate concrete scenarios? I'm having a hard time seeing
> > differences from page cache.
> 
> Oh I was talking about the global reclaim here. In global reclaim, any
> task can be throttled (throttle_direct_reclaim()). Memory freed by
> using the CPU of high priority low latency jobs can be stolen by low
> priority batch jobs.

I'm still having a hard time following this thread of discussion, most
likely because my knoweldge of mm is fleeting at best. Can you please ELI5
why the above is specifically relevant to this discussion?

I'm gonna list two things that come to my mind just in case that'd help
reducing the back and forth.

* With protection based configurations, protected cgroups wouldn't usually
  go into direct reclaim themselves all that much.

* We do have holes in accounting CPU cycles used by reclaim to the orgins,
  which, for example, prevents making memory.high reclaim async and lets
  memory pressure contaminate cpu isolation possibly to a significant degree
  on lower core count machines in some scenarios, but that's a separate
  issue we need to address in the future.

> > cgroup A has memory.low protection and no other restrictions. cgroup B has
> > no protection and has access to swap. When B's memory starts bloating and
> > gets the system under memory contention, it'll start consuming swap until it
> > can't. When swap becomes depleted for B, there's nothing holding it back and
> > B will start eating into A's protection.
> >
> 
> In this example does 'B' have memory.high and memory.max set and by A

B doesn't have anything set.

> having no other restrictions, I am assuming you meant unlimited high
> and max for A? Can 'A' use memory.min?

Sure, it can but 1. the purpose of the example is illustrating the
imcompleteness of the existing mechanism 2. there's a big difference between
letting the machine hit the wall and waiting for the kernel OOM to trigger
and being able to monitor the situation as it gradually develops and respond
to it, which is the whole point of the low/high mechanisms.

Thanks.

-- 
tejun

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: expose root cgroup's memory.stat
Date: Fri, 15 May 2020 14:09:06 -0400
Message-ID: <20200515180906.GA630613@cmpxchg.org>
References: <20200508170630.94406-1-shakeelb@google.com>
 <20200508214405.GA226164@cmpxchg.org>
 <CALvZod5VHHUV+_AXs4+5sLOPGyxm709kQ1q=uHMPVxW8pwXZ=g@mail.gmail.com>
 <20200515082955.GJ29153@dhcp22.suse.cz>
 <20200515132421.GC591266@cmpxchg.org>
 <CALvZod7SdgXv0Dmm3q5H=EH4dzg8pXZenMUaDObfoRv5EX-Pkw@mail.gmail.com>
 <20200515150026.GA94522@carbon.DHCP.thefacebook.com>
 <CALvZod5EHzK-UzS9WgkzpZ2T+WwA8LottxrTzUi3qFwvUbOk4w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VtzLCBVok8XlbDgDkip+DgPbXfjB0Ty8UH/3nIag75g=;
        b=PWW0GHaOTt1grzeYKkoIvWRXSG1ezxAQ+T3eDFecYfulUEoEJYp420H3TUxznxZXQ1
         9lmGHfjOikCYafK145P0664YqWXjwb4EGqCEWKoudJakCv8Dw1OXKswDI/STZl84s0oj
         FdHtIChT8Sant8We8ACswlssnUtp1DMS9fkJLszaFdnX3veOh9/6Cx9Liy4idE0Ng0ft
         t1uS6PEF6Jr4UxM7+nsO1+Vcco4BLQ36HwyN/C+YXmXX+cx7z/wgen2muSrBI9qh39hf
         6/CXUnvoyK9hziUMbIPb/ehW4roSn+H/XCPV41JvgL3t2j69yBmk3DHDxruevgNlwBEx
         927w==
Content-Disposition: inline
In-Reply-To: <CALvZod5EHzK-UzS9WgkzpZ2T+WwA8LottxrTzUi3qFwvUbOk4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 15, 2020 at 10:49:22AM -0700, Shakeel Butt wrote:
> On Fri, May 15, 2020 at 8:00 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > On Fri, May 15, 2020 at 06:44:44AM -0700, Shakeel Butt wrote:
> > > On Fri, May 15, 2020 at 6:24 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > > You're right. It should only bypass the page_counter, but still set
> > > > page->mem_cgroup = root_mem_cgroup, just like user pages.
> >
> > What about kernel threads? We consider them belonging to the root memory
> > cgroup. Should their memory consumption being considered in root-level stats?
> >
> > I'm not sure we really want it, but I guess we need to document how
> > kernel threads are handled.
> 
> What will be the cons of updating root-level stats for kthreads?

Should kernel threads be doing GFP_ACCOUNT allocations without
memalloc_use_memcg()? GFP_ACCOUNT implies that the memory consumption
can be significant and should be attributed to userspace activity.

If the kernel thread has no userspace entity to blame, it seems to
imply the same thing as a !GFP_ACCOUNT allocation: shared public
infrastructure, not interesting to account to any specific cgroup.

I'm not sure if we have such allocations right now. But IMO we should
not account anything from kthreads, or interrupts for that matter,
/unless/ there is a specific active_memcg that was set by the kthread
or the interrupt.

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 beatomic flags
Date: Tue, 23 Sep 2014 09:13:19 -0400
Message-ID: <20140923131319.GC14905@mtj.dyndns.org>
References: <54210D3F.2090409@huawei.com>
 <54210DA5.4040606@huawei.com>
 <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BwJotwpKHYxCNxAnVUjEHIe8XP+xNiu1+JZssEQWoKk=;
        b=uLU8hLcRjfTO+A3QKujAH0ViciXYUZF28vQe5Y8Dei3XJ5erjZRUJgR0xdD5SbYWII
         KB5+j1lV1rUXgmUxFvUgUFZZ/6IWm3xpkvaGtes9DUFau82REgJGMfT7vNrpgJBOM4IB
         m1Dd5iYPOCreF2RF1TWX3Ll7LJAta56bJURXnvQG6gp8Z9/3KSkIXTxISiYfX+2vzZcp
         wbirxW6wVATX94Dp0jmKna18aHy8zZ75FuY/MUzuRw9amN8A2+n+Lmb7HpANIir4yjka
         xRwYa0pV62BlcjstrJl3sPIud0NVCqFLOA5oA6kF2wJ5viL6x7f4OIYcS0I3mM8It1c7
         yOUg==
Content-Disposition: inline
In-Reply-To: <201409231955.FDB73406.FOOJLOVQMHFSFt-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On Tue, Sep 23, 2014 at 07:55:48PM +0900, Tetsuo Handa wrote:
> Zefan Li wrote:
> > Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend
> 
> s/happend/happened/
> 
> > @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
> >  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
> >  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
> >  
> > +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> > +TASK_PFA_SET(SPREAD_PAGE, spread_page)
> > +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> > +
> > +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> > +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> > +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> > +
> 
> I wonder how adding 3 macro lines differs from 3 inlined functions.
> Personally, from LXR (source code browser) point of view, inlined functions
> are more friendly than macros. Also, I wonder about the cost of extracting
> macros in a file which is likely included by every file but referenced
> by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
> as inlined functions in include/linux/cpuset.h rather than as macros in
> include/linux/sched.h ?

I think sched.h is fine along w/ inlines for other flags but yeah we
might be better off just open-coding them.

Thanks.

-- 
tejun

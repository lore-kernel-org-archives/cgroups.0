From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
Date: Fri, 19 Oct 2012 12:49:46 -0700
Message-ID: <20121019194946.GM13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-4-git-send-email-mhocko@suse.cz>
 <20121018221654.GP13370@google.com>
 <20121019132438.GD799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5gjJJOgE6HzKDi3GyHdESwMX5CPXhk1tRVCSLZGVsTE=;
        b=GdgojG0Ftlo/NYNr6NZ8u92wkFMTKR2ecwrPzy9z9foQzuBFKIJSDRnLGUIFE4fZMq
         4jTwuaviIzLlmxM0uZpEPHZp4r6khAFdkQP84Ipfy/fvAJ216J7xX0ncHR+L4U8eKetc
         UdqkGJklSoYAKbanbd9y/y8Fi6fUhSKV5zvF4mxQK278T9AJA5Ob+Q71w33JKrHTmfyp
         tigN82ZNjt6z2w53PwtBswyCfhHGb7bzgyW/dUBwZ68QbXLrfyZu/YEJaGegPNv8XVFG
         dTRIewi1A0NpERjE7m+YcJREM8HlyaWDE/fYqbMVMNIkXLRuPiFUmEOamyXnS55fHkwb
         1ASg==
Content-Disposition: inline
In-Reply-To: <20121019132438.GD799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Michal.

On Fri, Oct 19, 2012 at 03:24:38PM +0200, Michal Hocko wrote:
> > Maybe convert to proper /** function comment while at it?  
> 
> these are internal functions and we usually do not create kerneldoc for
> them. But I can surely change it - it would deserve a bigger clean up
> then.

Yeah, I got into the habit of making function comments kerneldoc if
the function is important / scary enough.  It's upto you but I think
that would be an improvement here.

> What about:
> "
>  * Although this might fail (get_page_unless_zero, isolate_lru_page or
>  * mem_cgroup_move_account fails) the failure is always temporary and
>  * it signals a race with a page removal/uncharge or migration. In the
>  * first case the page is on the way out and it will vanish from the LRU
>  * on the next attempt and the call should be retried later.
>  * Isolation from the LRU fails only if page has been isolated from
>  * the LRU since we looked at it and that usually means either global
>  * reclaim or migration going on. The page will either get back to the
>  * LRU or vanish.
>  * Finaly mem_cgroup_move_account fails only if the page got uncharged
>  * (!PageCgroupUsed) or moved to a different group. The page will
>  * disappear in the next attempt.
> "
> 
> Better? Or should it rather be in the changelog?

Looks good to me and I personally think it deserves to be a comment.

> > Is there anything which can keep failing until migration to another
> > cgroup is complete?  
> 
> This is not about migration to another cgroup. Remember there are no
> tasks in the group so we have no origin for the migration. I was talking
> about migrate_pages.
> 
> > I think there is, e.g., if mmap_sem is busy or memcg is co-mounted
> > with other controllers and another controller's ->attach() is blocking
> > on something.
> 
> I am not sure I understand your concern. There are no tasks and we will
> break out the loop if some appear. And yes we can retry a lot in
> pathological cases. But this is a group removal path which is not hot.

Ah, okay, I misunderstood that it could wait for task cgroup
migration.

> > If so, busy-looping blindly probably isn't a good idea and we would
> > want at least msleep between retries (e.g. have two lists, throw
> > failed ones to the other and sleep shortly when switching the front
> > and back lists).
> 
> we do cond_resched if we fail.

If it won't ever spin for someone else sleeping, I think it should be
fine.

> > Maybe we want to trigger some warning if retry count gets too high?
> > At least for now?
> 
> We can but is this really worth it?

I don't know.  My sense of danger here is likely to be way off
compared to yours so if you think it's a fairly safe loop, it probably
is.

It just reminds me of the busy looping we had in freezer.  It was
correct but actually manifested as a problem - when a system was going
down for emergency hibernation from low battery, that busy loop not
too rarely drained the small reserve making the machine lose power
before completing hibernation.  So, it could be that I'm a bit
paranoid here.

Thanks.

-- 
tejun

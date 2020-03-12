From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v5.6-rc5
Date: Thu, 12 Mar 2020 15:25:34 -0400
Message-ID: <20200312192534.GI79873@mtj.duckdns.org>
References: <20200310144107.GC79873@mtj.duckdns.org>
 <CAHk-=wi=5p6s_BmPAg5EF8Joe5d-6iAjQq6-Le7+xf5Gq-ZTfw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kSRZhT64+sxW9xDyUZ3l/rkvlLGuZc8V6ZIjw4qfv1c=;
        b=c8JNPsVOXsaM4NWGf5pmxx6t2jZJ9I/3H+dCm28qDP91leSkivH4V1ku7Ah5fTzuIr
         mDDxhTl0Z+3F/VqMr32cZhGDAVLTkEfnUpc4To6HefgYByEn9GROeiJp9SWAP5U2KjIi
         CgELBvkumf8LAQpOk8GAtfQaKbCH5SfoCD4YVX05pYHi9SyL8qi5Sne/gvQh3mZNZ1e3
         V6UH2z3SAj3jKoS9kgVFWJKTYWcdHeXVYMBOlkdd2PNfDpqkYnBLFKZiZhOJp4y63QOy
         IASsb0FnjvJnnpl47Dr6siPjMTSjxO7SWShEsI7guYWLZSwqRuwQg61K7PiPPhbEeYrQ
         JhQQ==
Content-Disposition: inline
In-Reply-To: <CAHk-=wi=5p6s_BmPAg5EF8Joe5d-6iAjQq6-Le7+xf5Gq-ZTfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Linus.

On Tue, Mar 10, 2020 at 03:14:13PM -0700, Linus Torvalds wrote:
> On Tue, Mar 10, 2020 at 7:41 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > * Empty release_agent handling fix.
> 
> Pulled. However, I gagged a bit when I saw the code:
> 
>         if (!pathbuf || !agentbuf || !strlen(agentbuf))

Hahaha, yeah, I can see that. I think it might have been copied from
the commit it refers to - 64e90a8acb85 which contains the following
snippet.

       /*
        * If there is no binary for us to call, then just return and get out of
        * here.  This allows us to set STATIC_USERMODEHELPER_PATH to "" and
        * disable all call_usermodehelper() calls.
        */
       if (strlen(sub_info->path) == 0)
               goto out;

> Also, wouldn't it be nice to test for the empty string before you even
> bother to kstrdup() it? Even before you

Let me restructure the code a bit.

> Finally, shouldn't we technically hold the release_agent_path_lock
> while looking at it?

The release_agent_path is protected by both locks - cgroup_mutex and
release_agent_path_lock, so readers can hold either cgroup_mutex or
the path_lock. Here, it's holding the mutex, so it should be fine.
IIRC, it used to be protected by cgroup_mutex (or whatever was
equivalent) and the extra lock was added to break some cyclic
dependency. Hmm... might as well drop the cgroup_mutex protection and
always use the spinlock.

> Small details, and I've taken the pull, but the lack of locking does
> seem to be an actual (if perhaps fairly theoretical) bug, no?

Will queue cleanup patches for the next window.

Thanks.

-- 
tejun

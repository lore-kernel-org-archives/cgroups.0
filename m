From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 00/13] mm: clean up some lru related pieces
Date: Fri, 18 Sep 2020 09:45:49 +0200
Message-ID: <20200918074549.GG28827@dhcp22.suse.cz>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600415150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fw/5e3KjQ1JIQKMCyH0O6Rh1ECmtPNhDeEZeres5Xb4=;
        b=sfui7gRkKIyRKYHVuphifZvgiC4A7ar5kIcwddsQBim9lQg9xNqF5k7WwgFsRi2FhO9QXR
        /LzANXQtSVL28jbiDz87FhuxgDpu/eDrqeAwZsMH6jwiVWML9yHdxu/sMYLPWSzqRywZj1
        xGhIXwj7aVfXu4Dj0sQBJEn7g4fMgaA7PZ4zZ2+VW4RWpSVK4X0NkxviUEgBBYZnguFeYQ
        flfCpBTMvAKzndECK3yIGFCDtuvM32LW7uTC7LpuFkCfmK9NtIGPNXu9SnssvbgK/DcfvD
        itNo+D1sk7aM9rM2I42D66UQcLnKnz0Tr+JyM2PiHigRccWlc0X0s0iQu2JJCw==
Content-Disposition: inline
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-09-20 21:00:38, Yu Zhao wrote:
> Hi Andrew,
> 
> I see you have taken this:
>   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
> Do you mind dropping it?
> 
> Michal asked to do a bit of additional work. So I thought I probably
> should create a series to do more cleanups I've been meaning to.
> 
> This series contains the change in the patch above and goes a few
> more steps farther. It's intended to improve readability and should
> not have any performance impacts. There are minor behavior changes in
> terms of debugging and error reporting, which I have all highlighted
> in the individual patches. All patches were properly tested on 5.8
> running Chrome OS, with various debug options turned on.
> 
> Michal,
> 
> Do you mind taking a looking at the entire series?

I have stopped at patch 3 as all patches until then are really missing
any justification. What is the point for all this to be done? The code
is far from trivial and just shifting around sounds like a risk. You are
removing ~50 LOC which is always nice but I am not sure the resulting
code is better maintainble or easier to read and understand. Just
consider __ClearPageLRU moving to page_off_lru patch. What is the
additional value of having the flag moved and burry it into a function
to have even more side effects? I found the way how __ClearPageLRU is
nicely close to removing it from LRU easier to follow. This is likely
subjective and other might think differently but as it is not clear what
is your actual goal here it is hard to judge pros and cons.

-- 
Michal Hocko
SUSE Labs

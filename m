From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 0/3] mm: push down lock_page_memcg()
Date: Wed, 7 Dec 2022 15:07:18 +0100
Message-ID: <Y5CeFqlMrUyzZL2s@dhcp22.suse.cz>
References: <20221206171340.139790-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670422038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tosjZfZODydjUbuqrfEIBGsRjeHYQJ8iIC4GtSX4HdI=;
        b=Dzp6vahbk3af6y9m0wtHT4j/LM+TyWTrbJIuLUyzPAbc24XF/CBB1eIm3UDK4IGhqwI+mj
        YIpJgQTcYIhAkzTYqDboGt/kD5Qs0wi5JejZgTgYXEQGBipL0FKzPZWbIw15KxDOL4Pufn
        QLs/PPjzoH1pMZyBiKRFSJZzF1m3LC4=
Content-Disposition: inline
In-Reply-To: <20221206171340.139790-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 06-12-22 18:13:38, Johannes Weiner wrote:
> New series based on the discussion in the previous thread around
> getting lock_page_memcg() out of rmap.
> 
> I beat on this with concurrent high-frequency moving of tasks that
> partially share a swapped out shmem file. I didn't spot anything
> problematic. That said, it is quite subtle, and Hugh, I'd feel better
> if you could also subject it to your torture suite ;)

For the whole series
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!
> 
> Thanks!
> 
> Against yesterday's mm-unstable.
> 
>  Documentation/admin-guide/cgroup-v1/memory.rst | 11 ++++-
>  mm/memcontrol.c                                | 56 ++++++++++++++++++------
>  mm/rmap.c                                      | 26 ++++-------
>  3 files changed, 60 insertions(+), 33 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs

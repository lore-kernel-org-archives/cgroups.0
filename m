From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] mm: clean up some lru related pieces
Date: Fri, 18 Sep 2020 03:36:31 -0600
Message-ID: <20200918093631.GA987554@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918074549.GG28827@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ofKvXByFD2eTX9fI7pI8+9B6s6meAkUWiXIy9ZfC+QY=;
        b=QxoMVdbJPeqrTlkx5f/73dhtxLUkgkyN+VruQyO1/DVhy0/tFaAQ+h9OKo3iWOdoAm
         //wddD5q8p90+WGg+WpJ94zSSO7WSg8M7myvdhtMW/wPMxjbFaUz/VVwVUtohFRSSNzk
         1vP3YbOMqaWT/Y8Qpd4XoChQlpnn/p4KVxLPWfl4+D4iZGVaorta3oTQbrw19jtEzHcO
         aSM/mYkvKe/uZTa17hL1VogxRTEkxyUKkzzpjeZ8MZk1SbbnJ5s5a0WQmGjIpQMkQNJV
         +bXdtgXRwCXPz/37ckHEp0MSHu3ks74ZlOBL4iTA1vT8q1rReyNciaVTNptTCYHYonx5
         GR3w==
Content-Disposition: inline
In-Reply-To: <20200918074549.GG28827-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 18, 2020 at 09:45:49AM +0200, Michal Hocko wrote:
> On Thu 17-09-20 21:00:38, Yu Zhao wrote:
> > Hi Andrew,
> > 
> > I see you have taken this:
> >   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
> > Do you mind dropping it?
> > 
> > Michal asked to do a bit of additional work. So I thought I probably
> > should create a series to do more cleanups I've been meaning to.
> > 
> > This series contains the change in the patch above and goes a few
> > more steps farther. It's intended to improve readability and should
> > not have any performance impacts. There are minor behavior changes in
> > terms of debugging and error reporting, which I have all highlighted
> > in the individual patches. All patches were properly tested on 5.8
> > running Chrome OS, with various debug options turned on.
> > 
> > Michal,
> > 
> > Do you mind taking a looking at the entire series?
> 
> I have stopped at patch 3 as all patches until then are really missing
> any justification. What is the point for all this to be done? The code
> is far from trivial and just shifting around sounds like a risk. You are

I appreciate your caution, and if you let me know what exactly your
concerns are, we could probably work them out together.

> removing ~50 LOC which is always nice but I am not sure the resulting
> code is better maintainble or easier to read and understand. Just
> consider __ClearPageLRU moving to page_off_lru patch. What is the
> additional value of having the flag moved and burry it into a function
> to have even more side effects? I found the way how __ClearPageLRU is

Mind elaborating the side effects?

> nicely close to removing it from LRU easier to follow. This is likely
> subjective and other might think differently but as it is not clear what
> is your actual goal here it is hard to judge pros and cons.

I like this specific example from patch 3. Here is what it does: we
have three places using the same boilerplate, i.e., page_off_lru() +
__ClearPageLRU(), the patch moves __ClearPageLRU() into page_off_lru(),
which already does __ClearPageActive() and __ClearPageUnevictable().
Later on, we rename page_off_lru() to __clear_page_lru_flags() (patch
8).

Its point seems quite clear to me. Why would *anybody* want to use
two helper functions *repeatedly* when the job can be done with just
one? Nobody is paid by the number of lines they add, right? :) And
for that matter, why would anybody want any boilerplate to be open
coded from the same group of helper functions arranged in various
ways? I don't think the answer is subjective, but I don't expect
everybody to agree with me.

Now back to your general question: what's the point of this series?
Readability -- less error prone and easier to maintain. This series
consolidate open-coded boilerplate like the following in many places.
Take lru_lazyfree_fn() as an example:

-		bool active = PageActive(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec,
-				       LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
		<snipped>
 		ClearPageSwapBacked(page);
-		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
+		add_page_to_lru_list(page, lruvec);

I hope this helps, but if it doesn't, I'd be more than happy to have
more discussions on the details. And not that I don't appreciate your
review, but please be more specific than 'sounds like a risk' or 'have
even more side effects' so I can address your concerns effectively.

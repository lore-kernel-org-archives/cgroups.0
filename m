From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/13] mm: use page_off_lru()
Date: Mon, 21 Sep 2020 13:16:48 +0200
Message-ID: <20200921111648.GI12990@dhcp22.suse.cz>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918030051.650890-3-yuzhao@google.com>
 <20200918073700.GE28827@dhcp22.suse.cz>
 <20200918102713.GB1004594@google.com>
 <20200918110914.GK28827@dhcp22.suse.cz>
 <20200918185358.GA1095986@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600687010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTczP/zLHBRx8LMrv/lg4UZ5y7Ccak5p+2XPXjz+ei4=;
        b=FRXjcj2dlbs+GhpPvSSoGBVWXvzIC1b9rlv+jCncvGTtBLvTv3T5jSHPx2q5Os1BhdzptT
        5eLVfdY5B+2480xmbVUvYe/zoz6qSJR+pUU/wk4ZG0u1yY1V2yVANeBb0oSVKxhTo9zlli
        D1mju4Ky9UwEuAJUveyXXxGqRqpNr8o=
Content-Disposition: inline
In-Reply-To: <20200918185358.GA1095986-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 18-09-20 12:53:58, Yu Zhao wrote:
> On Fri, Sep 18, 2020 at 01:09:14PM +0200, Michal Hocko wrote:
> > On Fri 18-09-20 04:27:13, Yu Zhao wrote:
> > > On Fri, Sep 18, 2020 at 09:37:00AM +0200, Michal Hocko wrote:
> > > > On Thu 17-09-20 21:00:40, Yu Zhao wrote:
> > > > > This patch replaces the only open-coded __ClearPageActive() with
> > > > > page_off_lru(). There is no open-coded __ClearPageUnevictable()s.
> > > > > 
> > > > > Before this patch, we have:
> > > > > 	__ClearPageActive()
> > > > > 	add_page_to_lru_list()
> > > > > 
> > > > > After this patch, we have:
> > > > > 	page_off_lru()
> > > > > 		if PageUnevictable()
> > > > > 			__ClearPageUnevictable()
> > > > > 		else if PageActive()
> > > > > 			__ClearPageActive()
> > > > > 	add_page_to_lru_list()
> > > > > 
> > > > > Checking PageUnevictable() shouldn't be a problem because these two
> > > > > flags are mutually exclusive. Leaking either will trigger bad_page().
> > > > 
> > > > I am sorry but the changelog is really hard to grasp. What are you
> > > > trying to achieve, why and why it is safe. This should be a general
> > > > outline for any patch. I have already commented on the previous patch
> > > > and asked you for the explanation why removing __ClearPageActive from
> > > > this path is desirable and safe. I have specifically asked to clarify
> > > > the compound page situation as that is using its oen destructor in the
> > > > freeing path and that might result in page_off_lru to be not called.
> > > 
> > > Haven't I explained we are NOT removing __ClearPageActive()? Is my
> > > notion of the code structure above confusing you? Or 'open-coded'
> > > could mean different things?
> > 
> > Please read through my reply carefuly. I am not saying what you are
> > doing is wrong. I am expressing a lack of justification which is the
> > case throughout this patch series. You do not explain why we need it and
> > why reviewers should spend time on this. Because the review is not as
> > trivial as looking at the diff.
> 
> I appreciate your time. But if you are looking for some grand
> justification, I'm afraid I won't be able to give one, because, as it's
> titled, this is just a series of cleanup patches.

You likely had some reason to do that clean up, right? What was that? An
inconcistency in handling some of the page flags when it is moved around
LRU lists? Was the code too hard to reason about? Was it error prone?

Please do not take me wrong, I am not trying to discourage you from
clean up work. There is a lot of code that would benefit from clean ups.
But it certainly helps to outline your motivation and the goal you would
like to achieve. Without that it would boil down to guessing what you
might have thought or simly moving things around without a very good
long term reason.

Thanks!
-- 
Michal Hocko
SUSE Labs

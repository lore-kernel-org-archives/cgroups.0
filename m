From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Thu, 8 Jul 2021 09:28:21 +0200
Message-ID: <YOapFVzNhSgnN/tM@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
 <YNwsAh5u2h34tGDb@dhcp22.suse.cz>
 <YOXD+TVkAeWmjLxX@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625729302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=17LWgY1lhwnG10GPb9Rqj76fsBzvfjmM5lbcUo6gvVI=;
        b=Uw4AoXNSjnjAxhH0BbMXmIpo5cwyH7inw0BupZ8ZrmMINW5o3MMukZRtAyUTtg0uLnFh/x
        TFUwG0oFkek/lO57V9WITuUkWQfTIi4XJ4g9+sBzLLpC8JTMf31+0sAiWr1ik/nXg4i8g5
        ZlDm3yNFJw+mbnmEXIbO3Z1LSUhdqIk=
Content-Disposition: inline
In-Reply-To: <YOXD+TVkAeWmjLxX-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 07-07-21 16:10:49, Matthew Wilcox wrote:
[...]
> > I do not really want to be annoying here but I have to say that I like
> > the conversion by previous patches much better than this wrapper
> > approach as mentioned during the previous review already. If you have
> > some reasons to stick with this approach for this particular case then
> > make it explicit in the changelog.
> 
> OK, I can point to the number of callers as a reason to keep the
> wrappers in place.  I intended to just do the conversion here, but
> seeing the number of callers made me reconsider.

OK, fair enough. My worry is that we will have this lingering for way
too long. People simply tend to copy code... Anyway, please add a
comment warning that the wrapper shouldn't be used in any new code at
least.

Thanks!
-- 
Michal Hocko
SUSE Labs

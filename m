From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Tue, 29 Nov 2022 23:33:14 -0800 (PST)
Message-ID: <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com> <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5AgzOj8U3caSyuY1WKQWxWsXylIKB3XS8A98MNnMeTI=;
        b=lq99lhtWYhivFicKBQg0Prv5DJ+v/2lt7NSJFbq3rAUCzXgv+KNkTw/xhiyUZyKfqu
         uMf2C6OYW5swfdUEuSNfmToqqQCvapyvBEvoLa9I53Ndv6qYYJWQY1NpXdK/DMep/mGR
         7L8Hl0Jzaihv1Ny3msUYGt7QI5CzigbfwEtDso150EN9K4k5WTZ9i+5r39ViwHjdPomi
         1qHBXQNIab2fmYZH+82qfFqdeSinNLbxsAAnnMs/3YJ53sHZ4wwReZDqH1eYS1Phyuy+
         zs+pAc+bZtQT8h0FP0tZDi452jQmcPX/LjIw/UdtMpkH4O4GqO+i6KRtz8XtJ1Ob46e0
         h35w==
In-Reply-To: <Y4ZYsrXLBFDIxuoO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 29 Nov 2022, Johannes Weiner wrote:
> On Mon, Nov 28, 2022 at 11:59:53AM -0500, Johannes Weiner wrote:
> > On Wed, Nov 23, 2022 at 10:03:00PM -0800, Hugh Dickins wrote:
> > The swapcache/pagecache bit was a brainfart. We acquire the folio lock
> > in move_account(), which would lock out concurrent faults. If it's not
> > mapped, I don't see how it could become mapped behind our backs. But
> > we do need to be prepared for it to be unmapped.
> 
> Welp, that doesn't protect us from the inverse, where the page is
> mapped elsewhere and the other ptes are going away. So this won't be
> enough, unfortunately.
> 
> > > Does that mean that we just have to reinstate the folio_mapped() checks
> > > in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
> > > commit?  Or does it invalidate the whole project to remove
> > > lock_page_memcg() from mm/rmap.c?
> 
> Short of further restricting the pages that can be moved, I don't see
> how we can get rid of the cgroup locks in rmap after all. :(
> 
> We can try limiting move candidates to present ptes. But maybe it's
> indeed time to deprecate the legacy charge moving altogether, and get
> rid of the entire complication.
> 
> Hugh, Shakeel, Michal, what do you think?

I'm certainly not against deprecating it - it's a largish body of odd
code, which poses signficant problems, yet is very seldom used; but I
feel that we'd all like to see it gone from rmap quicker that it can
be fully deprecated out of existence.

I do wonder if any user would notice, if we quietly removed its
operation on non-present ptes; certainly there *might* be users
relying on that behaviour, but I doubt that many would.

Alternatively (although I think Linus's objection to it in rmap is on
both aesthetic and performance grounds, and retaining any trace of it
in rmap.c still fails the aesthetic), can there be some static-keying
done, to eliminate (un)lock_page_memcg() overhead for all but those few
who actually indulge in moving memcg charge at immigrate?  (But I think
you would have already done that if it were possible.)

Hugh

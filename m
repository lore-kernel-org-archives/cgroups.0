From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/18] mm: memcontrol: drop @compound parameter from
 memcg charging API
Date: Wed, 22 Apr 2020 15:37:00 +0900
Message-ID: <20200422063659.GC6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5sPywIAZDU2flYyDIq+uLr1t/vlUGNE5qQ6q2icgX/U=;
        b=iuvvnEZydRgcq1Z4TUJreYmlRt+sDrNv+6pNyoY30/hH0jp9bzYa4PgigR0HeZigW/
         UeUbY4E+IqKrpvjloRy8LUuBHCH0mo5ESeOr1ieFkeMods47eHkBBwA3ZZ5cGFQgjJnW
         mfaw0JE185YwVfJ/9AOZQDjc69yc8QcivrulSEbX4VKZKUyS/aVx2FQKOgfERe7SqKoI
         /xTBhLF92vinPrne/b96oDFEbEx8S/kA7U86CV/5GjXMVsYn1gs9LR7SFEhPxJr5QGAb
         PEJwNERbqxn4DZM7azcgmaOFn+S03cJb9L+KVrjYxeMVI4pPkk5ogMeU/NNkvICMN4cD
         6KAg==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:11PM -0400, Johannes Weiner wrote:
> The memcg charging API carries a boolean @compound parameter that
> tells whether the page we're dealing with is a hugepage.
> mem_cgroup_commit_charge() has another boolean @lrucare that indicates
> whether the page needs LRU locking or not while charging. The majority
> of callsites know those parameters at compile time, which results in a
> lot of naked "false, false" argument lists. This makes for cryptic
> code and is a breeding ground for subtle mistakes.
> 
> Thankfully, the huge page state can be inferred from the page itself
> and doesn't need to be passed along. This is safe because charging
> completes before the page is published and somebody may split it.
> 
> Simplify the callsites by removing @compound, and let memcg infer the
> state by using hpage_nr_pages() unconditionally. That function does
> PageTransHuge() to identify huge pages, which also helpfully asserts
> that nobody passes in tail pages by accident.
> 
> The following patches will introduce a new charging API, best not to
> carry over unnecessary weight.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

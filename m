From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch v4] Soft limit rework
Date: Tue, 4 Jun 2013 18:38:28 +0200
Message-ID: <20130604163828.GA9321@dhcp22.suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qE0xQo65HVek8o1iifXYAQ85rBu2tQ+lWiZob9zcMmU=;
        b=IFWeQ4guWNybD+seghhUznyNA2124cYHUxZNAS6SyBYY4MGhLMU0S6p5ALx29L5zaA
         pRlg+ri/XR0QT9Pwud2Hc0JJD14USYAt0TcPdwye8rXrY38MwWlRvqEcu44A320PVebO
         RA7TyTLbHOqvX/ZRSuwA0pqbH8d1Lc6Sb5vMdD18M9Wq0LMg8oVFCFwKm8el9rABb610
         masPEPX42FMVI1h6vkFcZgxtD68MIOKQ+RhFgXPQzX5FjNameGWyUnJRxJjuUItWZGmm
         jEjGxHGCnjGYv9garOLKkLJ/AVyjduQde37UicAXdraRI3gP1Jwrz7p4wxbEdg/pH100
         11sw==
Content-Disposition: inline
In-Reply-To: <CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>

On Tue 04-06-13 21:57:56, Balbir Singh wrote:
> On Mon, Jun 3, 2013 at 3:48 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > Hi,
> >
> > This is the fourth version of the patchset.
> >
> > Summary of versions:
> > The first version has been posted here: http://permalink.gmane.org/gmane.linux.kernel.mm/97973
> > (lkml wasn't CCed at the time so I cannot find it in lwn.net
> > archives). There were no major objections. The second version
> > has been posted here http://lwn.net/Articles/548191/ as a part
> > of a longer and spicier thread which started after LSF here:
> > https://lwn.net/Articles/548192/
> > Version number 3 has been posted here http://lwn.net/Articles/550409/
> > Johannes was worried about setups with thousands of memcgs and the
> > tree walk overhead for the soft reclaim pass without anybody in excess.
> >
> > Changes between RFC (aka V1) -> V2
> > As there were no major objections there were only some minor cleanups
> > since the last version and I have moved "memcg: Ignore soft limit until
> > it is explicitly specified" to the end of the series.
> >
> > Changes between V2 -> V3
> > No changes in the code since the last version. I have just rebased the
> > series on top of the current mmotm tree. The most controversial part
> > has been dropped (the last patch "memcg: Ignore soft limit until it is
> > explicitly specified") so there are no semantical changes to the soft
> > limit behavior. This makes this work mostly a code clean up and code
> > reorganization. Nevertheless, this is enough to make the soft limit work
> > more efficiently according to my testing and groups above the soft limit
> > are reclaimed much less as a result.
> >
> > Changes between V3->V4
> > Added some Reviewed-bys but the biggest change comes from Johannes
> > concern about the tree traversal overhead with a huge number of memcgs
> > (http://thread.gmane.org/gmane.linux.kernel.cgroups/7307/focus=100326)
> > and this version addresses this problem by augmenting the memcg tree
> > with the number of over soft limit children at each level of the
> > hierarchy. See more bellow.
> >
> > The basic idea is quite simple. Pull soft reclaim into shrink_zone in
> > the first step and get rid of the previous soft reclaim infrastructure.
> > shrink_zone is done in two passes now. First it tries to do the soft
> > limit reclaim and it falls back to reclaim-all mode if no group is over
> > the limit or no pages have been scanned. The second pass happens at the
> > same priority so the only time we waste is the memcg tree walk which
> > has been updated in the third step to have only negligible overhead.
> >
> 
> Hi, Michal
> 
> I've just looked at this (I am yet to review the series), but the
> intention of the changes do not read out clearly. Or may be I quite
> outdated on the subject :)

OK, let me summarize. The primary intention is to get rid of the current
soft reclaim infrastructure which basically bypasses the standard
reclaim and tight it directly into shrink_zone code. This also means
that the soft reclaim doesn't reclaim at priority 0 and that it is
active also for the targeted (aka limit) reclaim.

Does this help?
 
> Balbir

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

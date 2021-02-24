From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Wed, 24 Feb 2021 12:53:35 +0100
Message-ID: <YDY+PydRUGQpHNaJ@dhcp22.suse.cz>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
 <YDNuAIztiGJpLEtw@dhcp22.suse.cz>
 <e132f836-b5d5-3776-22d6-669e713983e4@linux.intel.com>
 <YDQBh5th9txxEFUm@dhcp22.suse.cz>
 <cf5ca7a1-7965-f307-22e1-e216316904cf@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614167617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XzLsHGcL8bQEwd8q77IJXXPxrQFmDs82g85prap2dQ4=;
        b=nXir09DKObx9wu/my6Ugn5gdRgCXHFR7PCmDobwcx3KpR14Hr90pvWZwBEJmLtYJWI0B6R
        /7z86SKpQROZRhKPQ27B778WIRwrt3MZQrt6wYpdGaX1fLA4BtZg0qAxf16zW7CAYZFcpg
        onHSk/VsZtl2Lnilzk6yEZSaiE8fcvk=
Content-Disposition: inline
In-Reply-To: <cf5ca7a1-7965-f307-22e1-e216316904cf-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 22-02-21 11:48:37, Tim Chen wrote:
> 
> 
> On 2/22/21 11:09 AM, Michal Hocko wrote:
> 
> >>
> >> I actually have tried adjusting the threshold but found that it doesn't work well for
> >> the case with unenven memory access frequency between cgroups.  The soft
> >> limit for the low memory event cgroup could creep up quite a lot, exceeding
> >> the soft limit by hundreds of MB, even
> >> if I drop the SOFTLIMIT_EVENTS_TARGET from 1024 to something like 8.
> > 
> > What was the underlying reason? Higher order allocations?
> > 
> 
> Not high order allocation.
> 
> The reason was because the run away memcg asks for memory much less often, compared
> to the other memcgs in the system.  So it escapes the sampling update and
> was not put onto the tree and exceeds the soft limit
> pretty badly.  Even if it was put onto the tree and gets page reclaimed below the
> limit, it could escape the sampling the next time it exceeds the soft limit.

I am sorry but I really do not follow. Maybe I am missing something
obvious but the the rate of events (charge/uncharge) shouldn't be really
important. There is no way to exceed the limit without charging memory
(either a new or via task migration in v1 and immigrate_on_move). If you
have SOFTLIMIT_EVENTS_TARGET 8 then you should be 128 * 8 events to
re-evaluate. Huge pages can make the runaway much bigger but how it
would be possible to runaway outside of that bound.

Btw. do we really need SOFTLIMIT_EVENTS_TARGET at all? Why cannot we
just stick with a single threshold? mem_cgroup_update_tree can be made
a effectivelly a noop when there is no soft limit in place so overhead
shouldn't matter for the vast majority of workloads.
-- 
Michal Hocko
SUSE Labs

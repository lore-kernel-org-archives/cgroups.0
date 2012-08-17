From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Fri, 17 Aug 2012 12:35:50 +0200
Message-ID: <20120817103550.GF18600@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-10-git-send-email-glommer@parallels.com>
 <20120817090005.GC18600@dhcp22.suse.cz>
 <502E0BC3.8090204@parallels.com>
 <20120817093504.GE18600@dhcp22.suse.cz>
 <502E17C4.7060204@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <502E17C4.7060204-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 17-08-12 14:07:00, Glauber Costa wrote:
> On 08/17/2012 01:35 PM, Michal Hocko wrote:
> >>> Above you said "Once enabled, can't be disabled." and now you can
> >>> > > disable it? Say you are a leaf group with non accounted parents. This
> >>> > > will clear the flag and so no further accounting is done. Shouldn't
> >>> > > unlimited mean that we will never reach the limit? Or am I missing
> >>> > > something?
> >>> > >
> >> > 
> >> > You are missing something, and maybe I should be more clear about that.
> >> > The static branches can't be disabled (it is only safe to disable them
> >> > from disarm_static_branches(), when all references are gone). Note that
> >> > when unlimited, we flip bits, do a transversal, but there is no mention
> >> > to the static branch.
> > My little brain still doesn't get this. I wasn't concerned about static
> > branches. I was worried about memcg_can_account_kmem which will return
> > false now, doesn't it.
> > 
> 
> Yes, it will. If I got you right, you are concerned because I said that
> can't happen. But it will.
> 
> But I never said that can't happen. I said (ok, I meant) the static
> branches can't be disabled.

Ok, then I misunderstood that because the comment was there even before
static branches were introduced and it made sense to me. This is
inconsistent with what we do for user accounting because even if we set
limit to unlimitted we still account. Why should we differ here?

-- 
Michal Hocko
SUSE Labs

From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: clean up alloc, online, offline, free
 functions fix
Date: Thu, 17 Dec 2015 11:39:31 +0300
Message-ID: <20151217083931.GM28521@esperanza>
References: <1450312460-27582-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450312460-27582-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Dec 16, 2015 at 07:34:20PM -0500, Johannes Weiner wrote:
> Fixlets based on review feedback from Vladimir:
> 
> 1. The memcg_create_mutex is to stabilize a cgroup's hereditary
>    settings that are not allowed to change once the cgroup has
>    children: kmem accounting and hierarchy mode. However, the cleanup
>    patch moves inheritance of these settings from onlining time to
>    allocation time, before the new child will show up in the parent's
>    list of children, and this opens a race window where the parent can
>    change a setting that has been passed on to a new child already.
> 
>    That being said, this rule for kmem and hierarchy mode is somewhat
>    gratuitous: there is no strong reason why these configurations
>    shouldn't exist, and the outcome of a race is not harmful. It's
>    also unlikely that somebody will even trigger this race because we
>    don't expect anybody to flip-flop either settings while creating
>    child groups. So instead of readding complexity to close an
>    unlikely race window that doesn't do any harm, simply remove the
>    now pointless mutex as a follow-up cleanup.
> 
> 2. Kmem initialization consists of several steps that are undone in
>    both css_offline() and css_free(). However, if css allocation fails
>    later on then css_offline() is never called and we don't properly
>    free the kmem state. Let css_free() detect this and call kmem
>    offlining itself.
> 
> 3. Children in !use_hierarchy mode would inherit the OOM killer
>    setting from their physical parent rather than the logical parent,
>    rootmemcg.  This is silly, but no reason to change the semantics as
>    part of this cleanup patch, so restore it.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Tue, 1 Aug 2023 11:54:47 +0200
Message-ID: <ZMjWZwYkhxSNLU+q@dhcp22.suse.cz>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1690883687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wO63J1EyZpemnTVHqFZ8CyKvSylFpCyQaYjDytJ5JcI=;
        b=Xm1y6TPV+ft2mgHUEs0a4S+VBf8IeVMT2AHrnpwxVYWrl3VVPM27WCA62GEGULwRhG07+U
        n0QYWPeJiNSw5BddFNX4NloFWNI0P/eu+VT8/XaOjKnQpON2VvvYJD09cUF5gpKij+y1c4
        5kP2fChggBnUHXhaJts/jfCsA5DAVGc=
Content-Disposition: inline
In-Reply-To: <20230720153515.GA1003248-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[Sorry for being late to this discussion]

On Thu 20-07-23 11:35:15, Johannes Weiner wrote:
[...]
> I'm super skeptical of this proposal.

Agreed.
 
> Recharging *might* be the most desirable semantics from a user pov,
> but only if it applies consistently to the whole memory footprint.
> There is no mention of slab allocations such as inodes, dentries,
> network buffers etc. which can be a significant part of a cgroup's
> footprint. These are currently reparented. I don't think doing one
> thing with half of the memory, and a totally different thing with the
> other half upon cgroup deletion is going to be acceptable semantics.
> 
> It appears this also brings back the reliability issue that caused us
> to deprecate charge moving. The recharge path has trylocks, LRU
> isolation attempts, GFP_ATOMIC allocations. These introduce a variable
> error rate into the relocation process, which causes pages that should
> belong to the same domain to be scattered around all over the place.
> It also means that zombie pinning still exists, but it's now even more
> influenced by timing and race conditions, and so less predictable.
> 
> There are two issues being conflated here:
> 
> a) the problem of zombie cgroups, and
> 
> b) who controls resources that outlive the control domain.
> 
> For a), reparenting is still the most reasonable proposal. It's
> reliable for one, but it also fixes the problem fully within the
> established, user-facing semantics: resources that belong to a cgroup
> also hierarchically belong to all ancestral groups; if those resources
> outlive the last-level control domain, they continue to belong to the
> parents. This is how it works today, and this is how it continues to
> work with reparenting. The only difference is that those resources no
> longer pin a dead cgroup anymore, but instead are physically linked to
> the next online ancestor. Since dead cgroups have no effective control
> parameters anymore, this is semantically equivalent - it's just a more
> memory efficient implementation of the same exact thing.
> 
> b) is a discussion totally separate from this. We can argue what we
> want this behavior to be, but I'd argue strongly that whatever we do
> here should apply to all resources managed by the controller equally.
> 
> It could also be argued that if you don't want to lose control over a
> set of resources, then maybe don't delete their control domain while
> they are still alive and in use. For example, when restarting a
> workload, and the new instance is expected to have largely the same
> workingset, consider reusing the cgroup instead of making a new one.
> 
> For the zombie problem, I think we should merge Muchun's patches
> ASAP. They've been proposed several times, they have Roman's reviews
> and acks, and they do not change user-facing semantics. There is no
> good reason not to merge them.

Yes, fully agreed on both points. The problem with zombies is real but
reparenting should address it for a large part. Ownership is a different
problem. We have discussed that at LSFMM this year and in the past as
well I believe. What we probably need is a concept of taking an
ownership of the memory (something like madvise(MADV_OWN, range) or
fadvise for fd based resources). This would allow the caller to take
ownership of the said resource (like memcg charge of it).

I understand that would require some changes to existing workloads.
Whatever the interface will be, it has to be explicit otherwise we
are hitting problems with unaccounted resources that are sitting without
any actual ownership and an undeterministic and time dependeing hopping
over owners. In other words, nobody should be able to drop
responsibility of any object while it is still consuming resources.

-- 
Michal Hocko
SUSE Labs

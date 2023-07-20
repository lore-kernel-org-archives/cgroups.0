From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 11:35:15 -0400
Message-ID: <20230720153515.GA1003248@cmpxchg.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1689867318; x=1690472118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1n+rFJmpt3qB6JDh31e2VoNgqrjqEMhcmnlZeysYmYE=;
        b=4k9D+J7Kpdc0v2PabFm8Hmk1Rg0EfWw4RPCEG+efTc4WtuWKXjt/fnBhLoqCeZE2tu
         ZJZgFzOafPl7KmThIItTT/LAYNvIuj4QKYPs3Y/WUaerPCDvtD8AbSYxdJBV6gq7erZ0
         QkSqfy+6llSiQFqdoU+Kj0piE8M5QnD+2ORQ6bx9iEqn54wsDOFBvtj9QYGtnMZTZ8U7
         KfVsmYYL0Ey+U08VcwemcoYSxU65LDlXnWhRO97b+vEfwHygN164fwsiag0Q4Bu72//P
         +QQgOU1mJjt87DcTNtsI3PcXd+3/ZgW182eFDepQugrD6/ju3NE4lu6THcTcE7LkVK6j
         uHUA==
Content-Disposition: inline
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 20, 2023 at 07:08:17AM +0000, Yosry Ahmed wrote:
> This patch series implements the proposal in LSF/MM/BPF 2023 conference
> for reducing offline/zombie memcgs by memory recharging [1]. The main
> difference is that this series focuses on recharging and does not
> include eviction of any memory charged to offline memcgs.
> 
> Two methods of recharging are proposed:
> 
> (a) Recharging of mapped folios.
> 
> When a memcg is offlined, queue an asynchronous worker that will walk
> the lruvec of the offline memcg and try to recharge any mapped folios to
> the memcg of one of the processes mapping the folio. The main assumption
> is that a process mapping the folio is the "rightful" owner of the
> memory.
> 
> Currently, this is only supported for evictable folios, as the
> unevictable lru is imaginary and we cannot iterate the folios on it. A
> separate proposal [2] was made to revive the unevictable lru, which
> would allow recharging of unevictable folios.
> 
> (b) Deferred recharging of folios.
> 
> For folios that are unmapped, or mapped but we fail to recharge them
> with (a), we rely on deferred recharging. Simply put, any time a folio
> is accessed or dirtied by a userspace process, and that folio is charged
> to an offline memcg, we will try to recharge it to the memcg of the
> process accessing the folio. Again, we assume this process should be the
> "rightful" owner of the memory. This is also done asynchronously to avoid
> slowing down the data access path.

I'm super skeptical of this proposal.

Recharging *might* be the most desirable semantics from a user pov,
but only if it applies consistently to the whole memory footprint.
There is no mention of slab allocations such as inodes, dentries,
network buffers etc. which can be a significant part of a cgroup's
footprint. These are currently reparented. I don't think doing one
thing with half of the memory, and a totally different thing with the
other half upon cgroup deletion is going to be acceptable semantics.

It appears this also brings back the reliability issue that caused us
to deprecate charge moving. The recharge path has trylocks, LRU
isolation attempts, GFP_ATOMIC allocations. These introduce a variable
error rate into the relocation process, which causes pages that should
belong to the same domain to be scattered around all over the place.
It also means that zombie pinning still exists, but it's now even more
influenced by timing and race conditions, and so less predictable.

There are two issues being conflated here:

a) the problem of zombie cgroups, and

b) who controls resources that outlive the control domain.

For a), reparenting is still the most reasonable proposal. It's
reliable for one, but it also fixes the problem fully within the
established, user-facing semantics: resources that belong to a cgroup
also hierarchically belong to all ancestral groups; if those resources
outlive the last-level control domain, they continue to belong to the
parents. This is how it works today, and this is how it continues to
work with reparenting. The only difference is that those resources no
longer pin a dead cgroup anymore, but instead are physically linked to
the next online ancestor. Since dead cgroups have no effective control
parameters anymore, this is semantically equivalent - it's just a more
memory efficient implementation of the same exact thing.

b) is a discussion totally separate from this. We can argue what we
want this behavior to be, but I'd argue strongly that whatever we do
here should apply to all resources managed by the controller equally.

It could also be argued that if you don't want to lose control over a
set of resources, then maybe don't delete their control domain while
they are still alive and in use. For example, when restarting a
workload, and the new instance is expected to have largely the same
workingset, consider reusing the cgroup instead of making a new one.

For the zombie problem, I think we should merge Muchun's patches
ASAP. They've been proposed several times, they have Roman's reviews
and acks, and they do not change user-facing semantics. There is no
good reason not to merge them.

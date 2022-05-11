From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Wed, 11 May 2022 18:34:39 +0200
Message-ID: <20220511163439.GD24172@blackbody.suse.cz>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
 <YnsoMEuWjlpDcmt3@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652286880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2JoTxCuGT/XwmSwU+DDVolsXEflHmN6heyJDe9s6Lc8=;
        b=CUkd58Keel+pNaWn+KYfxSYFopIDQDKGU3PoRCjYzjYA13p/vREkGqB+N7B6dnrAbP0OUH
        UgN9xcN9ryoxwKytW0/dcicFGuLYVDNSMVS7cyFxSnp+8lCv7Nr/tgx3tn2JfRg3TITSdt
        xKGuvz/T96eKVUHLlFlJcs+fWsGNMCQ=
Content-Disposition: inline
In-Reply-To: <YnsoMEuWjlpDcmt3@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, May 10, 2022 at 08:06:24PM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> My primary goal was to apply the memory pressure on memory cgroups with a lot
> of (dying) children cgroups. On a multi-cpu machine a memory cgroup structure
> is way larger than a page, so a cgroup which looks small can be really large
> if we calculate the amount of memory taken by all children memcg internals.
> 
> Applying this pressure to another cgroup (e.g. the one which contains systemd)
> doesn't help to reclaim any pages which are pinning the dying cgroups.

Just a note -- this another usecase of cgroups created from within the
subtree (e.g. a container). I agree that cgroup-manager/systemd case is
also valid (as dying memcgs may accumulate after a restart).

memcgs with their retained state with footprint are special.

> For other controllers (maybe blkcg aside, idk) it shouldn't matter, because
> there is no such problem there.
> 
> For consistency reasons I'd suggest to charge all *large* allocations
> (e.g. percpu) to the parent cgroup. Small allocations can be ignored.

Strictly speaking, this would mean that any controller would have on
implicit dependency on the memory controller (such as io controller
has).
In the extreme case even controller-less hierarchy would have such a
requirement (for precise kernfs_node accounting).
Such a dependency is not enforceable on v1 (with various topologies of
different hierarchies).
Although, I initially favored the consistency with memory controller too,
I think it's simpler to charge to the creator's memcg to achieve
consistency across v1 and v2 :-) 

Michal

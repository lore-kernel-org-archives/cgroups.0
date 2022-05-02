From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Mon, 2 May 2022 23:22:09 +0200
Message-ID: <YnBLge4ZQNbbxufc@blackbook>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651526564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDk2qkB7YUEj5NtH1MO7nyXZonZFY6nq6FEdcA71x/0=;
        b=TFavIqNrXC1pDmJRQ9csR4iHTIfSyLzehksOi+Bx2aYpRS8C9cf2HWN76ikfgpQoHGnF98
        MBaZcccVCtS9nVins+KeqsL0JB+bXpGE8XLV6sNEqyQWywmiUNhUmKGrSnW0t+eLcjLETo
        m/b8vfqOSuc+TKbc7gomqJt311lOB6A=
Content-Disposition: inline
In-Reply-To: <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello.

On Mon, May 02, 2022 at 10:37:49PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> I did not understand your statement. Could you please explain it in more details?

Sure, let me expand my perhaps ambiguous and indefinite sentence.

> I see that cgroup_mkdir()->cgroup_create() creates new kernfs node for new
> sub-directory, and with my patch account memory of kernfs node to memcg 
> of current process.

Indeed. The variants I'm comparing here are: a) charge to the creator's
memcg, b) charge to the parent (memcg ancestor) of created cgroup.

When struct mem_cgroup charging was introduced, there was a similar
discussion [1].

I can see following aspects here:
1) absolute size of kernfs_objects,
2) practical difference between a) and b),
3) consistency with memcg,
4) v1 vs v2 behavior.

Ad 1) -- normally, I'd treat this as negligible (~120B struct
kernfs_node * there are ~10 of them per subsys * ~10 subsystems ~ 12
KB/cgroup). But I guess the point of this change are exploitative users
where this doesn't hold [2], so absolute size is not so important.

Ad 2) -- in the typical workloads, only top-level cgroup are created by
some management entity and lower level are managed from within, i.e.
there is little difference whom to charge the created objects.

Ad 3) -- struct mem_cgroup objects are charged to their hierarchical
parent, so that dying memcgs can be associated to a subtree which is
where the reclaim can deal with it (in contrast with creator's cgroup).

Now, if I'm looking correctly, the kernfs_node objects are not pinned by
any residual state (subsystems kill_css()->css_clear_dir() synchronously
from rmdir, cgroup itself may be RCU delayed). So the memcg argument
remains purely for consistency (but no practical reason).

Ad 4) -- the variant b) becomes slightly awkward when mkdir'ing a cgroup
in a non-memcg hierarchy (bubbles up to root, despite creator in a
non-root memcg).

How do these reasonings align with your original intention of net
devices accounting? (Are the creators of net devices inside the
container?)


> Do you think it is incorrect and new kernfs node should be accounted
> to memcg of parent cgroup, as mem_cgroup_css_alloc()-> mem_cgroup_alloc() does?

I don't think either variant is incorrect. I'd very much prefer the
consistency with memcg behavior (variant a)) but as I've listed the
arguments above, it seems such a consistency can't be easily justified.


> Perhaps you mean that in this case kernfs should not be counted at all,
> as almost all neighboring allocations do?

No, I think it wouldn't help here [2]. (Or which neighboring allocations
do you mean? There must be at least nr_cgroups of them.)

(Of course, then there's the traditional performance argument, cgroup's
kernfs_node object shouldn't be problematic but I can't judge others
(sysfs) but that's nothing to prevent any form of kernfs_node accounting
going forward in my eyes.)

HTH,
Michal

[1] https://lore.kernel.org/all/20200729171039.GA22229-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org/
[2] Unless this could be constraint by something even bigger and
accounted. But only struct mem_cgroup (recursively its percpu stats)
comes to my mind.


From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Wed, 11 May 2022 18:49:45 +0200
Message-ID: <20220511164945.GA31592@blackbody.suse.cz>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
 <YnsoMEuWjlpDcmt3@carbon>
 <0eec6575-548e-23e0-0d99-4e079a33d338@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652287787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BT7PhFjb0yfnX8Jyg1myJFbP9avxJpO8kwYrkhn3Qao=;
        b=Rqw7tlXYAK6aOCv5cU2S5SjeLkNYuQNaHQjxOxoinQtMjkhzD4QD7va4YazZecdAXkcqd0
        hI8qsZ9LllH1OeY0mt/7zDJAI90AYjelKRQkzXYfT5rpLBqATrF3Uwbsysu1bjmOWYfnWM
        dAojk1ZewHtUCFuM7IjkVl+KdZmRADY=
Content-Disposition: inline
In-Reply-To: <0eec6575-548e-23e0-0d99-4e079a33d338-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, May 11, 2022 at 09:01:40AM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> number	bytes	$1*$2	sum	note	call_site
> of	alloc
> allocs
> ------------------------------------------------------------
> 1       14448   14448   14448   =       percpu_alloc_percpu:
> 1       8192    8192    22640   ++      (mem_cgroup_css_alloc+0x54)

This requires just adding GFP_KERNEL_ACCOUNT (no new active memcg
switch).

> 49      128     6272    28912   ++      (__kernfs_new_node+0x4e)
> 49      96      4704    33616   ?       (simple_xattr_alloc+0x2c)
> 49      88      4312    37928   ++      (__kernfs_iattrs+0x56)
> 1       4096    4096    42024   ++      (cgroup_mkdir+0xc7)
> 1       3840    3840    45864   =       percpu_alloc_percpu:
> 4       512     2048    47912   +       (alloc_fair_sched_group+0x166)
> 4       512     2048    49960   +       (alloc_fair_sched_group+0x139)
> 1       2048    2048    52008   ++      (mem_cgroup_css_alloc+0x109)
> "
> [1] https://lore.kernel.org/all/1aa4cd22-fcb6-0e8d-a1c6-23661d618864-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
> =	already accounted
> ++	to be accounted first
> +	to be accounted a bit later
> 
> There is no problems with objects allocated in mem_cgroup_alloc(),
> they will be accounted to parent's memcg.
> However I do not understand how to handle other large objects?
> 
> We could move set_active_memcg(parent) call from mem_cgroup_css_alloc() 
> to cgroup_apply_control_enable() and handle allocation in all .css_alloc()
> 
> However I need to handle allocations called from cgroup_mkdir() too and
> badly understand how to do it properly.

If we consent to charge to the creator, the change would be just passing
GFP_ACCOUNT at fewer (right) places, wouldn't it?

Also, my undertanding of memcgs is that they're not hermetically tight,
so I think charging just kernfs_nodes (for dirs and files) provides
sufficient bound.

Except for, the xattrs, my older notes say: "make kernfs simple_xattr kernel
accounted, up to KERNFS_USER_XATTR_SIZE_LIMIT*KERNFS_MAX_USER_XATTRS =
128k * 128 = 16M / inode".

HTH,
Michal

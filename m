From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Mon, 11 Oct 2021 09:29:22 -0700
Message-ID: <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eBxjwOrWVhjFCG1WOcEx4A/Nn7jB5bvKwWh/zC/S87M=;
 b=q2zdpG21FJgM+40H5ySMc8qbKhV2smAlYY8pgvcs0XWTh6QodZSOaumRVH1t4RnNOHO8
 wNHG7mMHLVV01j3zrCwU8DFzuIjFhIFqkSDHktIYUTJ4RF+/H7MzAPSK5z0PXw3GWcNg
 zmFYQx7Qpfzrvkm/A2MhY5zXAOYynLCU+Bc= 
Content-Disposition: inline
In-Reply-To: <20211011162128.GC61605@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: quanyang.wang@windriver.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Mon, Oct 11, 2021 at 06:21:28PM +0200, Michal Koutny wrote:
> Hello.
> 
> On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
> > This is because that root_cgrp->bpf.refcnt.data is allocated by the
> > function percpu_ref_init in cgroup_bpf_inherit which is called by
> > cgroup_setup_root when mounting, but not freed along with root_cgrp
> > when umounting.
> 
> Good catch!

+1

> 
> > Adding cgroup_bpf_offline which calls percpu_ref_kill to
> > cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
> 
> That is sensible.
> 
> > Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> 
> Why this Fixes:? Is the leak absent before the percpu_ref refactoring?

I agree, the "fixes" tag looks dubious to me.

> I guess the embedded data are free'd together with cgroup. Makes me
> wonder why struct cgroup_bpf has a separate percpu_ref counter from
> struct cgroup...

This is because a cgroup can stay a long time (sometimes effectively forever)
in a dying state, so we want to release bpf structures earlier.

Thanks!

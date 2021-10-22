From: John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Fri, 22 Oct 2021 08:50:48 -0700
Message-ID: <6172ddd8c3f59_82a7f208e4@john-XPS-13-9370.notmuch>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
 <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=twCWyKn/uuejyopzmhFlIyMEHdeqJMR+lwKeohJhhD0=;
        b=KbvZVn5Tds2Bhar42foeGUmsVophEgQxbcTLKcvx6/K9krvy8whv714qL72Jssa6bh
         QfMibvtBiq/Vglaeuxgcs8HVOUlj6xyJg65ieKdkJEEcbZUF9FGD41xfcR/fgrrTE28a
         025A2rqjtsMtqyU+NiD1ZwLbbmXEMEIF/qNAcZmNk4KnCoR6ZBkcgfB6dN0+Z517zL7a
         AMH5R7nnyjUNkez/RplYhVfZ1M6MFTa+OEADS87PYzRXKnfyowxiVx4UBFEguPeXP8tU
         /miU3iUtYCGLZsujIM33UIb+Rmv4Tk4HmaIevMpY5JFkbgDQfUwoahcWnNgFiUJCSImg
         AR7Q==
In-Reply-To: <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>, =?UTF-8?B?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>
Cc: quanyang.wang@windriver.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Roman Gushchin wrote:
> On Mon, Oct 11, 2021 at 06:21:28PM +0200, Michal Koutny wrote:
> > Hello.
> > 
> > On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
> > > This is because that root_cgrp->bpf.refcnt.data is allocated by the
> > > function percpu_ref_init in cgroup_bpf_inherit which is called by
> > > cgroup_setup_root when mounting, but not freed along with root_cgrp
> > > when umounting.
> > 
> > Good catch!
> 
> +1
> 
> > 
> > > Adding cgroup_bpf_offline which calls percpu_ref_kill to
> > > cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
> > 
> > That is sensible.
> > 
> > > Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> > 
> > Why this Fixes:? Is the leak absent before the percpu_ref refactoring?
> 
> I agree, the "fixes" tag looks dubious to me.
> 
> > I guess the embedded data are free'd together with cgroup. Makes me
> > wonder why struct cgroup_bpf has a separate percpu_ref counter from
> > struct cgroup...
> 
> This is because a cgroup can stay a long time (sometimes effectively forever)
> in a dying state, so we want to release bpf structures earlier.
> 
> Thanks!

Other than whitespace LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>

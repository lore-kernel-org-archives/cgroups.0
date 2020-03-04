From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix psi_show() crash on 32bit ino archs
Date: Wed, 04 Mar 2020 08:36:47 -0500
Message-ID: <1583329007.7365.151.camel@lca.pw>
References: <20200224030007.3990-1-cai@lca.pw>
         <20200224162906.GB1674@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mpYEiYRocka7ATrbRk79a6a7IumZgblHI2WLdpIhwgE=;
        b=KRMhg3xagLh3UMJC+uZmNRJhAvbb7+lGITFZ6oXEJ30imCsJOA2C8r3Gx1xSeoh0lb
         u03uyVzA7OaXsX0ecbqGS+TRSALv/m+efBvYRWRK4sQZPqEj/fTrv1B7Pmq325DuD5NW
         cMufP88PsLaQcCfoDSfv4BPWYvqoVkNYsnhvMkNnX4TuvZd59E+SOYv2wK4k/hxlGpDg
         A2arqwo0nTy1v+8iaOoMpOA01VAURb/SRsABLzydqTmYAeuDo7DyVz1SfDuQwfpnTmhO
         X6UJVLROabbZPV6y+CIAT7vCViW9RJcXYUBynLPR36HFNmVikISKGdk38i/5pQf6o5CQ
         /2HA==
In-Reply-To: <20200224162906.GB1674-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2020-02-24 at 11:29 -0500, Johannes Weiner wrote:
> On Sun, Feb 23, 2020 at 10:00:07PM -0500, Qian Cai wrote:
> > Similar to the commit d7495343228f ("cgroup: fix incorrect
> > WARN_ON_ONCE() in cgroup_setup_root()"), cgroup_id(root_cgrp) does not
> > equal to 1 on 32bit ino archs which triggers all sorts of issues with
> > psi_show() on s390x. For example,
> > 
> >  BUG: KASAN: slab-out-of-bounds in collect_percpu_times+0x2d0/
> >  Read of size 4 at addr 000000001e0ce000 by task read_all/3667
> >  collect_percpu_times+0x2d0/0x798
> >  psi_show+0x7c/0x2a8
> >  seq_read+0x2ac/0x830
> >  vfs_read+0x92/0x150
> >  ksys_read+0xe2/0x188
> >  system_call+0xd8/0x2b4
> > 
> > Fix it by using cgroup_ino().
> > 
> > Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
> > Signed-off-by: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Tejun, can you take a look at this when you had a chance?

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix psi_show() crash on 32bit ino archs
Date: Mon, 24 Feb 2020 11:29:06 -0500
Message-ID: <20200224162906.GB1674@cmpxchg.org>
References: <20200224030007.3990-1-cai@lca.pw>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ayL/a+KEUEgG8kUr32wkz/zkDzUV2JeP3xXHo8B3UmY=;
        b=H70cCu9pyk/xG3LyHYdYjgRM9JXlOdn+iavwajhfdD56D1QKqyTUIY2WkWWtme6T0R
         X0EtycCQX0mfKuXRA6ip6+B1shl+Y6MAmt8aVaNkw+P3d2QwiRZOY4VAilSFo2tH6GIQ
         8uEVQQOlAQDRDWY2xyGEK8Q0x9rigYd6AkhIDBvgupLxMxT8V29iDdKekTkoNVIIZNPd
         7015RAXtidGAd5WyQQRSIZmwrkqDA9hCTOs1MQAWoZxLPA70GcMdUahyXRINEk0eQgq/
         9IVdQi0vJuUcoWegqbsfRr+0WWwFJ+hfJsYJI+qic+gun0s6YEN3aVVEXUYixc8DAe2r
         K4cQ==
Content-Disposition: inline
In-Reply-To: <20200224030007.3990-1-cai-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Feb 23, 2020 at 10:00:07PM -0500, Qian Cai wrote:
> Similar to the commit d7495343228f ("cgroup: fix incorrect
> WARN_ON_ONCE() in cgroup_setup_root()"), cgroup_id(root_cgrp) does not
> equal to 1 on 32bit ino archs which triggers all sorts of issues with
> psi_show() on s390x. For example,
> 
>  BUG: KASAN: slab-out-of-bounds in collect_percpu_times+0x2d0/
>  Read of size 4 at addr 000000001e0ce000 by task read_all/3667
>  collect_percpu_times+0x2d0/0x798
>  psi_show+0x7c/0x2a8
>  seq_read+0x2ac/0x830
>  vfs_read+0x92/0x150
>  ksys_read+0xe2/0x188
>  system_call+0xd8/0x2b4
> 
> Fix it by using cgroup_ino().
> 
> Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
> Signed-off-by: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

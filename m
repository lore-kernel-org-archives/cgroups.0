From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix psi_show() crash on 32bit ino archs
Date: Wed, 4 Mar 2020 11:16:17 -0500
Message-ID: <20200304161617.GD189690@mtj.thefacebook.com>
References: <20200224030007.3990-1-cai@lca.pw>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OEItHJAQEWgalgushQTyB6lGoSgH6c+Ihc2zlQhimRs=;
        b=iJ1CkyFBT9pLUqQUYEJHfFfgobiSXkCa+gyEfu/r3m/nYu56CBIc7Cmo/JYsEAaGZY
         ba9/Ekd3G41hhc/4iiI/n4g0XusrQmPo+SxgGdUWZy2n9lx3I9ZXwkx04MCXqzlU4ka4
         XQHuzeA39YDcvWJiFXA2ci723xtXQ+zb3+/5mqPAJQrnnNpL65UjmYc0eGLJFkyswMVj
         eGdu2sd9zNi0KhNe0VuHjb9/dXmpJL6hL7oBxOgexpS/3Wq25Y6+IvFJuEHpnJ/DjeZH
         7JnJGAE1EWOs+MNiyDYfg9aT3r/JGukHN6Em5A24jD3em2tJ2bHSloYD9bSjubUo6ZlB
         D5fQ==
Content-Disposition: inline
In-Reply-To: <20200224030007.3990-1-cai-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Applied to cgroup/for-5.6-fixes.

Thanks.

-- 
tejun

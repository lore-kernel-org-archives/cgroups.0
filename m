From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Thu, 21 Oct 2021 18:30:24 -0700
Message-ID: <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZAI4ALD3IOPkn/ZDv37bBcofWD94RVNJhCNAaLserkY=;
 b=BrffFq0QvdYXJy+HxkHv0ZIPDi9j6kg74RNMLpiG70tGCk/HmQCUQwYzwOjKeFrDgl3V
 ZIVpOyZ7BmjjGar/4aVr73medsuvqwoqBxQLIQyrKwbt3NqPEv57uKLzyKtSqzDRlHS0
 Rv+VCrOq/rYYjXU6G83miRIITzyhX8p8FXY= 
Content-Disposition: inline
In-Reply-To: <20211018075623.26884-1-quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> From: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> 
> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
> the command as below:
> 
>     $mount -t cgroup -o none,name=foo cgroup cgroup/
>     $umount cgroup/
> 
> unreferenced object 0xc3585c40 (size 64):
>   comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>   hex dump (first 32 bytes):
>     01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>     00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>   backtrace:
>     [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>     [<1f03679c>] cgroup_setup_root+0x174/0x37c
>     [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>     [<f85b12fd>] vfs_get_tree+0x24/0x108
>     [<f55aec5c>] path_mount+0x384/0x988
>     [<e2d5e9cd>] do_mount+0x64/0x9c
>     [<208c9cfe>] sys_mount+0xfc/0x1f4
>     [<06dd06e0>] ret_fast_syscall+0x0/0x48
>     [<a8308cb3>] 0xbeb4daa8
> 
> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
> is called by cgroup_setup_root when mounting, but not freed along with
> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
> umount path.
> 
> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
> in cgroup_setup_root. 
> 
> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
> cgroup_put is at the end of cgroup_bpf_release which is called by
> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
> cgroup's refcount.
> 
> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
> Signed-off-by: Quanyang Wang <quanyang.wang-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> ---
> V1 ---> V2:
> 1. As per Daniel's suggestion, add description to commit msg about the
> balance of cgroup's refcount in cgroup_bpf_offline.
> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
> description about it.
> 3. Fix indentation on the percpu_ref_is_dying line.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

The fix looks correct, two fixes tag are fine too, if only it won't
confuse scripts picking up patches for stable backports.

In fact, it's a very cold path, which is arguably never hit in the real
life. On cgroup v2 it's not an issue. I'm not sure we need a stable
backport at all, only if it creates a noise for some automation tests.

Quanyang, out of curiosity, how did you find it?

Anyway, thanks for catching and fixing it!

Roman

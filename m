From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Mon, 18 Oct 2021 17:02:18 +0800
Message-ID: <YW04Gqqm3lDisRTc@T590>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634547763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fhNdqsd01Iuu4MdS4LMgpHQ2OS3OKZxf9FLM+N5TUbc=;
        b=Pd7RAEz1rk4n9OhQ7OFOm8EVMfDpmBcSKKAUdyZ8Fltj4TfeiUcZKyKaqdAtLAFTpMB93B
        7p2bFcxZsMfc0rvibe+uwryErcj78i15v3pBVaJ6sjO8c00MdI0sUctv1OiowZeBArVL1Z
        EF714FAGcbReaeVS/tDaaKGFXCQuVtI=
Content-Disposition: inline
In-Reply-To: <20211018075623.26884-1-quanyang.wang@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: quanyang.wang@windriver.com
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
> From: Quanyang Wang <quanyang.wang@windriver.com>
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

If I understand correctly, cgroup_bpf_release() won't be called without
your patch. So anything allocated in cgroup_bpf_inherit() will be
leaked?

If that is true, 'Fixes: 2b0d3d3e4fcf' looks misleading, cause people has to
backport your patch if 4bfc0bb2c60e is applied. Meantime, this fix isn't
needed if 4bfc0bb2c60e isn't merged.


Thanks,
Ming


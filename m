From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and
 unify cgroup IDs
Date: Wed, 6 Nov 2019 22:50:15 +0900
Message-ID: <CAM9d7cjXX8aYYjJdnb0SUjBYwhOTWiD+V9fagUVnW9FUS6C=5g@mail.gmail.com>
References: <20191104235944.3470866-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-team@fb.com, linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

Hi Tejun,

On Tue, Nov 5, 2019 at 8:59 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> Currently, there are three IDs which are being used to identify a
> cgroup.
>
> 1. cgroup->id
> 2. cgroupfs 32bit ino
> 3. cgroupfs 32bit ino + 32bit gen
>
> All three IDs are visible to userland through different interfaces.
> This is very confusing and #1 can't even be resolved to cgroups from
> userland.
>
> A 64bit number is sufficient to identify a cgroup instance uniquely
> and ino_t is 64bit on all archs except for alpha.  There's no reason
> for three different IDs at all.  This patchset updates kernfs so that
> it supports 64bit ino and associated exportfs operations and unifies
> the cgroup IDs.
>
> * On 64bit ino archs, ino is kernfs node ID which is also the cgroup
>   ID.  The ino can be passed directly into open_by_handle_at(2) w/ the
>   new key type FILEID_KERNFS.  Backward compatibility is maintained
>   for FILEID_INO32_GEN keys.
>
> * On 32bit ino archs, kernfs node ID is still 64bit and the cgroup ID.
>   ino is the low 32bits and gen is the high 32bits.  If the high
>   32bits is zero, open_by_handle_at(2) only matches the ino part of
>   the ID allowing userland to resolve inos to cgroups as long as
>   distinguishing recycled inos isn't necessary.
>
> This patchset contains the following 10 patches.
>
>  0001-kernfs-fix-ino-wrap-around-detection.patch
>  0002-writeback-use-ino_t-for-inodes-in-tracepoints.patch
>  0003-netprio-use-css-ID-instead-of-cgroup-ID.patch
>  0004-kernfs-use-dumber-locking-for-kernfs_find_and_get_no.patch
>  0005-kernfs-kernfs_find_and_get_node_by_ino-should-only-l.patch
>  0006-kernfs-convert-kernfs_node-id-from-union-kernfs_node.patch
>  0007-kernfs-combine-ino-id-lookup-functions-into-kernfs_f.patch
>  0008-kernfs-implement-custom-exportfs-ops-and-fid-type.patch
>  0009-kernfs-use-64bit-inos-if-ino_t-is-64bit.patch
>  0010-cgroup-use-cgrp-kn-id-as-the-cgroup-ID.patch
>
> 0001 is a fix which should be backported through -stable.  0002 and
> 0003 are prep patches.  0004-0009 make kernfs_node->id a u64 and use
> it as ino on 64bit ino archs.  0010 replaces cgroup->id with the
> kernfs node ID.
>
> Greg, how do you want to route the patches?  We can route 0001-0009
> through your tree and the last one through cgroup after pulling in.
> I'd be happy to route them all too.
>
> This patchset is also available in the following git branch.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unified-cgid
>
> diffstat follows.  Thanks.

Thanks a lot for doing this!  I've tested it with my perf cgroup patchset
based on top of this series and it looks good.  You can add my

Tested-by: Namhyung Kim <namhyung@kernel.org>

Thanks
Namhyung

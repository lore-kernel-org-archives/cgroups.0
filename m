From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and
 unify cgroup IDs
Date: Tue, 12 Nov 2019 17:09:33 +0100
Message-ID: <20191112160933.GA1690816@kroah.com>
References: <20191104235944.3470866-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573574976;
        bh=oiv2wggYDQeIpeRvfqTgvwPPLXlI1iaTuXf92EPZRyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1cNDVFCadAxDvc8bQyL0JHID4Bc9Xn94XOnbWljeeevuIdsWxdCwELBSlwyzUXv8r
         hF7MIMcfEn+k6qodKQwXIhw0TT/tEe/+cKcxPppFPsJ+lvVd6I6TEPVhX/tbgFYvCg
         YhKwqYWvjXfrxkWkwxvaWK6KFnR8XXbxGdZdb+FA=
Content-Disposition: inline
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net

On Mon, Nov 04, 2019 at 03:59:34PM -0800, Tejun Heo wrote:
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

Sorry for the delay.  Feel free to take all of these through your tree,
that probably is easiest:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

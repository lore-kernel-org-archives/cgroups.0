From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Test of [PATCH] blk-throttle: simplify logic by token bucket algorithm
Date: Tue, 15 Apr 2014 15:23:06 +0800
Message-ID: <1397546586-6776-1-git-send-email-zhiguohong@tencent.com>
References: <1397546303-6709-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RJhzVRBJ3KlUZDa/wfWpB1nCASqVOIrCXubW0nk5HVs=;
        b=TdbpHtXfO+c5hCvWvrB+JCrYjhgVRMvku8Au7DHVgHhkkjIKogtGfLJ37bCwUqNvng
         AmkyhMfs0HJV2ZlVX9+6uQ4QVeLN3e30aGh8BzosbaS1i932hjPNroEBgWBZ1lYiaM0G
         Cy1Vd6WzxBNH+deCTlVZ6CpnNJl+gXxOAU4Z/ov3CTAZYQFq6Rm6fUruLTDwhttmkx4n
         vbKE9DzOikPzpVt+Lv06PXQfERqXVO+kizGSfb/gV1Z9jpuHHEofaTDsRct+JVtjH1i1
         lyutZxNNc0vsvudjesbt5QBxCZAlgsBIl2hk3bD5aHrGo561msNUXV2f2mJUVus3QWHK
         cniQ==
In-Reply-To: <1397546303-6709-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi, Vivek,

I tested the PATCH again for some basic hierarchical setup as I did
before.

Preparation
============
1) mount subsys blkio with "__DEVEL__sane_behavior"
2) Create 3 levels of directories under the blkio mount point:
    mkdir 1
    mkdir 1/2
    mkdir 1/2/3
    mkdir 4
3) start 4 bash sessions, write their PIDs into:
    1/cgroup.procs
    1/2/cgroup.procs
    1/2/3/cgroup.procs
    4/cgroup.procs
4) prepare 4 10MB files on sdb(ext4 fs)

Note: in below hierarchy graph:
    "[50k]" means configured value for read_bps_device is 50kB/s
    "[-]"   means unlimit configured
    "(50k)" means bandwidth reported by dd is 50kB/s

Test A: 1 process throttled by ancestor group
=============================================
Hierarchy set-up:
    (echo "8:16 204800" > 1/blkio.throttle.read_bps_device)
    |-- 1 [200k]
    |    `-- 2 [-]
    |         `-- 3 [-]
    `-- 4 [-]

dd within group 3:
    (drop cache then: dd if=10M-file-3 of=/dev/null)
Result:
    205kB/s (I did same test without the token-bucket patch, The
result is also 205kB/s)

dd within group 2:
    (drop cache then: dd if=10M-file-2 of=/dev/null)
Result:
    205kB/s

Test B: 4 processes in 3 levels of hierarchy, group 1 unlimited
===============================================================
Hierarchy set-up:
    echo "8:16 204800" > 1/blkio.throttle.read_bps_device
    echo "8:16 102400" > 1/2/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 1/2/3/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 4/blkio.throttle.read_bps_device
    |-- 1 [-]
    |    `-- 2 [100k]
    |         `-- 3 [50k]
    `-- 4 [50k]

start 4 dd processes from 4 bash sessions
    (dd if=10M-file-x of=/dev/null)
Result:
    |-- 1 (171M)
    |    `-- 2 (51.9k)
    |         `-- 3 (51.2k)
    `-- 4 (51.3k)

Test C: 4 processes in 3 levels of hierarchy
=============================================
Hierarchy set-up:
    echo "8:16 204800" > 1/blkio.throttle.read_bps_device
    echo "8:16 102400" > 1/2/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 1/2/3/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 4/blkio.throttle.read_bps_device
    |-- 1 [200k]
    |    `-- 2 [100k]
    |         `-- 3 [50k]
    `-- 4 [50k]

write 10M-file-1 to 20M, others still 10M, so 4 dd processes
take similar time.

start 4 dd processes from 4 bash sessions
    (dd if=10M-file-x of=/dev/null)
Result:
    |-- 1 (104k)
    |    `-- 2 (52.8k)
    |         `-- 3 (51.1k)
    `-- 4 (51.4k)

From: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: arm32: beagleboard x15: WARNING: CPU: 0 PID: 0 at
 /usr/src/kernel/kernel/cgroup/cgroup.c:1969 cgroup_setup_root+0x36c/0x4e8
Date: Thu, 14 Nov 2019 14:42:13 -0800
Message-ID: <20191114224213.GN4163745@devbig004.ftw2.facebook.com>
References: <CA+G9fYviReoG+gq=Jm8yQOMd01j2opae5p+VTGGMK7aLn0xWgw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ojnBoVhRYBbbCku6o5OhWdqFFJEnFiZ4I+6b/GkoBQg=;
        b=trF141knO9ioTtIa22bXyKIHKH4GLkubkdpaZr1p66/+mAnS94hwyTuqJPEpeDTdcK
         MRnCl8OXpIg1M8eDQmjQPZWi676P7i1N5qlBXHT96lVpD41/u6XK+f01o/wVTMYdghmM
         afyaTE0ClSOVWSwOfLOp/XKVxNs0m3hlegXjlIYwiKOrmRmudrMRcY5mjWvP32mSZxQF
         kRlRt+udROlAYRStA84rdML/0FveL4AzC/OvVehfYFSmUP6YUaD5H6gEDRxO0XZt4y1X
         tyRYUQjDBh4UErUv6KNQpQOu/xkl8aL+n5hsLT7cGwcWWUhxAZRdKspN5q12+EHTH04y
         2W2Q==
Content-Disposition: inline
In-Reply-To: <CA+G9fYviReoG+gq=Jm8yQOMd01j2opae5p+VTGGMK7aLn0xWgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: cgroups@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, namhyung@kernel.org, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, lizefan@huawei.com, hannes@cmpxchg.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>

Hello, Naresh.

On Thu, Nov 14, 2019 at 11:02:53AM +0530, Naresh Kamboju wrote:
> [    0.015402] WARNING: CPU: 0 PID: 0 at /usr/src/kernel/kernel/cgroup/cgroup.c:1969
> cgroup_setup_root+0x36c/0x4e8
...
> [    0.015726] [<c053ac48>] (cgroup_setup_root) from [<c1c2a260>]
> (cgroup_init+0x108/0x560)

So, that's saying that the initial kernfs_node ino allocation returned
something other than 1.  Hmmm... x86_32 works fine.  What does the
following say?

# mkdir -p /tmp/cgroup2
# mount -t cgroup2 none /tmp/cgroup2
# ls -lid /tmp/cgroup2

Thanks.

-- 
tejun

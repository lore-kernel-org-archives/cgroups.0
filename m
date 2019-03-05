From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-throttle: verify format of bandwidth limit and
 detect overflows
Date: Tue, 5 Mar 2019 07:56:31 -0800
Message-ID: <20190305155631.GC50184@devbig004.ftw2.facebook.com>
References: <155125474480.292717.11530762471075713387.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WTMGFXEwvv834bUyTqH/FDpKhZyzE74Gv015Xci/W80=;
        b=gCM3lObLREqor6Te5QIeF/noQouXPJTTJIhg3fABbhNjvK8U4od1/wtuVUjK2ouuB0
         cIKrr3yzdiuMxfDvFAXplqwoUVJZHron5JR9U4NHXgJYOR+eZ38X4BiY9GKL50rYgDaI
         SGR9OwbLxUEDjidc9ra8qyYdHOykYF8H31DQMeJMhDyFMnMT/eFxYZYeW4/ScfWkLhRy
         jDnScWmM9jJ1H/5foAhWFWpkzc8NtGJgk4G98tXfiVFSeaS3fsJJPdNwc0zYTen10JFX
         oW3uCgzeZSSJpagaMW/7lG/g1loAormNguDSkYBY+b7MnT3wRSRNkutdqn4dtViQGfoC
         9Hvg==
Content-Disposition: inline
In-Reply-To: <155125474480.292717.11530762471075713387.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Konstantin.

On Wed, Feb 27, 2019 at 11:05:44AM +0300, Konstantin Khlebnikov wrote:
> Unlike to memory cgroup blkio throttler does not support value suffixes.
> 
> It silently ignores everything after last digit. For example this command
> will set rate limit 1 byte per second rather than 1 megabyte per second:
> 
> # echo "7:0 1M" > blkio.throttle.read_bps_device
> # cat blkio.throttle.read_bps_device
> 7:0 1
> 
> Cgroup2 interface has the same flaw:
> 
> # echo "7:0 rbps=1M" > io.max
> # cat io.max
> 7:0 rbps=1 wbps=max riops=max wiops=max
> 
> Also sscanf does not care much about overflows.
> 
> This patch uses modern function kstrtou64 for parsing.
> It rejects trailing garbage and detects integer overflows.
> 
> Also this patch handles iops limit overflows for cgroup-v1 in the same as
> cgroup-v2: limits >= UINT_MAX becomes unlimited.
> 
> Fixes: 2ee867dcfa2e ("blkcg: implement interface for the unified hierarchy")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

So, I'd much rather keep the parsing implementations simple.  Unless
there's a correctness problem (you mentioned overflowing, how would
that happen?), the simpler the better.  I don't think the kernel needs
to be in the business of strict input verification here.

Thanks.

-- 
tejun

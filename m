From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: Fix memory leak when parsing multiple source
 parameters
Date: Wed, 16 Dec 2020 10:11:36 -0500
Message-ID: <X9ojqIbV/SxSrNy7@mtj.duckdns.org>
References: <20201209121322.77665-1-miaoqinglang@huawei.com>
 <20201210012943.92845-1-miaoqinglang@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8UBHhFg+dlyjUuWALZhGhLIm76hEru3ETvVso2v0Xo=;
        b=pUc3eRmZd45iQpeNK/64AmkrzUhbIBAM7pKzZyYLjQeKyB92dntNljnfvCDG7UOutC
         m/WplD/grRAc7RqIf6063SJhpGRrhLVYsa9EmZMmHYKsibbOpNo+pejGfsc60bR5sK3u
         JIiiMJnAt/e0LnjeULzz4tUefO9MJl5Uu91PouXkDceaxnRZvddl2dX1yMBiPDJWMG5B
         PDW6Zg21tN16gCA2MkTzQgcFZKUV4Tx+84qwNpxl1l8c52lXa52B3/snRWQwGIpQaZPy
         2uyKK9OID73/SM8cyaK+p6T52VS1GXnZf8lAoAUK+vqxq9+awrc6NDtSziLwoUTrHPwg
         Swlg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20201210012943.92845-1-miaoqinglang@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qinglang Miao <miaoqinglang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 10, 2020 at 09:29:43AM +0800, Qinglang Miao wrote:
> A memory leak is found in cgroup1_parse_param() when multiple source
> parameters overwrite fc->source in the fs_context struct without free.
> 
> unreferenced object 0xffff888100d930e0 (size 16):
>   comm "mount", pid 520, jiffies 4303326831 (age 152.783s)
>   hex dump (first 16 bytes):
>     74 65 73 74 6c 65 61 6b 00 00 00 00 00 00 00 00  testleak........
>   backtrace:
>     [<000000003e5023ec>] kmemdup_nul+0x2d/0xa0
>     [<00000000377dbdaa>] vfs_parse_fs_string+0xc0/0x150
>     [<00000000cb2b4882>] generic_parse_monolithic+0x15a/0x1d0
>     [<000000000f750198>] path_mount+0xee1/0x1820
>     [<0000000004756de2>] do_mount+0xea/0x100
>     [<0000000094cafb0a>] __x64_sys_mount+0x14b/0x1f0
> 
> Fix this bug by permitting a single source parameter and rejecting with
> an error all subsequent ones.
> 
> Fixes: 8d2451f4994f ("cgroup1: switch to option-by-option parsing")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Applied to cgroup/for-5.11.

Thanks.

-- 
tejun

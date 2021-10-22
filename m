From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Fri, 22 Oct 2021 19:55:50 +0800
Message-ID: <35e9e89f-d92f-06f9-b919-ef956d99d7df@windriver.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=wsab649gLJGi//T9euidn7LFas7vqxiCVMXZVelw0Hk=;
 b=Y0pe9BFIgvOEXDVaPg6DF3ET1J6Tv1QRgyfhSyv6TvzZFvzyCg60erPSmc1EdU7H6mj6
 +mcfOUv3iCsAQt52dVx8TKm3iO2S9ye45PE5P+pCvufdgRT2yqzL4EZgHIo5Ic27WmWk
 dnMfxk/0pPgOwVn3T9A5wu6ev85ytjuKCBm/NCwZBKase8FwziUGQ2YtgCY8621Z7vnX
 Ghy22ubYvFxMlYSsmCj0wg+XlqSBg+tL7wWQg6iCSak+Enh9hLZo/nX0o2Xaw5h8psYa
 Y5QnL6ayl8Pf0L0W6sGITFOyff4K8EX6AzXXsmNllGky8xu44hWOyVM8WKb1wZcuCsTo YA== 
In-Reply-To: <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hi Roman,

On 10/22/21 9:30 AM, Roman Gushchin wrote:
> On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>
>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>> the command as below:
>>
>>      $mount -t cgroup -o none,name=foo cgroup cgroup/
>>      $umount cgroup/
>>
>> unreferenced object 0xc3585c40 (size 64):
>>    comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>    hex dump (first 32 bytes):
>>      01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>      00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>    backtrace:
>>      [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>      [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>      [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>      [<f85b12fd>] vfs_get_tree+0x24/0x108
>>      [<f55aec5c>] path_mount+0x384/0x988
>>      [<e2d5e9cd>] do_mount+0x64/0x9c
>>      [<208c9cfe>] sys_mount+0xfc/0x1f4
>>      [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>      [<a8308cb3>] 0xbeb4daa8
>>
>> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
>> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
>> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
>> is called by cgroup_setup_root when mounting, but not freed along with
>> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
>> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
>> umount path.
>>
>> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
>> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
>> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
>> in cgroup_setup_root.
>>
>> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
>> cgroup_put is at the end of cgroup_bpf_release which is called by
>> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
>> cgroup's refcount.
>>
>> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
>> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
>> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
>> ---
>> V1 ---> V2:
>> 1. As per Daniel's suggestion, add description to commit msg about the
>> balance of cgroup's refcount in cgroup_bpf_offline.
>> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
>> description about it.
>> 3. Fix indentation on the percpu_ref_is_dying line.
> 
> Acked-by: Roman Gushchin <guro@fb.com>
> 
> The fix looks correct, two fixes tag are fine too, if only it won't
> confuse scripts picking up patches for stable backports.
> 
> In fact, it's a very cold path, which is arguably never hit in the real
> life. On cgroup v2 it's not an issue. I'm not sure we need a stable
> backport at all, only if it creates a noise for some automation tests.
> 
> Quanyang, out of curiosity, how did you find it?
I ran ltp testsuite to find this.

./runltp -f controllers -s cgroup

Thanks,
Quanyang
> 
> Anyway, thanks for catching and fixing it!
> 
> Roman
> 

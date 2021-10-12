From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: Re: [RESEND][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Tue, 12 Oct 2021 13:44:03 +0800
Message-ID: <6c15c2d5-39c2-5c86-b9ab-d64089e8d654@windriver.com>
References: <20211008004600.1717681-1-quanyang.wang@windriver.com>
 <c4d12954-aa78-625e-3be7-06d4fc906bf7@iogearbox.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=OMs8bo9p0zA1QX7WpyX/I+hgX507vOvSmg9es2nex4M=;
 b=jLvFeqBBd8i2WYWxe2MkB7jQXRpsyP8rT90DqKXZGOcIVsqv0KeXYPB2MJtnplcXpsdV
 VSYBXceI0vfhEHh1787xte675/TDHKylB1U9ogS87efpS++Syd0K/mk4H45YB8kQmCwA
 Q+JQuwWgQWgLy4dAzBLFLMqrVsWgv9+tEc68+cgTzuJ6G/ovozkNX6seoOky/b9zJwRs
 66mP3kSQP3FVs9ZqsgJAENVwdZss/YEl8P7FfBPhbU2dKkKhdFdk8YzIhPK2i6W+qaHV
 mu04IMxkTDE4TS/tWvJtMrFIUMXLmYT/yQMmJshmN/uJhkQda7Q+fGHLLx/RpEKn83XD BQ== 
In-Reply-To: <c4d12954-aa78-625e-3be7-06d4fc906bf7@iogearbox.net>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hi Daniel,
Thank you for your review.

On 10/11/21 9:44 PM, Daniel Borkmann wrote:
> [ +Roman ]
> 
> On 10/8/21 2:46 AM, quanyang.wang@windriver.com wrote:
>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>
>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>> the command as below:
>>
>>      $mount -t cgroup -o none,name=foo cgroup cgroup/
>>      $umount cgroup/
>>
>> unreferenced object 0xc3585c40 (size 64):
>>    comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>    hex dump (first 32 bytes):
>>      01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>      00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>    backtrace:
>>      [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>      [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>      [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>      [<f85b12fd>] vfs_get_tree+0x24/0x108
>>      [<f55aec5c>] path_mount+0x384/0x988
>>      [<e2d5e9cd>] do_mount+0x64/0x9c
>>      [<208c9cfe>] sys_mount+0xfc/0x1f4
>>      [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>      [<a8308cb3>] 0xbeb4daa8
>>
>> This is because that root_cgrp->bpf.refcnt.data is allocated by the
>> function percpu_ref_init in cgroup_bpf_inherit which is called by
>> cgroup_setup_root when mounting, but not freed along with root_cgrp
>> when umounting. Adding cgroup_bpf_offline which calls percpu_ref_kill
>> to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
>>
>> Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of 
>> percpu_ref in fast path")
>> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
>> ---
>> One of the recipients' email is wrong, so I resend this patch.
>> Sorry for any confusion caused.
>> ---
>>   kernel/cgroup/cgroup.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 570b0c97392a9..183736ad72f2b 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -2187,8 +2187,10 @@ static void cgroup_kill_sb(struct super_block *sb)
>>        * And don't kill the default root.
>>        */
>>       if (list_empty(&root->cgrp.self.children) && root != 
>> &cgrp_dfl_root &&
>> -        !percpu_ref_is_dying(&root->cgrp.self.refcnt))
>> +            !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>> +        cgroup_bpf_offline(&root->cgrp);
>>           percpu_ref_kill(&root->cgrp.self.refcnt);
>> +    }
>>       cgroup_put(&root->cgrp);
> 
> Doesn't cgroup_bpf_offline() internally bump the root cgroup's refcount 
> via cgroup_get()?
> How does this relate to the single cgroup_put() in the above line?
There is cgroup_get/put pair inside cgroup_bpf_offline.
cgroup_get() is at the beginning of cgroup_bpf_offline.
cgroup_put is called at the routine:
cgroup_bpf_offline
->percpu_ref_kill
-->cgroup_bpf_release_fn
--->cgroup_bpf_release (there is a cgroup_put() at the end of it).
So cgroup_bpf_offline can keep the balance of cgroup's refcount.
  Would
> have been nice to
> see the commit msg elaborate more on this.
 >
OK, I will add description about this in the commit msg.

Thanks,
Quanyang
> 
>>       kernfs_kill_sb(sb);
>>   }
>>
> 

From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Mon, 18 Oct 2021 18:06:28 +0800
Message-ID: <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=e6mL/tcgbZqVrGO/gRpWCz2Ek02OFJyMV0YVhGADKC0=;
 b=UmIiBjWXLZ1lM4fT5OemfjBSsyP3wjy3qmyGgW6wSyvZBNbwSxExxo5XtDgTCsrEarkY
 N/iAS7QCA/95NJ/duJwmbf9IDEC2bRUBbCrKT9MwEKhXxM/0yi9VhaPMfsyRugW91Z3W
 VWlGJuR78FWRBONixmnK8BDXvBWfQWCd1rO2NTrvRvn6mB77oZ7Ipya8ly8WYCOBFPqa
 KDHSHaxx4lKo+2b4Eh3lCkRBJxLh2pRqppiDZrsmbV9b4LZQ/vQcvSOvnKjh43dgKu3G
 191OW7JRD5+uQluEGVCrpdiQrBip67db8vAB/BmfBVwUdiflHWo8G4yTnfCeC0i4VojN 1Q== 
In-Reply-To: <YW04Gqqm3lDisRTc@T590>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hi Ming,

On 10/18/21 5:02 PM, Ming Lei wrote:
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
> 
> If I understand correctly, cgroup_bpf_release() won't be called without
> your patch. So anything allocated in cgroup_bpf_inherit() will be
> leaked?
No, for now cgroup_bpf_release is called to release bpf.refcnt.data of 
the cgroup which is not root_cgroup. Only root_cgroup's bpf data is leaked.

For non-root cgroup:
cgroup_mkdir
-> cgroup_create
-->cgroup_bpf_inherit(cgrp_A)
cgroup_rmdir
->cgroup_destroy_locked()
-->cgroup_bpf_offline(cgrp_A)
So for non-root cgroup, there is no memory leak.


For root cgroup:
cgroup_setup_root
->cgroup_bpf_inherit(root_cgrp)
cgroup_kill_sb:
-> (Here should be call cgroup_bpf_offline, or else leak occurs)

Thanks,
Quanyang


> 
> If that is true, 'Fixes: 2b0d3d3e4fcf' looks misleading, cause people has to
> backport your patch if 4bfc0bb2c60e is applied. Meantime, this fix isn't
> needed if 4bfc0bb2c60e isn't merged.
> 
> 
> Thanks,
> Ming
> 

From: Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Sun, 26 Feb 2023 07:59:48 +0000
Message-ID: <3130cb3e-eaca-04c2-ad97-b32ffddad397@debian.org>
References: <20230224160714.172884-1-leitao@debian.org>
 <20230224185126.bxkreilofbp2t4on@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230224185126.bxkreilofbp2t4on@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, aherrmann@suse.de, linux-kernel@vger.kernel.org, hch@lst.de, leit@fb.com

Hello Michal,

On 2/24/23 18:51, Michal Koutn=C3=BD wrote:
>> 	blk_iocost_init (include/asm-generic/qspinlock.h:128
>> 			 include/linux/spinlock.h:203
>> 			 include/linux/spinlock_api_smp.h:158
>> 			 include/linux/spinlock.h:400
>> 			 block/blk-iocost.c:2884)
>> 	ioc_qos_write (block/blk-iocost.c:3198)
>> 	? kretprobe_perf_func (kernel/trace/trace_kprobe.c:1566)
>> 	? kernfs_fop_write_iter (include/linux/slab.h:584 fs/kernfs/file.c:311)
>> 	? __kmem_cache_alloc_node (mm/slab.h:? mm/slub.c:3452 mm/slub.c:3491)
>> 	? _copy_from_iter (arch/x86/include/asm/uaccess_64.h:46
>> 			   arch/x86/include/asm/uaccess_64.h:52
>> 			   lib/iov_iter.c:183 lib/iov_iter.c:628)
>> 	? kretprobe_dispatcher (kernel/trace/trace_kprobe.c:1693)
>> 	cgroup_file_write (kernel/cgroup/cgroup.c:4061)
>> 	kernfs_fop_write_iter (fs/kernfs/file.c:334)
>> 	vfs_write (include/linux/fs.h:1849 fs/read_write.c:491
>> 		   fs/read_write.c:584)
>> 	ksys_write (fs/read_write.c:637)
>> 	do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
>> 	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
>=20
> BTW, out of curiosity what tool did you use to list stack with line
> numbers?

I use the decode_stacktrace.sh from kernel's scripts directory. You=20
basically
pipe the stack to it, and call it passing the vmlinux file. It is=20
incredible handy.

https://elixir.bootlin.com/linux/latest/source/scripts/decode_stacktrace.sh

Thanks for the review,
Breno

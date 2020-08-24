From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/4] mm: support nesting memalloc_use_memcg()
Date: Mon, 24 Aug 2020 09:19:01 -0700
Message-ID: <20200824161901.GA2401952@carbon.lan>
References: <20200824153607.6595-1-schatzberg.dan@gmail.com>
 <20200824153607.6595-3-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lfSEnEBzAhVRh0b+ljkilNtl2SEkfLzNaJXp0eeDhQY=;
 b=btW4dmxdf2hk3CnnQ7PggPA+MsAl+emZ1YA9zdupSYUxXS9lX7gOLaZdDktrIFoxpRLb
 OHz69uTdcOYDCVjlTnEldVXMVPC0/cHEJUiZ3DGN/wDFNbzpeRuQyyhE9UcntSGo+hgn
 mPpKd0ggeJK5LA7lGdsy/V8GKo5uJvtVoN8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfSEnEBzAhVRh0b+ljkilNtl2SEkfLzNaJXp0eeDhQY=;
 b=DPZUx1ZbHEK1lC9/BCyy8evBKt38xXP2olFDdJ4TieDF5vrQAcSvweSugvQBGnQX3rHcTS4jGm35mxxZ4aczLr6DT6+s+B1VHGgQZmHln58tO9T7KEo1DBp5od4RMDbLmEvvvyf0wWJXGfZgUVXrhyTrK1r9Bm2tYTGvi3wYWRY=
Content-Disposition: inline
In-Reply-To: <20200824153607.6595-3-schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Naresh Kamboju <naresh.kamboju@linaro.org>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Yang Shi <yang.shi@linux.alibaba.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Daniel Jordan <dan>

On Mon, Aug 24, 2020 at 11:36:00AM -0400, Dan Schatzberg wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> The memalloc_use_memcg() function to override the default memcg
> accounting context currently doesn't nest. But the patches to make the
> loop driver cgroup-aware will end up nesting:
> 
> [   98.137605]  alloc_page_buffers+0x210/0x288
> [   98.141799]  __getblk_gfp+0x1d4/0x400
> [   98.145475]  ext4_read_block_bitmap_nowait+0x148/0xbc8
> [   98.150628]  ext4_mb_init_cache+0x25c/0x9b0
> [   98.154821]  ext4_mb_init_group+0x270/0x390
> [   98.159014]  ext4_mb_good_group+0x264/0x270
> [   98.163208]  ext4_mb_regular_allocator+0x480/0x798
> [   98.168011]  ext4_mb_new_blocks+0x958/0x10f8
> [   98.172294]  ext4_ext_map_blocks+0xec8/0x1618
> [   98.176660]  ext4_map_blocks+0x1b8/0x8a0
> [   98.180592]  ext4_writepages+0x830/0xf10
> [   98.184523]  do_writepages+0xb4/0x198
> [   98.188195]  __filemap_fdatawrite_range+0x170/0x1c8
> [   98.193086]  filemap_write_and_wait_range+0x40/0xb0
> [   98.197974]  ext4_punch_hole+0x4a4/0x660
> [   98.201907]  ext4_fallocate+0x294/0x1190
> [   98.205839]  loop_process_work+0x690/0x1100
> [   98.210032]  loop_workfn+0x2c/0x110
> [   98.213529]  process_one_work+0x3e0/0x648
> [   98.217546]  worker_thread+0x70/0x670
> [   98.221217]  kthread+0x1b8/0x1c0
> [   98.224452]  ret_from_fork+0x10/0x18
> 
> where loop_process_work() sets the memcg override to the memcg that
> submitted the IO request, and alloc_page_buffers() sets the override
> to the memcg that instantiated the cache page, which may differ.
> 
> Make memalloc_use_memcg() return the old memcg and convert existing
> users to a stacking model. Delete the unused memalloc_unuse_memcg().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Hi Dan,

JFYI: I need a similar patch for the bpf memory accounting rework,
so I ended up sending it separately (with some modifications including
different naming): https://lkml.org/lkml/2020/8/21/1464 .

Can you please, rebase your patchset using this patch?

I hope Andrew can pull this standalone patch into 5.9-rc*,
as Shakeel suggested. It will help us to avoid merge conflicts
during the 5.10 merge window.

Thanks!

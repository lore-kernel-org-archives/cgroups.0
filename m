From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 49/51] buffer, writeback: make __block_write_full_page()
 honor cgroup writeback
Date: Wed, 1 Jul 2015 21:21:02 +0200
Message-ID: <20150701192102.GK7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-50-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-50-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Andrew Morton <akpm@linux-foundation.org>

On Fri 22-05-15 17:14:03, Tejun Heo wrote:
> [__]block_write_full_page() is used to implement ->writepage in
> various filesystems.  All writeback logic is now updated to handle
> cgroup writeback and the block cgroup to issue IOs for is encoded in
> writeback_control and can be retrieved from the inode; however,
> [__]block_write_full_page() currently ignores the blkcg indicated by
> inode and issues all bio's without explicit blkcg association.
> 
> This patch adds submit_bh_blkcg() which associates the bio with the
> specified blkio cgroup before issuing and uses it in
> __block_write_full_page() so that the issued bio's are associated with
> inode_to_wb_blkcg_css(inode).

One comment below...

> @@ -44,6 +45,9 @@
>  #include <trace/events/block.h>
>  
>  static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
> +static int submit_bh_blkcg(int rw, struct buffer_head *bh,
> +			   unsigned long bio_flags,

The argument bio_flags is unused. What is is good for?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 50/51] mpage: make __mpage_writepage() honor cgroup
 writeback
Date: Wed, 1 Jul 2015 21:26:40 +0200
Message-ID: <20150701192640.GL7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-51-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-51-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On Fri 22-05-15 17:14:04, Tejun Heo wrote:
> __mpage_writepage() is used to implement mpage_writepages() which in
> turn is used for ->writepages() of various filesystems.  All writeback
> logic is now updated to handle cgroup writeback and the block cgroup
> to issue IOs for is encoded in writeback_control and can be retrieved
> from the inode; however, __mpage_writepage() currently ignores the
> blkcg indicated by the inode and issues all bio's without explicit
> blkcg association.
> 
> This patch updates __mpage_writepage() so that the issued bio's are
> associated with inode_to_writeback_blkcg_css(inode).
> 
> v2: Updated for per-inode wb association.

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza
 
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/mpage.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 3e79220..a3ccb0b 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -605,6 +605,8 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
>  				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
>  		if (bio == NULL)
>  			goto confused;
> +
> +		bio_associate_blkcg(bio, inode_to_wb_blkcg_css(inode));
>  	}
>  
>  	/*
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

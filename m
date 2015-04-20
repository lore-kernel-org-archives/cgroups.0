From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 13/49] writeback: move bandwidth related fields from
 backing_dev_info into bdi_writeback
Date: Mon, 20 Apr 2015 14:01:20 -0400
Message-ID: <20150420180120.GC4206@htj.duckdns.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-14-git-send-email-tj@kernel.org>
 <20150420150950.GB17020@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YO8lU6vsJHIeQS001CGDYibh3Id7t6t3WBhkJdeIt54=;
        b=x6v1naIyARleMyQNNdxZrd4iD2PCoYNaDFi+kUW/EUolWnrGntYExAh2LFZtCYbKo+
         dR73MBfg7CP1ktBrfQt1f4C7Bg2HPc+TU9/8Ku7VcvYpTtxoQ22oUrcd7Hj0r3uOEvh6
         Fd2G3XwfTNgHsuzT3l+0GlOqxNIwDl58qQ5rK3SrvZAxV0a5YqykAu+vT0WmG7o+PuLr
         wvRsoHV2/S6uKForJplu4cLjgVbG5/ImI5NwqAy7E38Clw1dl8fFdCzhx8FqLBHCqHCT
         d43djButDVLfCLfKyJk4A5MEkf+MYMf1ZcDEeQLs9X+T/4iZJFT5G2PHQy74PklMau0H
         wz4A==
Content-Disposition: inline
In-Reply-To: <20150420150950.GB17020@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

On Mon, Apr 20, 2015 at 05:09:50PM +0200, Jan Kara wrote:
> On Mon 06-04-15 15:58:02, Tejun Heo wrote:
> > Currently, a bdi (backing_dev_info) embeds single wb (bdi_writeback)
> > and the role of the separation is unclear.  For cgroup support for
> > writeback IOs, a bdi will be updated to host multiple wb's where each
> > wb serves writeback IOs of a different cgroup on the bdi.  To achieve
> > that, a wb should carry all states necessary for servicing writeback
> > IOs for a cgroup independently.
> > 
> > This patch moves bandwidth related fields from backing_dev_info into
> > bdi_writeback.
> > 
> > * The moved fields are: bw_time_stamp, dirtied_stamp, written_stamp,
> >   write_bandwidth, avg_write_bandwidth, dirty_ratelimit,
> >   balanced_dirty_ratelimit, completions and dirty_exceeded.
> > 
> > * writeback_chunk_size() and over_bgroup_thresh() now take @wb instead
> >   of @bdi.
>  				^^^ over_bground_thresh()
> 
> Otherwise the patch looks good to me. You can add:

Updated accordingly.

> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 51/51] ext2: enable cgroup writeback support
Date: Wed, 1 Jul 2015 23:08:28 -0400
Message-ID: <20150702030828.GO26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-52-git-send-email-tj@kernel.org>
 <20150701192912.GN7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/3xtbP0i3IyaVtK3IF95IQQ8mKBbGrB2lo0TrJya8TA=;
        b=rxGVdFVx7OiGBLL7CoEpPaY5JYXwd+okuTsDC7LM2O8GAjfL+phHRWl7OuA7UesWMi
         tgh0RAzek8Wftf6i0YRClqnFwEweClA3+bbohAQK21IuTX86dPNGyOJuov1YUvox9fPs
         oKqo5i1PWP2riRyn8dUXvWKGT2f+gNPdt/AbPLldRAk3V0Pd4Ckuw1k+wy2clW+eYFze
         gaVel0guf4S3WUudtMamkT9oO3tA9Lj/PjQUcMH0ragAvey/NxhhdOv7YRJ4WYT6w5lc
         IiDD8pHbgazh2QNCeKf8DOq5kirnkyJdqFgaZqPy0jt+S8Xov1A7evwTy9951BNniTws
         ORPw==
Content-Disposition: inline
In-Reply-To: <20150701192912.GN7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, linux-ext4@vger.kernel.org

On Wed, Jul 01, 2015 at 09:29:12PM +0200, Jan Kara wrote:
> On Fri 22-05-15 17:14:05, Tejun Heo wrote:
> > Writeback now supports cgroup writeback and the generic writeback,
> > buffer, libfs, and mpage helpers that ext2 uses are all updated to
> > work with cgroup writeback.
> > 
> > This patch enables cgroup writeback for ext2 by adding
> > FS_CGROUP_WRITEBACK to its ->fs_flags.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-ext4@vger.kernel.org
> 
> Hallelujah!
> 
> Reviewed-by: Jan Kara <jack@suse.com>

Hooray!  Thanks a lot for going through all the patches!  :)

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

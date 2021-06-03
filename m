From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 4/5] writeback, cgroup: support switching multiple
 inodes at once
Date: Thu, 3 Jun 2021 12:10:57 +0200
Message-ID: <20210603101057.GH23647@quack2.suse.cz>
References: <20210603005517.1403689-1-guro@fb.com>
 <20210603005517.1403689-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622715058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dl1cSFiS5eKqztKERplBtFE3q8X+b7XPT0PQ/DFNCvM=;
        b=tPuCzD1fQp7yP6anCTvYzIYNpUk9tc3LVokNr+FsYzOzm74PZesjrtCYB8WUDID5WbX6lb
        Eh1+21542gh0yxrTadXYt2VbTT5S0myebYY0wbrvIkodTZMSVCFALWL/WxzoUsO2luaJ1a
        3l4cCvlm8BgUKgQd4xaj4JkkJG2sVJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622715058;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dl1cSFiS5eKqztKERplBtFE3q8X+b7XPT0PQ/DFNCvM=;
        b=rGD56/LecjA4ecN9EDCJM0AZenCGGzEQBAm2KixEVmJVBebVq3OzFJkGR0UI7gz9tau0ce
        aetK6i7QWZCzUJCw==
Content-Disposition: inline
In-Reply-To: <20210603005517.1403689-5-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Wed 02-06-21 17:55:16, Roman Gushchin wrote:
> Currently only a single inode can be switched to another writeback
> structure at once. That means to switch an inode a separate
> inode_switch_wbs_context structure must be allocated, and a separate
> rcu callback and work must be scheduled.
> 
> It's fine for the existing ad-hoc switching, which is not happening
> that often, but sub-optimal for massive switching required in order to
> release a writeback structure. To prepare for it, let's add a support
> for switching multiple inodes at once.
> 
> Instead of containing a single inode pointer, inode_switch_wbs_context
> will contain a NULL-terminated array of inode
> pointers. inode_do_switch_wbs() will be called for each inode.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>

Two small comments below:

> @@ -473,10 +473,14 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
>  {
>  	struct inode_switch_wbs_context *isw =
>  		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
> +	struct inode **inodep;
> +
> +	for (inodep = &isw->inodes[0]; *inodep; inodep++) {
                      ^^^^ why not just isw->inodes?

> +		inode_do_switch_wbs(*inodep, isw->new_wb);
> +		iput(*inodep);
> +	}

I was kind of hoping that we would save the repeated locking of
bdi->wb_switch_rwsem, old_wb->list_lock, and new_wb->list_lock for multiple
inodes. Maybe we can have 'old_wb' as part of isw as well and assert that
all inodes are still attached to the old_wb at this point to make this a
bit simpler. Or we can fetch old_wb from the first inode and then just
lock & assert using that one.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

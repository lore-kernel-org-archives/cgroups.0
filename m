From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a
 frozen cgroup
Date: Mon, 22 Oct 2012 17:25:05 -0400
Message-ID: <20121022212505.GG5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-6-git-send-email-tj@kernel.org>
 <20121022192506.GA27163@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GCw+NFgjqZMuVtYoTUE0pdhWsWmyhtjJa1n3AuK1hFc=;
        b=FayrpqCrcUthxrbwZn4sTNlxUHa9GiBOUBNCoYHxLQWCG4YcSdeObcqIQ0QV4Mipn0
         rOPF/1EKLbXIGr17VkL6Hvlwk0hqti3mBXnQ6/e3F/U3TdqOzYquVsnqVUtvaFJgHIo1
         BoXh6cEH/mVvcNlqsw4oPinVCX3B13bMHeZttFUiqTtNOeZQFs62c0b6NnOkzMC2swlr
         fAvJdy1mnUkHaxa57a5YnPM87RATRYxfczO5K7efjCMCCgoY0NhqW7WWBUQoCbMu8/Qo
         CIdwbu7RbOj2ddaJy+r9RB8U253TVkhNgWuEJIFxet5XUqr7Xm3egne1eEYPcmWNe9gg
         O2lA==
Content-Disposition: inline
In-Reply-To: <20121022192506.GA27163-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Oct 22, 2012 at 09:25:06PM +0200, Oleg Nesterov wrote:
> > @@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
> >  		goto out;
> >
> >  	spin_lock_irq(&freezer->lock);
> > -	BUG_ON(freezer->state == CGROUP_FROZEN);
> > -
> > -	/* Locking avoids race with FREEZING -> THAWED transitions. */
> > -	if (freezer->state == CGROUP_FREEZING)
> > +	/*
> > +	 * @task might have been just migrated into a FROZEN cgroup.
> 
> Confused. If it was migrated, then freezer_attach() should take care
> do freeze_task?

Hmmm... there's a window where a task is migrated but ->attach()
hasn't completed yet, so freezer_attach() might not have kicked in
yet.  It might not be strictly necessary but I think it's more
consistent this way.  No?

Thanks.

--
tejun

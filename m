From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 13:17:52 -0700
Message-ID: <20120920201752.GA7264@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920193227.GJ4681@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=V4fvBgwkfwQrCDjYo91Ln1LNjEp/uFe+twZlmsm3oMM=;
        b=Y1ci4zcTs0FxpUZpIdmgC0dDw+obpdOdzxlTYJLSU4kPlyWUWeR/vRhCjt05HUY8dS
         yY/bbfRiA6neG0VEzWboSStMNAKJp+ifQTGK+1wh4vsnoma4pBkWZ24Xtn//dK8FQ7mG
         sXF7tOMF0WVHI5ZDfH937+3aOOlyJF8A1g+8D/QyKivH1nxKtJ+H4C5An/VKLhBqPc9L
         LvYsNZGMyKcmMtwHgFiIblFq22VdsrLSfSZlQSO0cmzpf5VKn9RNTKIzFmNfGuLI5ojr
         cQFZfhu8Xz6zSkp6kjMQvVspzDzcfViYzzhdvnz3qeI62TffBzVO+fXjDSv4Y9lmM4hg
         T4xQ==
Content-Disposition: inline
In-Reply-To: <20120920193227.GJ4681-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Vivek.

On Thu, Sep 20, 2012 at 03:32:27PM -0400, Vivek Goyal wrote:
> > Yeah, I incorrectly assumed that bio based drivers would call
> > blk_init_allocated_queue().  I think we need to move the initial
> > bypass_end call to blk_register_queue().  Like the following.  Not
> > completely sure yet tho.
> 
> Hmm.., I am just trying to remember the details hence thinking loud.
> 
> So issue was that we did not want to call synchronize_rcu() in queue exit
> path (ex. cfq_exit_queue()) because some driver could call create/destroy
> queues very frequently during device/disk discovery.
> 
> So we started queue in bypass mode so that if it is destroyed early, it
> will be destroyed in bypass mode and we shall never have to call
> synchronize_rcu().

Yeah, that and it's desirable to ensure that all the fancy stuff is
skipped until initialization is complete.

> So assumption here is that blk_register_queue() will be called by
> add_disk() and hopefully add_disk() will be called by driver only if
> it is not planning to tear down the queue soon. If this assumption is
> right, then this patch should work, I think.

I'm wondering whether there's any use case where a queue is used
without being registered and still require elevator and all other
stuff.  I can't think of any valid use case but am not completely sure
either.

Thanks.

-- 
tejun

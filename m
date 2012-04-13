From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Date: Fri, 13 Apr 2012 14:16:40 -0700
Message-ID: <20120413211640.GH12233@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
 <20120413204710.GF12233@google.com>
 <20120413205501.GL26383@redhat.com>
 <20120413210548.GG12233@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=p7sC8JGwIwIi1GTvHRmx3IsLV7xvUHFyhU1xSRqh3bI=;
        b=n4HoVq0EMhpNVDR2xZ96QkcHeKvrlb1IzUq/yCIIol+DE5vNRghUO1bfxmN71iM0oD
         R2Kdb2SzCJSTx6c8RYadqeq27A9QkOG76/h74ArAsNCp/CKuYXttN6/bZOqVt9pGHUT9
         NbPu3Gkik9oLiIqLXxoBseW4nozgxpb6oqaA/tUykFzpN4oAhxVqghaCkRUMC3D2w6o+
         H/9zIeNI7UGYutJ6xwV4BrPjcyVc9omDiqLQ9MRLtz4NX1fhYHq08+LeCshIz57L4az8
         7c+l1VdMU0nLrQQ8q9WQr9NYnSRGdN1pPIRYv94Sqn3rp9O3dTYV4prOq8pa8aX3k763
         dW1Q==
Content-Disposition: inline
In-Reply-To: <20120413210548.GG12233-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Fri, Apr 13, 2012 at 02:05:48PM -0700, Tejun Heo wrote:
> On Fri, Apr 13, 2012 at 04:55:01PM -0400, Vivek Goyal wrote:
> > But neither seems to be the case here. So to make sure that blkg_lookup()
> > under rcu will see the updated value of queue flag (bypass), are we
> > relying on the fact that caller should see the DEAD flag and not go
> > ahead with blkg_lookup()?  If yes, atleast it is not obivious.
> 
> We're relying on the fact that it doesn't matter anymore because all
> blkgs will be shoot down in queue cleanup path which goes through rcu
> free, which is different from deactivating individual policies.  It
> indeed is subtle.  Umm... this is starting to get ridiculous.  Why the
> hell was megaraid messing with so many queues anyways?

I suppose megaraid depends on sequential LUN scan which SCSI
implements by creating sdev for each LUN, trying to see whether it
actually exists and then destroys the sdev if not.  Urgh.... so, we
seem to be stuck with it.

So, the current code is technically correct although subtle like hell.
We can RCU defer blk_put_queue() from blk_cleanup_queue() using
call_rcu() to make clear that RCU grace period is necessary there.
Any better ideas?

Thanks.

-- 
tejun

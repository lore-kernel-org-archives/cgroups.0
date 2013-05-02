From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Date: Thu, 2 May 2013 10:57:01 -0700
Message-ID: <20130502175701.GL19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=EplLpj3ACk8jImKaDTnjl7Fi+RL2DpTlSovnKvyibiY=;
        b=C9qydidBfnxSOoxeTm5ApUd79eu2mublP8NIb6benKt54fZu6yR8l+6Sh7jxV/Fr7w
         y/PkaSw9r3KWhpMJqgkizAOaFIHP9xkL96in7+Re5KSMnETDNi2ih7DhL6Z1yHI/bncO
         NV6b512QZc2rNoNjHVqTLQXVdEV8QuilvBmJSOGQMibhM5NThYPJuI6VZrcI7V2nIWdM
         sAxqf+k/HnM4Db1iUoSBjCXQUpR+F4BjijmwGaeh4kM2zEuKViWYGNpPuExz/l25jx7c
         uIYq3AMUJL/CXB1/kFXKeWClzshKFZnGUkK3KB2Kj1oCSss1yKVKsWYjEB8S9+1Ukj+G
         KzfA==
Content-Disposition: inline
In-Reply-To: <20130502173428.GA4771-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Vivek.

On Thu, May 02, 2013 at 01:34:28PM -0400, Vivek Goyal wrote:
> On Wed, May 01, 2013 at 05:39:18PM -0700, Tejun Heo wrote:
> 
> [..]
> > While this patchset contains many patches, the implementation is
> > pretty straight-forward.  throtl_grp's form a tree anchored at
> > throtl_data and bios climb the tree as they get dispatched at each
> > level.  The bios which reach the top of the tree - throl_data - are
> > issued. 
> 
> Have a question here. Looks like when bio climbs from child group
> to parent group, then parent group slice starts fresh if parent
> was empty. So if we have a parent with 1MB/s limit and a child with
> 1MB/s limit and a bio gets queued in child, then looks like effective
> IO rate would be .5MB/s and not 1MB/s?

Hmmm.... not that drastic but when the same limit is configured in
both parent and its single active child, the child gets penalized by
about 15%, which is not nice.

> IOW, when child gets queued, we should start time accounting for
> all parents in the hiearchy too.

I don't particularly like doing that as a separate step, maybe we can
just push the child's start time to the parent while dispatching?
Does that sound doable to you?

Thanks.

-- 
tejun

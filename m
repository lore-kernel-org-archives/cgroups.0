From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Wed, 7 Aug 2019 11:31:51 -0700
Message-ID: <20190807183151.GM136335@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-3-tj@kernel.org>
 <20190806160102.11366694af6b56d9c4ca6ea3@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vz8o0/Fg9HbJyVE2ylEHY7Bd2jvJ9o7HmByhNCHje8=;
        b=S/hC9pFyYsK3bBGpkS+QRQZx9iC78MlaFPdHy5dgV03bOA1Dd/SJhJT31pXIM/Vdpr
         pTggs2ww4s5HKZ6Rl822jfjP1lfNILksJxMEIOa1T+LCO8oErZSfUgyFzQR31AWOeOSi
         spJB4tB+m3qzO4p/d+Wyh9B9np+ZwkmgbeoAG2uGbxmQRjowE3F4Kc9wJwRI1Y52Qx9n
         n5/nIcew9FwUxZ1EQwHSBCBD4d/V6vY5SsokAC80mHelGqNJlGBMJsesOifrtC+/Dpu6
         5atcb/gJevn9CWlil28jn8uHgxtBr+UG4Ps4fouBx792PF2Ko3Zbv5IQY43ZLeBdoo6F
         xdmw==
Content-Disposition: inline
In-Reply-To: <20190806160102.11366694af6b56d9c4ca6ea3@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com

Hello,

On Tue, Aug 06, 2019 at 04:01:02PM -0700, Andrew Morton wrote:
> On Sat,  3 Aug 2019 07:01:53 -0700 Tejun Heo <tj@kernel.org> wrote:
> > There currently is no way to universally identify and lookup a bdi
> > without holding a reference and pointer to it.  This patch adds an
> > non-recycling bdi->id and implements bdi_get_by_id() which looks up
> > bdis by their ids.  This will be used by memcg foreign inode flushing.
> 
> Why is the id non-recycling?  Presumably to address some
> lifetime/lookup issues, but what are they?

The ID by itself is used to point to the bdi from cgroup and idr
recycles really aggressively.  Combined with, for example, loop device
based containers, stale pointing can become pretty common.  We're
having similar issues with cgroup IDs.

> Why was the IDR code not used?

Because of the rapid recycling.  In the longer term, I think we want
IDR to be able to support non-recycling IDs, or at least less
agressive recycling.

> > +struct backing_dev_info *bdi_get_by_id(u64 id)
> > +{
> > +	struct backing_dev_info *bdi = NULL;
> > +	struct rb_node **p;
> > +
> > +	spin_lock_irq(&bdi_lock);
> 
> Why irq-safe?  Everywhere else uses spin_lock_bh(&bdi_lock).

By mistake, I'll change them to bh.

Thanks.

-- 
tejun

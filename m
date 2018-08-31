From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 02/15] blkcg: delay blkg destruction until after
 writeback has finished
Date: Fri, 31 Aug 2018 16:19:10 -0400
Message-ID: <20180831201909.GA20194@dennisz-mbp.dhcp.thefacebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-3-dennisszhou@gmail.com>
 <20180831152705.4mjm7xo6jq7ptdqn@destiny>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vk6eJaICnaGPvd/ak8gSgiTZzuoqUM/6teuv/tKzh+w=;
        b=TopJtve0M1jk2OYvgWWQBfCKtk+Fv0HLw7ge+DUSAoydFXq3v2J0ZbIEdj14OOcy8W
         /0fH5/sNsnEQlGv9d8+kgosmxRSNMJzyfaJpOHI5yf35vx4blaxsaFV6E9x8xGCjN8qO
         HXj1OG0Ox5r/j3O0djnSnz1x98dA6+EkuyVg//C1wPReRDp9YPE9vn5dNcmE17eR5fzG
         /d7ri0mHHyRPOZCzYMnmNvGmyC46HT+FZVZmOsVYzIB0h/TS05yy8m9R70FuVGVDyBUU
         +uzN4iiPIFES0Bo7AXF+/F6uT8VXgQH6uLuHq7lxeZtySmEXFeRFIHpynmlhFalhx/1N
         6WMQ==
Content-Disposition: inline
In-Reply-To: <20180831152705.4mjm7xo6jq7ptdqn@destiny>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

Hi Josef,

On Fri, Aug 31, 2018 at 11:27:07AM -0400, Josef Bacik wrote:
> So the general approach is correct, but it's sort of confusing because you are
> using nr_cgwbs as a reference counter, because it's set at 1 at blkg creation
> time regardless of wether or not there's an assocated wb cg.  So instead why not
> just have a refcount_t ref, set it to 1 on creation and make the wb cg take a
> ref when it's attached, and then just do the get/put like normal and cleanup as
> you have below?  What you are doing is a reference counter masquerading as a
> count of the wb cg's, just add full ref counting to the blkcg and call it a day,
> it'll be much less confusing.  Thanks,

Yeah, that makes more sense. I've switched to using refcount_t and
renamed it to wbcg_refcnt. The corresponding actions have been renamed.

I've also fixed the kbuild error in v2.

Thanks,
Dennis

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 12/15] blkcg: cleanup and make blk_get_rl use
 blkg_lookup_create
Date: Fri, 31 Aug 2018 17:29:00 -0700
Message-ID: <20180901002900.GJ1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-13-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=StEz1mAJv0KzVZGP1EaarXGr3LePzazclN3Lxla0Mp0=;
        b=Gx+AmDGBv/s3qria3fxuFzM5YHMkloGdUQ+f0LNYy2qzNN30B5ctsJi/ZczOaKxzKp
         ol1RTToAh6Fj6/FRpNXItJchWh2ri4Ftfaqa40Rbk4yBilWli4TlVfNztJ9xCXSON6L+
         c07PuyyoWxI5+MUUVc+AZ04hbwysuksBfIomrhqMhqHOEKHT6v5HSmGR7Ei9Td5ptZOU
         EgLPpQtHnNw2ubvxx5HOYe8yQ8LFsyn6A4K7fkISn5mwMaQ8sr94jEhPPUk8qOEXNNwQ
         iQd/kqmzja5JV3czwd08abHbjFXZgAz5cKOz572pe6TTJ9OX30XWZhB7p3PB+y6HLX2v
         /+5Q==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-13-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:53PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> blk_get_rl is responsible for identifying which request_list a request
> should be allocated to. Try get logic was added earlier, but
> semantically the logic was not changed.
> 
> This patch makes better use of the bio already having a reference to the
> blkg in the hot path. The cold path uses a better fallback of
> blkg_lookup_create rather than just blkg_lookup and then falling back to
> the q->root_rl. If lookup_create fails with anything but -ENODEV, it
> falls back to q->root_rl.
> 
> A clarifying comment is added to explain why q->root_rl is used rather
> than the root blkg's rl.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

We're replicating that retry busy loop a lot.  It'd be really great to
factor that out and document what it's doing.

Thanks.

-- 
tejun

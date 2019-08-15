From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Thu, 15 Aug 2019 10:34:59 -0700
Message-ID: <20190815173459.GE588936@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-3-tj@kernel.org>
 <20190815144623.GM14313@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2ZSbStm7AbDlXUhKJSg3L8e0NLU9fEch1EIrUdDIspw=;
        b=gfG9UzxThCigCBaKBs4lpzT/DQERj6tRex3zsyhWWtC5mNoRtHY0KVhl1Eusttge/6
         gTa0XkfdlzW5xd0gUiYLS0otjvybVrqu20zk5hDPLSTPCA42Rld4afQ1YnK0eHOHfAvx
         XchEDv5NXEmt5CcVefyG3DYRIVtmobbNBMwDKn8GtVpQKOTUK9LexdYi+sTLctzGyNxe
         TYWo1VhCO+dbNXL98G4TvRHHRh6LRAXKcuaLZV2w+2AsiVgzdSbIulXiEvLbHnLjM9/r
         FAzV2hVYQhnbnkcDrUmUq0qh4De17xFpCKGwoLpS0fpwYewK6JYlJy0m2NMukOuaQRKo
         U9Ag==
Content-Disposition: inline
In-Reply-To: <20190815144623.GM14313@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hello,

On Thu, Aug 15, 2019 at 04:46:23PM +0200, Jan Kara wrote:
> Although I would note that here you take effort not to recycle bdi->id so
> that you don't flush wrong devices while in patch 4 you take pretty lax
> approach to feeding garbage into the writeback system. So these two don't
> quite match to me...

So, I was trying to avoid systemic errors where the wrong thing can be
triggered repeatedly.  A wrong flush once in a blue moon shouldn't be
a big problem but if they can be triggered consistently by some
pathological behavior, it's an a lot bigger problem.

Thanks.

-- 
tejun

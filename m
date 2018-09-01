From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/15] blkcg: rename blkg_try_get to blkg_tryget
Date: Fri, 31 Aug 2018 17:32:50 -0700
Message-ID: <20180901003250.GL1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-15-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AWdzujc9EZFcPTJnRiI7cTrZ1EeyIfooBNTWwxNkX1I=;
        b=C9V3DeVq0q4cwKU4sNcX7iDGR88OyavwgK2WBmo/moPlNeVbGk3ru7PVP1I62cQjag
         hq3WzBPOCy1vGXA1gJ1vn9Nd/5FKi//LdHT1keS7DCf0daY8kdxuLFwbnK3BWgT9tJT/
         EbuXE1ZcZbF5Gp8qltGR4eKfTX4fSDVx8c9ePcJXKuTJIbMgrlguX0UL5yy30vnHo/MG
         WUiCW5YfM2yP5xLwHqr5UyPEx+hI2Hh9P+navxeCf+5szlUvCyCp9COnmBWYfANehBK4
         rysbBTqn1pfg9GrqZNZ0S6hddkoW0hqW4mj/QO8X8s7gyVn/30ZwHJkQKecRlqXL9N4r
         nMKA==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-15-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:55PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> blkg reference counting now uses percpu_ref rather than atomic_t. Let's
> make this consistent with css_tryget. This renames blkg_try_get to
> blkg_tryget and now returns a bool rather than the blkg or NULL.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Mon, 9 Jan 2023 10:40:42 -1000
Message-ID: <Y7x7yq5YmcXhVkQf@slm.duckdns.org>
References: <20230107130738.75640-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DbuOZEmZIWbG5ybltAbzMu36mLXSxbIEjJuDB+5SDZk=;
        b=qN5vtIa6GBLGNWJ37QfuUpC207TmkheSL0UgCYhy9wjkAUbSagihE+plEam1w0V2Xd
         wxYdRh/JdGmP9gLYoDCyJuU5oX6dVxKCKbQ/4wFetqA7FLstX1JQRphWtmeAaM38m9pC
         Q/K9eRGbhgbhyYUEtOo8CYizwshKEk5skvMwTzS8PsoWFUzxH/glfQUtZgmwbEEi20cK
         rCrqGuhNCoeI5wqZxHuHi7ZaThrUuX3wgxpDFVxpNfHpbm5lbsB8/k80q0ZVbNR0T5kX
         eudyCRJQKyrh04Cw0euZz8XEWt+A4oM6TjvTDhx0EW4e3NYfG+ySczOkUbuPmveD8jSK
         xtRw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230107130738.75640-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com

On Sat, Jan 07, 2023 at 09:07:38PM +0800, Jinke Han wrote:
> + * Assumed that there were only bios queued in ASYNC queue and the SYNC
> + * queue was empty. The ASYNC bio was selected to dispatch and the
> + * disp_sync_cnt was set to 0 after each dispatching. If a ASYNC bio
> + * can't be dispatched because of overlimit in current slice, the process
> + * of dispatch should give up and the spin lock of the request queue
> + * may be released. A new SYNC bio may be queued in the SYNC queue then.
> + * When it's time to dispatch this tg, the SYNC bio was selected and pop
> + * to dispatch as the disp_sync_cnt is 0 and the SYNC queue is no-empty.
> + * If the dispatched bio is smaller than the waiting bio, the bandwidth
> + * may be hard to satisfied as the slice may be trimed after each dispatch.

I still can't make a good sense of this scenario. Can you give concrete
example scenarios with IOs and why it would matter?

Thanks.

-- 
tejun

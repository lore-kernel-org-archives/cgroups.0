From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Wed, 8 Apr 2020 22:11:19 -0400
Message-ID: <20200409021119.GJ162390@mtj.duckdns.org>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <20200409014406.GA370295@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PORm90f1pekSo7bdM0jl5Wn3WR0naU3nSTdhyq8uYF0=;
        b=T7Rj9zyj69ZjK6UUEO6kzWCkTN/EwkDBjftpLUmOoy9ZB1aMICdyUvPrhIq0blPOXg
         a4mYkkazrJEhsteIcsHnJPqWFYq+z141WBvuBrxW8zrQqiX/C0Ys7B9XpXXKv9Hvzb/M
         bJxcXhcS62pgMWyykdwMuckw9Bu0QbBtd4wyDLaXCLO3TNufqMnjv2odgNsWl5Vjd9mj
         +OuDDXK11Z87WmD2bgPSFFTQKfbnTjJVF1ZUn0Tjl6Sl9rgvYCR6DrR3NPuOoZukSEMX
         8pjlDSERna/H/T/2EikNzUzxvKbrn2zORX8dJ3+en8mV4cxuYQzhzYEl4rpXU/UTdSW4
         ostQ==
Content-Disposition: inline
In-Reply-To: <20200409014406.GA370295-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org

On Thu, Apr 09, 2020 at 09:44:06AM +0800, Ming Lei wrote:
> Almost all __blk_mq_end_request() follow blk_update_request(), so the
> completed bytes can be passed to __blk_mq_end_request(), then we can
> avoid to introduce this field.

But on some drivers blk_update_request() may be called multiple times before
__blk_mq_end_request() is called and what's needed here is the total number of
bytes in the whole request, not just in the final completion.

> Also there is just 20 callers of __blk_mq_end_request(), looks this kind
> of change shouldn't be too big.

This would work iff we get rid of partial completions and if we get rid of
partial completions, we might as well stop exposing blk_update_request() and
__blk_mq_end_request().

Thanks.

-- 
tejun

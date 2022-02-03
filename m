From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Thu, 3 Feb 2022 12:09:18 +0100
Message-ID: <Yfu33qrQTLTn5X/G@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
 <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
 <Yfkjjamj09lZn4sA@linutronix.de>
 <YflR3/RuGjYuQZPH@dhcp22.suse.cz>
 <YfumP3u1VCjKHE3b@linutronix.de>
 <Yfup9THPcSIPDSoH@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643886559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P9dLipNCWTDLjIRcvw1w4KRMkmUCKyaDC+LsdcGILXU=;
        b=QDRNCbwJulSq9t5Xh04HOv8ePTtDVfMuQTt034qeBLsgpE80y7cSOplg5bJpS4uJZGhtw+
        wc6UOjq9UPSmDE+YXuNGXbMmKbJTJIZ9XjsxFEwJm+6NqD5o0M+efshiP1Ly/7Um07CnOP
        15pzvzuzjhWRNVTdsHEzGEMQfBpENqgwsGzg+mdCV1jF0C8x4l+qUyYITGj82dfL7uoEGW
        xfZ9x5TOmiH/abavhKVmtWfn4+B7Uc9qnvFSrDhNeWKzHBYG2/KPfTL7u1V2qrj0egy8M/
        ZAINbkF5Iyf55flNQmaaGlemu8KmMQR92BnxP6cqvFuGHFeRmQ3Jzfdp95Ew7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643886559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P9dLipNCWTDLjIRcvw1w4KRMkmUCKyaDC+LsdcGILXU=;
        b=lwUjPEVsfXIfH935kV3JAUFh5s5hYmrfTNIqfAtlPw/iNkPURp5YZyrDHhydvyywD+rzqM
        kvt2dX0TvgEVtmCA==
Content-Disposition: inline
In-Reply-To: <Yfup9THPcSIPDSoH-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 2022-02-03 11:09:57 [+0100], Michal Hocko wrote:
> Thanks for this test. I do assume that both have been run inside a
> non-root memcg.

I did run after a regular login on a Debian unstable installation. I did
confirm via trace_printk() that get_obj_stock() was invoked from process
and interrupt context and the caller was cc1 and so on.

> Weiman, what was the original motivation for 559271146efc0? Because as
> this RT patch shows it makes future changes much more complex and I
> would prefer a simpler and easier to maintain code than some micro
> optimizations that do not have any visible effect on real workloads.

Sebastian

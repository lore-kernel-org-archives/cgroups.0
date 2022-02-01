From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 1 Feb 2022 13:11:57 +0100
Message-ID: <Yfkjjamj09lZn4sA@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
 <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643717518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KoYCT5Ajw3bvng7Y4v2BWHQ3eOLblDeukkE/DZmvkTc=;
        b=ULdyc7e2K4mDRfFRC/wPnIuJWqhuADYbGF82VNM4OASlv5mQp9QltsJfg6H7UVgXz6gMlw
        OK3g28o76gTy6Qe4bFW9dGRm7o9M//x6Gh/tsJbg6xbc5dfJ8aPmYGUKAH59p40tBdiWSG
        tXA6+J9jdWVkP6l1s9PZiPmvdPBZw2/d4+zRsxg7UpnUSNJQSCCv5Sx3yJrlcfY7dVIpXx
        yR1FNennWfC+woRakMP2pGOYhvxGHcwNar3PBMNAfE+ZlMNBN9WeoRtbO7zRedjyUzkZDs
        Nth/nyGEwJ7iOAteCtO2L40vxcHrvU2tZ1qgyV0GkmLaQ35bu1GoWo1MVZ876w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643717518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KoYCT5Ajw3bvng7Y4v2BWHQ3eOLblDeukkE/DZmvkTc=;
        b=lkslniCrb4ene2lnwMn/UypCh2//CunFtxqS6YCOcN8cOXDluoDaUYgpxmTsU5WTjgwj3L
        YIU5GTSHFG6HU0Bg==
Content-Disposition: inline
In-Reply-To: <YfkhsiWHzsyQSBfl-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-02-01 13:04:02 [+0100], Michal Hocko wrote:
> 
> Thanks! This gives us some picture from the microbenchmark POV. I was
> more interested in some real life representative benchmarks. In other
> words does the optimization from Weiman make any visible difference for
> any real life workload?

my understanding is that this was micro-benchmark driven.

> Sorry, I know that this all is not really related to your work but if
> the original optimization is solely based on artificial benchmarks then
> I would rather drop it and also make your RT patchset easier.

Do you have any real-world benchmark in mind? Like something that is
already used for testing/ benchmarking and would fit here?

Sebastian

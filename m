From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v5 3/6] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 28 Feb 2022 12:08:40 +0100
Message-ID: <YhytODB1IQFLfx4h@linutronix.de>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-4-bigeasy@linutronix.de>
 <YhyCWQYL8vxRSLrd@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646046521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnquIb5GSTn+DLQ3cN/hm1a1j7DJpMevzJiSlMx6tcs=;
        b=WysKBJ9IkEvnBYFFSQ0+2L3p3tRyVyTwRhP6bOG1UgOvwRUZLIXng9nE+McGX2jnrVCIVN
        +Q3RyRL/+zwL3QpXWF9rUifwBbrXJdav9I2pJLLggORAJqRnsQ7cpl4LRmSNeyv6W1jtd2
        vhVhhE/QnDDGatySQs6sj+1BjqPw1G+MiFvZi8QGij/jE5xdNf4iDdNjJySd2J5A+YGtAl
        NrMP6411jsvyhrJQTIx6M0IXWHfpOO0cKZh4rmugZec5j6bE6lKeLgxwzHdNuolu+WHxqH
        KqoZkdm/8Ew6gxGghv25swpDTOVVrrjNtWKTRO6I0/gJI4jT/d2i4njP/b0YNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646046521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnquIb5GSTn+DLQ3cN/hm1a1j7DJpMevzJiSlMx6tcs=;
        b=lxhZsiARSZXEKvThVxCqZ4Ip9YPS/onIOC4WRpn/SuPwr03p1aB4YQJG2JKj8+3aqTk1TV
        S18EBJ4A1gsYqAAA==
Content-Disposition: inline
In-Reply-To: <YhyCWQYL8vxRSLrd-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 2022-02-28 09:05:45 [+0100], Michal Hocko wrote:
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> TBH I am not a fan of the counter special casing for the debugging
> enabled warnings but I do not feel strong enough to push you trhough an
> additional version round.

do you want to get rid of the warnings completely? Since we had the
check in memcg_stats_lock() it kinda felt useful to add something in
__memcg_stats_lock() case, too.

> Thanks!

Sebastian

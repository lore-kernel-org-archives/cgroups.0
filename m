From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Fri, 3 Feb 2023 09:42:11 -0800
Message-ID: <Y91Hc3Iu+5VyyIwS@P9FQF9L96D.corp.robot.car>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Y9tz+0J9fw+Z+O+O@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675446142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZYvx87/bApyuUVwX/LObDHee8cS4wUlkoRlwfbD39PE=;
        b=LGHrzaZwAx29gBlXOkLljkso6NQ92suLDFaEogkOQt1FEn3w8ek0TBLiGtVX57Q8fwq3qI
        LZCTIUAkK3mdrLn3A5V/7RuWxv9SpZkZtBTARwGqciKa8ttsyGiY2Z+CaaY2plO61J4wrr
        o7dBN5HJfu98Di+SvTaYhw2SUg3NLNM=
Content-Disposition: inline
In-Reply-To: <Y9tz+0J9fw+Z+O+O-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Thu, Feb 02, 2023 at 09:27:39AM +0100, Michal Hocko wrote:
> On Thu 02-02-23 12:32:57, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > 
> > Introducing memory.root_current for the memory charges on root_mem_cgroup.
> 
> Charges are not currently accounted for the root memcg universally. See
> try_charge which is used for all user space and skmem charges. I am not
> 100% sure about objcg based accounting because there is no explicit
> check for the root memcg but this might be hidden somewhere as well.

root_mem_cgroup has no corresponding obj_cgroup: see memcg_online_kmem().

Thanks

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Thu, 2 Feb 2023 10:24:08 -0800
Message-ID: <CALvZod5E0s9Vu3wq-Fuvs9z=ViMADn3aNL0f56ELGmFzxKCtkg@mail.gmail.com>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com> <Y9tz+0J9fw+Z+O+O@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s9NS8aTMNXwzeLlthekcCZHp7SQir7/xZefiPP7egKI=;
        b=ZPrIb7wo+lofZV5pa5YbET3hAij+R6gpmGf56bGzIiJJZm+b1Ydw+1BC5EDCg2BRow
         DbYAkHwSC6cnMronH3NtmDtuswD6tOv1DfX+TKKrEx03PJQaXqg/IZx3QuurzljeH5mJ
         Dhw7d+sAJ5ylmkLJZLxFcgRhg9vpP/91oQdt5ywhgqHdD47r4rU36XdbzTm25eOxOI1f
         TjiMYRf3uyMJrt3faPsFxTFVo25AhVanE7TU8icH+qr8A38Aii6b39F4sPLQ0rIAhjka
         bOy1FLkVCcegtisV0H4khc5iWpFJyjpX0m35PRB5Fvo9nUMDpO+FxWF5rxT5xj2++t1n
         7qow==
In-Reply-To: <Y9tz+0J9fw+Z+O+O-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Thu, Feb 2, 2023 at 12:27 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 02-02-23 12:32:57, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> >
> > Introducing memory.root_current for the memory charges on root_mem_cgroup.
>
> Charges are not currently accounted for the root memcg universally. See
> try_charge which is used for all user space and skmem charges. I am not
> 100% sure about objcg based accounting because there is no explicit
> check for the root memcg but this might be hidden somewhere as well.

Yes in __get_obj_cgroup_from_memcg(). However the reason to use
try_charge_memcg() to bypass root check was to avoid the race with
reparenting. More details in c5c8b16b596e ("mm: memcontrol: fix
root_mem_cgroup charging").

>
> That means that the patch as is doesn't really provide and usable value.
> The root exemption has been removed in the past but that has been
> reverted due to a regression. See ce00a967377b ("mm: memcontrol: revert
> use of root_mem_cgroup res_counter") for more.
>

One advantage I can see is if someone is looking for usage for all top
containers (alive or zombie) but I wanted to know if that was the real
motivation behind the patch.

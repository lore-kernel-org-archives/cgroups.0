From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Fri, 25 Mar 2022 11:02:48 +0800
Message-ID: <CAGWkznGLO7xpQK7E07dLv7ZfO53nx2fn54tVNw7-b46QnzKwkA@mail.gmail.com>
References: <1648113743-32622-1-git-send-email-zhaoyang.huang@unisoc.com> <Yjx/3yi7BfH7wLPz@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXw7xeLeRy4CF/DJ1L3E3FO28dCYqTRXx8i65wk03SM=;
        b=i3tLANoBQ65aqlcXFlYzSLX4QHJwH8thr4YSc0xJn+rmAD4/12eYEQVAiAtkKdKfze
         cTUtDDsSOP5Lf9bfqK3clzmDl8TQ3irN4H7Gq7VuN+T7vdJODwzFKzLmsbqVJ26t5aky
         dchNbp6g6YKqxdvVCeVUnqw8EJnsvKx0YeP8dJcCc+WPHPmXVlAMvwVB4Z2Ctokdtu/f
         XqDRH51/5X2MfyFn3yUiyutjkNjKxV5O6GHCdNXemO+YzWmBoOGEnJeUAOr3rcA/cRyJ
         +JfrZBTtvFJ2QMZlnR888eNq2R9NnKEjJMOsB7IyiTwvVLJpNBYO2e89eBSdyJP1/G28
         gwOA==
In-Reply-To: <Yjx/3yi7BfH7wLPz-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 24, 2022 at 10:27 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> I'm confused by the aims of this patch. We already have proportional reclaim
> for memory.min and memory.low, and memory.high is already "proportional" by its
> nature to drive memory back down behind the configured threshold.
>
> Could you please be more clear about what you're trying to achieve and in what
> way the existing proportional reclaim mechanisms are insufficient for you?
What I am trying to solve is that, the memcg's protection judgment[1]
is based on a set of fixed value on current design, while the real
scan and reclaim number[2] is based on the proportional min/low on the
real memory usage which you mentioned above. Fixed value setting has
some constraints as
1. It is an experienced value based on observation, which could be inaccurate.
2. working load is various from scenarios.
3. fixed value from [1] could be against the dynamic cgroup_size in [2].

shrink_node_memcgs
     mem_cgroup_calculate_protection(target_memcg, memcg);          \
     if (mem_cgroup_below_min(memcg))
             \    ===> [1] check if the memcg is protected based on
fixed min/low value
     ...
                                        /
     else if (mem_cgroup_below_low(memcg))                                     /
     ...

     shrink_lruvec
            get_scan_count
                                              \
                   mem_cgroup_protection
                                         \ ===> [2] calculate the
number of scan size proportionally
                   scan = lruvec_size - lruvec_size * protection /
(cgroup_size + 1);        /

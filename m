From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: fix memcg_size() calculation
Date: Tue, 17 Dec 2013 11:48:20 +0400
Message-ID: <CAA6-i6rX7-F9UO2DO3gwC2SHNuSv2Fn48eLb1BZmc3HjCkbuvQ@mail.gmail.com>
References: <965cbb70fb55fe50a77382537b9a1b7455deac86.1387007793.git.vdavydov@parallels.com>
	<20131216164730.GD26797@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ohEM5S4jzGAKpHpwWtmi0ktIMN59veLZS3vssarDBTY=;
        b=v/D7BjUIIzNj9+i4q3K7agdu5clAz3EnvpXfBoQLZ9SEv6v5JiQfW/2vg7N4cInAbI
         RFHCggbYht6DAdXnrr/khduYuIsMG4b4GsBjFb+hZU5Dy+qTTBHj3cDMN8F5vkI6f5bu
         S3l1t9Sri7/kShFUdZ6Hq5bPHxE9FVXbYe18MH1gewzl5scVfU0C+AGvrmeyx2Zmngyh
         ZY6IweeiYi/JMZMxjPpRIhvsoYdu3kRGN9ZeFGkylAYvdbmfZFfZiIZBwYwCbAWFuOGB
         YiI9DJFuANIMuhVLtSD9/5+jZbGyqp3g6AGuI6Yf/AT6g7WClMRwyWPRj3NDXNpahXId
         ABUg==
In-Reply-To: <20131216164730.GD26797-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon, Dec 16, 2013 at 8:47 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Sat 14-12-13 12:15:33, Vladimir Davydov wrote:
>> The mem_cgroup structure contains nr_node_ids pointers to
>> mem_cgroup_per_node objects, not the objects themselves.
>
> Ouch! This is 2k per node which is wasted. What a shame I haven't
> noticed this back then when reviewing 45cf7ebd5a033 (memcg: reduce the
> size of struct memcg 244-fold)
>
IIRC, they weren't pointers back then. I think they were embedded in
the structure, and I let
them embedded.
My mind may be tricking me, but I think I recall that Johannes changed
them to pointers
in a later time. No ?

In any case, this is correct.

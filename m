From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Fri, 19 Mar 2021 12:27:55 -0400
Message-ID: <YFTRCwqMAhLtST17@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
 <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk>
 <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
 <8c32421c-4bd8-ec46-f1d0-25996956f4da@kernel.dk>
 <20210318164625.1018062b042e540bd83bb08e@linux-foundation.org>
 <CALvZod6FMQQC17Zsu9xoKs=dFWaJdMC2Qk3YiDPUUQHx8teLYg@mail.gmail.com>
 <YFTIepcb+qm/+/9d@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <CALvZod7TyCb1c9iPYmf4aGiCgcb9fboRDXiChaYDCBQHii+J7A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GB8fLktR1tASbymjnw9MkDMpjTuRuzJA8+s7LyK6qUQ=;
        b=eJed0rdQmwld1oV5DxS1T1YtkrbMaqJ1tOXo4HOxJxPS7I0t+1BK1131yQRBhY0c+0
         +a19lDqoVbwMkqJ82rQqePPUQ9PQsCtUDy8dYdAWEZ6ojU4Wja4Sa4dsigEXtLkusiAX
         GwgC6POaDS39VhIA0yTzLD0JhB8xhftzQA/wNElUk22lu3izcL2tBGh+Cnki9jK2xWQ7
         uhfknpBJPZZTt0x9RtA1Pmg8VO1WL63RdOe0FZCCxheqUERCc5UD+VlODkT+eU8ByBfJ
         EfFzXqR1JWhWqQx4m5oiK+OavkbxjJSsntwEFUP45GWG0Ec3ppbzWr26IleYojzHc/Q7
         B2Yg==
Content-Disposition: inline
In-Reply-To: <CALvZod7TyCb1c9iPYmf4aGiCgcb9fboRDXiChaYDCBQHii+J7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Mar 19, 2021 at 09:20:16AM -0700, Shakeel Butt wrote:
> One suggestion would be to make get_mem_cgroup_from_mm() more generic
> (i.e. handle !mm && active_memcg() case) and avoid
> get_mem_cgroup_from_current() as it might go away.

Yeah, that occurred to me as well. I'll take a stab at doing that.

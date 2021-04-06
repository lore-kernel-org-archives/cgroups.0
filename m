From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Tue, 6 Apr 2021 11:23:01 +0800
Message-ID: <CACVXFVPR+OLtPc6G-PTHNm+ro6LpzcHxxuCoFTcWHb6fmyRbKQ@mail.gmail.com>
References: <20210402191638.3249835-1-schatzberg.dan@gmail.com> <20210402191638.3249835-4-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyUOqQqREwsmvr/dLosqt/ckIIZfER6FkNAdfyxy9uY=;
        b=t5E2hut5WjKDzvQgOPwKuWQEq9EGSvzfR4OC4bI5V7kIwUyaF3zmDBhabi5rJR82dg
         AnGwqHeGRP6h3UESEig0+hJQB2IBOmiRAmBgURVaoyk9vQ0O+woNrdMk1LV+16lPeea9
         ddoNDVZmu9CcAZMMK2ApcYu/kApWdEpBz5/sCv9FDAU/SHYE3FAlPSazpvvjzTTuA1EL
         xnupfEfwm7VYjfIRK0SYocYabKzWKVNtQlgnuLJNQTgozntliBKA4h8F1xT+wBcDd9HJ
         tnLb9D7qBtuLEFYr8XYbWepN3ak3DdRi/t+G/Ye5MQ4cl/lwY5UPsDjFasIKY1QxCrua
         5yZA==
In-Reply-To: <20210402191638.3249835-4-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Sat, Apr 3, 2021 at 3:18 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> The current code only associates with the existing blkcg when aio is
> used to access the backing file. This patch covers all types of i/o to
> the backing file and also associates the memcg so if the backing file is
> on tmpfs, memory is charged appropriately.
>
> This patch also exports cgroup_get_e_css and int_active_memcg so it
> can be used by the loop module.
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Ming Lei

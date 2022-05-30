From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH mm v3 9/9] memcg: enable accounting for perpu allocation
 of struct rt_rq
Date: Mon, 30 May 2022 23:06:09 +0800
Message-ID: <CAMZfGtVv93QUmLfjzth1pxxFij8h8z3rH31a59Zov-7B-nxC3g@mail.gmail.com>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <cover.1653899364.git.vvs@openvz.org> <a1fcdab2-a208-0fad-3f4e-233317ab828f@openvz.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Af0PSK5bhyw9+f+5DkDwRAOmIX0S8zU96NIHBAioFvc=;
        b=IIUreoS7YFV8tvzCexC8C65TTMCRXB26Hzfj1WudjM4xZIb+eJy1GTgJE7v5pBwaLi
         BfFwoQfmw0ItOSvZ+sEnt3bkqNXDBUPKLLBxZYnVZ7CVifzBnCPIaIWhGOdfabqXH6w6
         clYvnNL18cS0xSDtPHaLcVdPriA/r2wd9ac0t2vHh49MxZH9oyXzW4AAhyUp01E1GQgC
         xk4YuwgEOBgnf70nSpzqvHu6gYJEaiAdXTCaZJPXM+hB3/Y3r70sL6YmOueUYYT3nasr
         DxASAvBlFVVTn5rcZ73N1fwxFgdkwVWpRVMEJ0L8Fakf/zrEUGEGZmaeHUFX/49dPEyp
         yung==
In-Reply-To: <a1fcdab2-a208-0fad-3f4e-233317ab828f@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>

On Mon, May 30, 2022 at 7:27 PM Vasily Averin <vvs@openvz.org> wrote:
>
> If enabled in config, alloc_rt_sched_group() is called for each new
> cpu cgroup and allocates a huge (~1700 bytes) percpu struct rt_rq.
> This significantly exceeds the size of the percpu allocation in the
> common part of cgroup creation.
>
> Memory allocated during new cpu cgroup creation
> (with enabled RT_GROUP_SCHED):
> common part:    ~11Kb   +   318 bytes percpu
> cpu cgroup:     ~2.5Kb  + ~2800 bytes percpu
>
> Accounting for this memory helps to avoid misuse inside memcg-limited
> containers.
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

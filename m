From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: make cgroup_memory_noswap static
Date: Thu, 21 Apr 2022 08:25:25 -0700
Message-ID: <CALvZod6zbOG_fBCYGufm=fJrA-yZH4AWrThapFb3Gm_4ACQoeA@mail.gmail.com>
References: <20220421124736.62180-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3X/olzZyiEOTaDnSyvUQfJTotSJF//8MOqgCU8Vd1Hk=;
        b=EY3vQ8aQYxoLMh83TYT+sWZvvXQ5Q00X8s+8TVct4w2bwn28LSqEbXyWHMkfT764BX
         X7kAMRbROJdVuSuhy0oW4ukxJYDi9452CKht+efnYSRj+5mnACYOmLbXO3H4g7DqdGwQ
         TItWlo987dF8taxXxRwH1XTOjLsHO1rrWiCpLZB33gx7+iMoCqZsfhw1DCiayNGZUQFz
         LRJCnjLv63jX+dsQrIA/F+cVj3MRpm+zKCrObpwM2GZksgRphVhFiwVQMSULFFFFAxiG
         77MBLO77H7Ck9de/bqGmfgdY4aHJs3CZYx78B5HWsmwJv0Ejy0OkGYbfeyEOOcEidDjt
         El9A==
In-Reply-To: <20220421124736.62180-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Apr 21, 2022 at 5:48 AM Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
> it static, and remove export in include/linux/memcontrol.h
>
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

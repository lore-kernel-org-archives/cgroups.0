From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in memory.reclaim
Date: Thu, 10 Nov 2022 11:35:34 -0800
Message-ID: <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g@mail.gmail.com>
References: <20221110065316.67204-1-lujialin4@huawei.com> <20221110144243.GA10562@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzjw3odtvlQil/jHlpnewBAjOSpFW5cV80T6OAYFKjY=;
        b=iuaYqdwZM/0oCPWc93mIY0NicjiJhw7/rvxeaarjT1Tqf5ZHSLmKsKcf7baqlRZzGW
         48G7ydGLqDDqE6J6z5KkTZTsT6IPlVP9/NuCrbkuyC0ICfrf0mTe64olZVw4TUCHsHMz
         exlcuIbh+46O5BTFQ7fbnEIKz+5LZav8ff5cDQmxpnLZa4hPCawhSu8wtZ25bYO3uJCY
         yo/PRhoXv3c4U/NLMsEsT/3BfQJPlZcpCrHjsgK3t47W6BptStFIaAV97x3GKxq3sQF/
         ArH6DTw1RQswDn2xtHiVHAZhACBR/S7NMkmMMP+mUCvFTFHflwGVYX8uEDZ5rbAAicnY
         H9ow==
In-Reply-To: <20221110144243.GA10562-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Nov 10, 2022 at 6:42 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hello Jialin.
>
> On Thu, Nov 10, 2022 at 02:53:16PM +0800, Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org=
> wrote:
> > When user use memory.reclaim to reclaim memory, after drain percpu lru
> > caches, drain percpu charge caches for given memcg stock in the hope
> > of introducing more evictable pages.
>
> Do you have any data on materialization of this hope?
>
> IIUC, the stock is useful for batched accounting to page_counter but it
> doesn't represent real pages. I.e. your change may reduce the
> page_counter value but it would not release any pages. Or have I missed
> a way how it helps with the reclaim?

+1

It looks like we just overcharge the memcg if the number of allocated
pages are less than the charging batch size, so that upcoming
allocations can go through a fast accounting path and consume from the
precharged stock. I don't understand how draining this charge may help
reclaim.

OTOH, it will reduce the page counters, so if userspace is relying on
memory.current to gauge how much reclaim they want to do, it will make
it "appear" like the usage dropped. If userspace is using other
signals (refaults, PSI, etc), then we would be more-or-less tricking
it into thinking we reclaimed pages when we actually didn't. In that
case we didn't really reclaim anything, we just dropped memory.current
slightly, which wouldn't matter to the user in this case, as other
signals won't change.

The difference in perceived usage coming from draining the stock IIUC
has an upper bound of 63 * PAGE_SIZE (< 256 KB with 4KB pages), I
wonder if this is really significant anyway.

>
> Thanks,
> Michal

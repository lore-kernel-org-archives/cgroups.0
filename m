From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: optimize per-lruvec stats counter
 memory usage
Date: Tue, 8 Dec 2020 18:28:50 -0800
Message-ID: <20201209022850.GC2385286@carbon.DHCP.thefacebook.com>
References: <20201208095132.79383-1-songmuchun@bytedance.com>
 <20201209022118.GB2385286@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oB2by1Ra07Mac1TV4ubkEGeWAms1163mRFDXdVWzvBI=;
 b=E5Kq6SKS3iSIUv61ab5rnDkuLl8gNkMQnh99e6JPlKfrevrqHFTChHbSnOi8lETFgK0W
 wrhDq0hIw1ZUoB3EfVQNq7rQZa4BvcdiZggD/p1P7JXk+RKQ657GzQJV8V/Cb4HbZhMw
 XZeyBsHsj8JcofWd3LoyEF/If9X9BvUMQAg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oB2by1Ra07Mac1TV4ubkEGeWAms1163mRFDXdVWzvBI=;
 b=fNFDbVP0l4WuVoaIQuuZBF9gDqUohtITiaKvZxszipBlbAYFdsLk1eqBqCsIl6uLSwM0MqV12Dz/1hQ00+nZpZhARiyxMC2M6OilWOoU28FZURbnKlg6V++vOJF7yL39MzuK2L36Goz649+/Yx1CJURYpFXmZkY5ad9OZ4GNasQ=
Content-Disposition: inline
In-Reply-To: <20201209022118.GB2385286-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Dec 08, 2020 at 06:21:18PM -0800, Roman Gushchin wrote:
> On Tue, Dec 08, 2020 at 05:51:32PM +0800, Muchun Song wrote:
> > The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> > of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> > to optimize memory usage.
> > 
> > The size of struct lruvec_stat is 304 bytes on 64 bits system. As it
> > is a per-cpu structure. So with this patch, we can save 304 / 2 * ncpu
> > bytes per-memcg per-node where ncpu is the number of the possible CPU.
> > If there are c memory cgroup (include dying cgroup) and n NUMA node in
> > the system. Finally, we can save (152 * ncpu * c * n) bytes.
> 
> Honestly, I'm not convinced.
> Say, ncpu = 32, n = 2, c = 500. We're saving <5Mb of memory.
> If the machine has 128Gb of RAM, it's .000000003%.

My bad, it's actually
(32*2*500*152)/(128*1024*1024*1024) = .0035%

but it's still in the noise.


> 
> Using longs (s64) allows not to think too much about overflows
> and can also be slightly faster on 64-bit machines.
> 
> Thanks!

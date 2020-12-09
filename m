From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: optimize per-lruvec stats counter
 memory usage
Date: Tue, 8 Dec 2020 18:21:18 -0800
Message-ID: <20201209022118.GB2385286@carbon.DHCP.thefacebook.com>
References: <20201208095132.79383-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xfwR2nE23+/4cUSXy7PEa+70+zQC3cmeVhVai4i1q6U=;
 b=mEMkusAX4OJr6/0Jt7UWCapOJRsULO155QtQEdpJFJRs9vj62HlKwi4Lh+SA5fKiH12R
 BXs+EVXFLRXdiHWqut1zfiA15hVUm7sRZbkhWs88dhnxZvTUoO6YNRKRGdHMYpC4BH8Q
 HZ1Ca4NzljcKkkJ3XadXos7sgFJfogFmfOE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfwR2nE23+/4cUSXy7PEa+70+zQC3cmeVhVai4i1q6U=;
 b=IqdSP1RlMwdTljZxKFnyUXdwXqE/JFSHSWcFPYjsnsqRNsfPWmrEAdu8igK+6NFYdVTUubGfCp5kDy/Jc+MZo9yayeSFbDE5ZofliueAaJp2IuGITCnwTrekB5c4cDSZFTqi+I7t7j/jJ5JWp6VgT5VvCHUcYSrqaWImWGbXpzc=
Content-Disposition: inline
In-Reply-To: <20201208095132.79383-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Dec 08, 2020 at 05:51:32PM +0800, Muchun Song wrote:
> The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> to optimize memory usage.
> 
> The size of struct lruvec_stat is 304 bytes on 64 bits system. As it
> is a per-cpu structure. So with this patch, we can save 304 / 2 * ncpu
> bytes per-memcg per-node where ncpu is the number of the possible CPU.
> If there are c memory cgroup (include dying cgroup) and n NUMA node in
> the system. Finally, we can save (152 * ncpu * c * n) bytes.

Honestly, I'm not convinced.
Say, ncpu = 32, n = 2, c = 500. We're saving <5Mb of memory.
If the machine has 128Gb of RAM, it's .000000003%.

Using longs (s64) allows not to think too much about overflows
and can also be slightly faster on 64-bit machines.

Thanks!

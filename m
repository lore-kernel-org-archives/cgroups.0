From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC 2/2] memcg: Adapt cgroup.top into per-memcg
Date: Fri, 26 Aug 2022 09:38:19 +0200
Message-ID: <Ywh4a0NBL3QNMGYS@dhcp22.suse.cz>
References: <20220826011503.103894-1-lujialin4@huawei.com>
 <20220826011503.103894-3-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661499500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RtYcNt5XkJRCJhjOhp/OsUYuN7jr0K2tW7LntfrhxP0=;
        b=I83xBB1b8caTVTsQfISvp8FIA6foX4NceUMAUYAmwPJBwHop0a0Gzweik2JXe457EyMmtN
        lSClOj6h8yDjeJxxWe7yi6oWSwq5m/lU52xMew9cIuPfHGqSESJsh2j1xWq98TMK759ova
        nDVuukr7lE2gmxo6ybIB1sxADXm6izM=
Content-Disposition: inline
In-Reply-To: <20220826011503.103894-3-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 26-08-22 09:15:03, Lu Jialin wrote:
> cgroup.top is able to show resource usage information for each cgroups.
> Currently only memory usage is monitored ,including usage,anon,file,
> kmem(Bytes), stats for other resource types would be added as well.
> 
> Show case:
> / # mount -t cgroup2 none /sys/fs/cgroup
> / # cd /sys/fs/cgroup/
> /sys/fs/cgroup # echo "+memory" > cgroup.subtree_control
> /sys/fs/cgroup # mkdir test1
> /sys/fs/cgroup # mkdir test2
> /sys/fs/cgroup # mkdir test3
> /sys/fs/cgroup # echo $$ > test2/cgroup.procs
> /sys/fs/cgroup # cd /test
> /test # ./memcg_malloc 512000 &
> /test # ./memcg_malloc 512000 &
> /test # ./memcg_malloc 512000 &
> /test # cd /sys/fs/cgroup
> /sys/fs/cgroup # echo $$ > test1/cgroup.procs
> /sys/fs/cgroup # cd /test
> /test # ./memcg_malloc 512000 &
> /test # cd /sys/fs/cgroup
> /sys/fs/cgroup # echo $$ > test3/cgroup.procs
> /sys/fs/cgroup # cat cgroup.top
> memory top:
> name            usage           anon            file            kernel
> test2           1974272         1671168         0               270336
> test1           700416          569344          0               94208
> test3           196608          86016           0               86016

This information is already present in memory.stat and can be easily
post-processed to generate similar output. Why is that insufficient?
-- 
Michal Hocko
SUSE Labs

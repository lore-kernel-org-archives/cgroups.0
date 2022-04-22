From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: make cgroup_memory_noswap static
Date: Fri, 22 Apr 2022 10:23:02 +0800
Message-ID: <YmIRhikdGutx6TeE@FVFYT0MHHV2J.usts.net>
References: <20220421124736.62180-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/r6xw+gj3ZTku8Ban2Ty+342ukm24iTASQaEDp2KNQM=;
        b=Ib8b5bLDkA26LrA6dCcYGi19rtQ+3Mrl6DdFt3V0pfQltiTIh6katrX1tWJQA7hCPd
         41Ga7W4SB7elDpM08p0ULKc3OfwLM6N4aOwQPVAfvEhJnVZiiNDQYp9a+gv/dEQ/GO75
         C/Y0//i7ekOZj7Xi+eB06n63ANAWPwLyckiVSNQynddV6XvJSIcaiYOEP2mvAmjIZKyu
         BvnD/t/fseEXFrc45GU4xVEBEun6biSDbiELpy+XpCabvEPJ4OUYK+VQM/XB0NiUytoC
         Wno6y/lSbCTrO5OY4/A7HcRrEmE8XfnxzYt8dHvQa7pcRY2iAgGWzRo1ydNtrNOaZ8XH
         1SUg==
Content-Disposition: inline
In-Reply-To: <20220421124736.62180-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 21, 2022 at 08:47:36PM +0800, Lu Jialin wrote:
> cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
> it static, and remove export in include/linux/memcontrol.h
> 
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: Removed duplication detection for mem_cgroup_uncharge_swap
Date: Sat, 19 Aug 2023 22:15:12 -0700
Message-ID: <CALvZod6AmsQb+srO5JjMQH0xFx_Ybu=KxdrX+i+f7BzbK1DUiA@mail.gmail.com>
References: <20230819081302.1217098-1-lujialin4@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692508524; x=1693113324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHzkhq/2CNg7lFMLeaog/UrvW1UqZ1CtPUmwbLqtOso=;
        b=nrQiyjOjJgcaUd2bk6SQdWj5LUoQRiQaNvV3OXquVrONrch9Wsbd6GIbPFmmNEDNyB
         29owdNMnZkMOs9CZbup2nYnf6BB+WZq+G0JsrFFj4u+ZZY142ePVUn2zyprs6B+dZxnZ
         K81VlDP+tLe+QLce0rYfnTKWFi6pmJq61kqfwBs0We34X0KJJdMSBeJA2zPHPReDhI13
         2Provo2k/OOGfiUny7nal9athlK4IcTcBWLf3C0BOx7s6erKTG+PVzRpIZTZPJlqLppA
         x+oyDUjXk43LQTeqPoRWboN4p6Bi/3/2tv5ZQPt8lwGOpRvUDK7JvThsVsCHwEcOuvrP
         EG1w==
In-Reply-To: <20230819081302.1217098-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat, Aug 19, 2023 at 1:14=E2=80=AFAM Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> __mem_cgroup_uncharge_swap is only called in mem_cgroup_uncharge_swap,
> if mem cgroup is disabled, __mem_cgroup_uncharge_swap cannot be called.
> Therefore, there is no need to judge whether mem_cgroup is disabled or
> not.
>
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

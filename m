From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Date: Sun, 16 Jan 2022 11:24:03 -0800
Message-ID: <CALvZod5ycSmk7URBoLGGJAiyjGQ1E0HR2RnJ-3uZai=t+KpEKA@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com> <20220111010302.8864-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6evELW+tkD7CtjU/q82JAh8zwV9sibyS+oVT1wgMIo=;
        b=pS/LRlqPd2v795c2ySY+8PL8UpC5Zl/zUN5+ti7B4CoFeYTvYKCSFwKmMbUVOPcDVc
         7eDStVWQH+iALVLXbJ//2+WauF9fp7eC+h+NWylp10lReOm2dExRzmxX6TmsUpamL0FA
         3mhzljQgdxIjCnOhaoIUlIh/xT31WP7v/ZND528u73eUybliaipUhuZ8Myurkri9/Bn0
         VMYcEsiO5g5dBYFv1judak18DlWxlI2misGKjlM0Uy/c9j5/lFYy/XHbPdCQhuXVVchu
         erkNGuEzUvBLWQC3ykVipjL4zjFm2geGKSIDKJvecb5eGqp9umVpwKPwj9v6mlgDm1G1
         E4Cg==
In-Reply-To: <20220111010302.8864-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Jan 10, 2022 at 5:03 PM Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> kzalloc_node() would set data to 0, so it's not necessary to set it
> again.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

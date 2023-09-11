From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on
 cgroup1
Date: Mon, 11 Sep 2023 10:24:33 -1000
Message-ID: <ZP93gUwf_nLzDvM5@mtj.duckdns.org>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf+bounces-9689-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694463875; x=1695068675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=teqXbckacJlPukkv2EFTdTd3A90eXZl+lHL7XzD31Z4=;
        b=DpHY+9vxUaEI1Fad0tiIOzAyr/aptpRy9NijKgVkqLrFb1xQEx7GrBafGOfgVJXH9m
         yDLjnGpm5+OVPTEVBZqh8KMhLeczjGF4vXJ7yCK8pSe6+z6ltjSFevu8+tzlyNGymPeC
         vlWOUGzjsrdT6KPv00in7cGpDHELyMxr80pqaA643YDy9KPnek7VKG4WsSCtwPMyQAmQ
         BAJnl9ALyV6zFmkATx7VhmUdK3JjtnAeiMjPejypMkvnphZNyDoUfrJixEyhLarjNUHa
         dKcrHOMSUuD890STU9dINFvTI74jm7xxPrt6RCt5rFWTf39n5Vu60bws/TuKqYRkwTEi
         TfNQ==
Sender: Tejun Heo <htejun@gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Sun, Sep 10, 2023 at 11:17:48AM +0800, Yafang Shao wrote:
> To acquire the cgroup_id, we can resort to open coding, as exemplified below:
> 
>     task = bpf_get_current_task_btf();
>     cgroups = task->cgroups;
>     cgroup = cgroups->subsys[cpu_cgrp_id]->cgroup;
>     key = cgroup->kn->id;

You can't hardcode it to a specific controller tree like that. You either
stick with fd based interface or need also add something to identify the
specifc cgroup1 tree.

Thanks.

-- 
tejun


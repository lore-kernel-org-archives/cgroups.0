From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 12:09:33 -0700
Message-ID: <CALvZod4n+_zo7fkn=NfRSKeShHbarUPWL3D=uScZmg9aiKkP-w@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
 <CAJD7tkbziGh+6hnMysHkoNr_HGBKU+s1rSGj=gZLki0ALT-jLg@mail.gmail.com>
 <CALvZod5GT=bZsLXsG500pNkEJpMB1o2KJau4=r0eHB-c8US53A@mail.gmail.com>
 <CAJD7tkY6Wf2OWja+f-JeFM5DdMCyLzbXxZ8KF0MjcYOKri-vtA@mail.gmail.com>
 <CALvZod5mJBAQ5adym7UNEruL-tOOOi+Y_ZiKsfOYqXPmGVPUEA@mail.gmail.com>
 <CAJD7tkYWo_aB7a4SHXNQDHwcaTELonOk_Vd8q0=x8vwGy2VkYg@mail.gmail.com>
 <CALvZod7f9Rejb_WrZ+Ajegz-NsQ7iPQegRDMdk5Ya0a0w=40kg@mail.gmail.com>
 <CALvZod7-6F84POkNetA2XJB-24wms=5q_s495NEthO8b63rL4A@mail.gmail.com>
 <CAJD7tkbGCgk9VkGdec0=AdHErds4XQs1LzJMhqVryXdjY5PVAg@mail.gmail.com>
 <CALvZod7saq910u4JxnuY4C7EwiK5vgNF=-Bv+236RprUOQdkjw@mail.gmail.com>
 <CAJD7tkb8oHoK5RW96tEXjY9iyJpMXfGAvnFw1rG-5Sr+Mpubdg@mail.gmail.com>
 <CALvZod5USCtNtnPuYRbRv_psBCNytQWWQ592TFsJLfrLpyLJmw@mail.gmail.com> <CAJD7tkad5NbqjXZ1qLaNx1g-FYsrv-BVLcNinycFStG_Bu0_zw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679598585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLtQVw9Q3r/EIfGHaHQqJXqtgGhueRqlggc/xqxY+5U=;
        b=iWmN5qdQNSjpgISH3j2kib5cc+h8AoBaK9c2AaVVVURUW5rI9o8n06FvmV1M+bBFfX
         YNubq65NBM6w9TNZeohFGxGQHBSYpmJ2MVCGqXlkjI0pG66JFFF6zyIvXaCtVFAsMNFh
         hXEcIALahsRpm5ULADGvB6dWEK8Cco4UeMk/PeV198/yaHKWNMbjOkpRw/jOeaVEUa88
         WYew6Gts30zeIuE6WLRNasfDpPaC4wq9Q+TgniIJZLVp7q+T9A9NqwNBf4mhube6dHtB
         lKvNpdpZCmdXI0XAsx+tbsEVIpm8bgaFMld59t1NK22AG0oMOtTQgmguJ9Zy1dAlKVSJ
         vknQ==
In-Reply-To: <CAJD7tkad5NbqjXZ1qLaNx1g-FYsrv-BVLcNinycFStG_Bu0_zw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 9:52=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
[...]
>
> Sure, I can do that in the next version. I will include a patch that
> adds an in_task() check to mem_cgroup_usage() before this one. Since
> BUG_ON() is discouraged and VM_BUG_ON() is mm specific, I guess we are
> left with WARN_ON_ONCE() for the rstat core code, right?
>
> Thanks Shakeel. Any other thoughts I should address for the next version?

This is all for now (at least for this patch).

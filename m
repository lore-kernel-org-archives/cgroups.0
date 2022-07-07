From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations
Date: Thu, 7 Jul 2022 15:41:11 -0700
Message-ID: <CAADnVQ+qqeAVvtDYox4xj85Qxt79EV1Hn+HDEMuzHrwZv14X4Q@mail.gmail.com>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle> <YsMCMveSdiYX/2eH@dhcp22.suse.cz>
 <YsSj6rZmUkR8amT2@castle> <CALOAHbAb9DT6ihyxTm-4FCUiqiAzRSUHJw9erc+JTKVT9p8tow@mail.gmail.com>
 <YsUBQsTjVuXvt1Wr@castle> <CALOAHbDjRzySCHeMVHtVDe=Ji+qh=n0pT4CwiAM5Pahi2-QNCQ@mail.gmail.com>
 <YsUH7pgBVnWSkC1q@castle>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x0hTg3svlPkX7yjZEejAqipfWlRrXxPxf4EQelGBTvo=;
        b=JjLDLcNl//HbIrbRbWAfVo8D/EHxetYwwUclgU4IpzJTW1aVvb76jqCKqg3pQTeotv
         uI+pfXcAlpsxTDhK2XQU/X0vIHaOXSJoKWs9rkTxjxYJ9wiOflV/IzcsJSUlO04l7cjS
         uDSH6tP2pdODKwl8VBAPJ715+J05mEiLpIH5b5kK+VQoCEQfpNJ0Wgyh9SG3orG3Hx+P
         enbo2ru4HaAYtaJKwPwZTV8Jc0rTwxb1Y6qPZDBw7LzK7qLy0N+3fslDNlZWbTnvnTyi
         x2LlCTlGHuTrJscVe/nGn5oSQABB6NQTA2FMSsEn5XXQ1rUyE9gMoiUWHUSGTufjkeXo
         DxBQ==
In-Reply-To: <YsUH7pgBVnWSkC1q@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <songmuchun@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>

On Tue, Jul 5, 2022 at 9:24 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Anyway, here is the patch for reparenting bpf maps:
> https://github.com/rgushchin/linux/commit/f57df8bb35770507a4624fe52216b6c14f39c50c
>
> I gonna post it to bpf@ after some testing.

Please do. It looks good.
It needs #ifdef CONFIG_MEMCG_KMEM
because get_obj_cgroup_from_current() is undefined otherwise.
Ideally just adding a static inline to a .h ?

and
if (map->objcg)
   memcg = get_mem_cgroup_from_objcg(map->objcg);

or !NULL check inside get_mem_cgroup_from_objcg()
which would be better.

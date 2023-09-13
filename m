From: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Wed, 13 Sep 2023 12:33:21 +0200
Message-ID: <476c3048-0009-4ac8-bfd2-40411a4ec094@nebius.com>
References: <20230911075437.74027-1-zeil@nebius.com>
 <20230911075437.74027-2-zeil@nebius.com> <ZP9itivlZQIb5wZ0@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekdn15n92GL4zx+tdFl3RKpQXUo/DkDvzH68NHWVF5g=;
 b=WjUGBP1saJ98eIlMP3dPdojAHc52nxjkzsGfLbpTIoilqEYVn8mXKimgdnppbI2UV+QwGmTtlOYTHHdhbIxHCE6WXQOOWCZAjZli5NJaJPXPT8QQlZwyURzFpFisvptF9VhnzgzW628X2ew6RnpJXYzl53Kh10QZ6LQdCJOuEqBC0h/s9QFtcN/j/89ZzEzJkHklinyCcya+XpGVFKq0TIGHzXk9qkvb98pAeBOTSVSOoLG3rRRd1wSMWfPLDh36gBopU8o4kiAE71nBszhnz5vxYBNDPjJotBThAy8teTjhLEEX/jzk55/YOpFd2eA9u/jhUQpJczXvEcMcPNx16g==
Content-Language: ru
In-Reply-To: <ZP9itivlZQIb5wZ0-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

Thank you for pointing out to drgn scripts in kernel source tree, didn't 
know about them, I will take a look.

On 11.09.2023 20:55, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> On Mon, Sep 11, 2023 at 07:55:15AM +0000, Yakunin, Dmitry (Nebius) wrote:
>> +static void mem_cgroup_css_dump(struct cgroup_subsys_state *css,
>> +                             struct seq_file *m)
>> +{
>> +     struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>> +
>> +     seq_printf(m, "mem_id=%u memory=%lu memsw=%lu kmem=%lu tcpmem=%lu shmem=%lu",
>> +                mem_cgroup_id(memcg),
>> +                page_counter_read(&memcg->memory),
>> +                page_counter_read(&memcg->memsw),
>> +                page_counter_read(&memcg->kmem),
>> +                page_counter_read(&memcg->tcpmem),
>> +                memcg_page_state(memcg, NR_SHMEM));
>> +}
> Can you please take a look at drgn (https://github.com/osandov/drgn) and see
> whether that satifies your needs? We can easily add drgn scripts under tools
> directory too (e.g. iocost already does that).
>
> Thanks.
>
> --
> tejun

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Thu, 5 May 2022 09:12:26 -0700
Message-ID: <CALvZod5xiSuJaDjGb+NM18puejwhnPWweSj+N=0RGQrjpjfxbw@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOg3JkIywRLzrPPGawgi8+ppo6ekCB8fiVEKfUdHYi8=;
        b=bQoc6U3SxwP0PLDXxVdqqhePzPc76Rf9CAYeT6a95TuwCPscQdatdnavfs9+sEDFuA
         p3rZyeAuQqJiMBN6peF93vd05yCGPXNj4V78HmPSInyZV2H91C+CpOJYjHq5n9ogs4Wq
         1QVsNX3yw+iEWNAClXf5MVN3ViDAULifqYmqmyZJpC4K3jC0w7+UvEQ4hfYrYVyPC642
         7Nwru5zmvGzc97KPaDQQ3DX+5WICrsIp/3jHcKn/sOem690fn62qi74MMmhCn5Mrz0Sf
         pocEv78vyZ7zQzsi0xJ5L5GbPAFPRTIHB6zPsGPTDuNDJY83edQsULVTvzQRv1FyJ0xa
         ZjSg==
In-Reply-To: <20220505121329.GA32827-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, May 5, 2022 at 5:13 AM Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
>
> v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in

*max_usage_in_bytes

> sysfs. This is missing for v2 memcg though "memory.current" is exported.
> There is no other easy way of getting this information in Linux.
> getrsuage() returns ru_maxrss but that's the max RSS of a single process
> instead of the aggregated max RSS of all the processes. Hence, expose
> memcg->watermark as "memory.watermark" for v2 memcg.
>
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>

Can you please explain the use-case for which you need this metric?
Also note that this is not really an aggregated RSS of all the
processes in the cgroup. So, do you want max RSS or max charge and for
what use-case?

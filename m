From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Fri, 20 Aug 2021 04:42:07 -0700
Message-ID: <CALvZod5usW9OEsJSbeGYBnSGVDNLLKqMoGAx-JQrX6s62r-XiA@mail.gmail.com>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwSYnZ0fXeyF3ucmVYtCymM5MkqPY89pcO9lgHDkScc=;
        b=RQV3qkbRPB4wYn5rj55IDWMO5Wywf4L6wyjACr5IMbV/zKC36Ab6BeVA76WHo2bs4j
         nyrb7DMkVIXnh0n7r4Pk+OInxYOfLVae9K0ZAQMO+QgJXveyqceQ8lzHCCXFR/9ArfE4
         ZBWCImoPry5Ydl+fvYVRdPdNvVPDC6LXtVpU4uIGo0VjrDaZsYylBJLnI5aSZO3IWar0
         N+IXPS8HSukU8TtqsNWym+9YmCdj9Ed6Luk46mBRNxBJWMaInC8usKVRyomOt5I8HpnZ
         kdez1wm7WCrnD4B9891D85TmVqzs6WU7Ex+eeEozWvPTowdFcxszIdbxiplestG2EdjQ
         zDXA==
In-Reply-To: <1629417219-74853-1-git-send-email-wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, wangyong <wang.yong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Thu, Aug 19, 2021 at 4:54 PM <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: wangyong <wang.yong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
> Inspired by PSI features, vmpressure inotifier function should
> also be configured to decide whether it is used, because it is an
> independent feature which notifies the user of memory pressure.
>

It is also used by the networking stack to check memory pressure. See
mem_cgroup_under_socket_pressure().

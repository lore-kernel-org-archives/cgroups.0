From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/4] mm/oom: handle remote ooms
Date: Fri, 19 Nov 2021 23:58:21 -0800
Message-ID: <CALvZod680y1o3WKFKEXmXf3Cd4j-POpc-zrAQ1+ykLoWK9-21A@mail.gmail.com>
References: <20211120045011.3074840-1-almasrymina@google.com> <20211120045011.3074840-3-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDPBsHcfNzrPZpXm7j+tJ6FtAT1aH1QKACsXUwu2lsU=;
        b=PDIEkVRE4lRmmix6/kxfmiSW4LoI0BO2oI5eeIooXPPBVyf65uczSyS7/ryrSS30TB
         yxTiLtqZPEhw/QJsG03QilaLw0yxveHy4FdQKSADKfOQeZ+PzgAjKkAAMZ9fTG2X7PHy
         q3PcsDO1p59bhbLyWub0/L3p8OfhhttrwOAZUm4+ltQQgUTSY9rOrbMNacNSIAxYb07s
         Pt9fk8i0hGIcYGImn6ufTyobVPEffh3xY4MdR7gl7Eu8nyqzLZKq+TnidX1MqXLynmwH
         iiRf2LJpIO+G67HLqgqO+zKYKIscIpBouV5K55umtQPZenddR0fPFdAUpe1yoLJuk4WU
         nAVw==
In-Reply-To: <20211120045011.3074840-3-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 19, 2021 at 8:50 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
> +/*
> + * Returns true if current's mm is a descendant of the memcg_under_oom (or
> + * equal to it). False otherwise. This is used by the oom-killer to detect
> + * ooms due to remote charging.
> + */
> +bool is_remote_oom(struct mem_cgroup *memcg_under_oom)
> +{
> +       struct mem_cgroup *current_memcg;
> +       bool is_remote_oom;
> +
> +       if (!memcg_under_oom)
> +               return false;
> +
> +       rcu_read_lock();
> +       current_memcg = mem_cgroup_from_task(current);
> +       if (current_memcg && !css_tryget_online(&current_memcg->css))

No need to grab a reference. You can call mem_cgroup_is_descendant() within rcu.

> +               current_memcg = NULL;
> +       rcu_read_unlock();
> +
> +       if (!current_memcg)
> +               return false;
> +
> +       is_remote_oom =
> +               !mem_cgroup_is_descendant(current_memcg, memcg_under_oom);
> +       css_put(&current_memcg->css);
> +
> +       return is_remote_oom;
> +}
> +

From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Date: Tue, 11 Jan 2022 10:25:37 +0800
Message-ID: <CAMZfGtWBt+qYB1-NS+G8Tzk0pm6UZGvENZFBWrz+i35=N1kOAw@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com> <20220111010302.8864-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1ENhSWsAV/dz7z50ZJCYCuaP4VRXWxn4r2j+Sg+6UA=;
        b=T55GOK2PpaNsrGqiMFTAqH2V7QdMHJhf0a3BMQ7I8S2f2h7BI4JXGBsntFUbrKsnrl
         rEzOH+AqALeZAy8Qhyi3rFQo8NaIqguy97C9ERCdlxVx+n7E8WH64/TjwHln91YBdBBk
         AWYzFw4wU9mhtUfJSXGLzZymCyI9uQqeU39t+zioXUDqxTWAI0BMcwXbJxPBATEie6rv
         xQARIPZV9m3Nn76w+UJ2xS8QDkRdVgio/eXbMdoElnUL60H99TIz4WO/aNSZ8URTri7U
         84EE4GnWjFwaNRNtzSO8JCOqqvhya0pINZ5DHiHwfs7OeADtTaDkmdukFBkr8yOlXG57
         zZYQ==
In-Reply-To: <20220111010302.8864-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Jan 11, 2022 at 9:03 AM Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> kzalloc_node() would set data to 0, so it's not necessary to set it
> again.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

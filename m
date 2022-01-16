From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Sun, 16 Jan 2022 11:54:24 -0800
Message-ID: <CALvZod52PWUhaFW1jOjJFd_Ef4pBrj7=q8MaBEAWMqawapxQ6Q@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com> <20220111010302.8864-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32ZGPXHe3Ged0KnD2WiQsFB3QGx2BbSWPhOV/bW7jNc=;
        b=RMd20O9hiJ+E++mZyFCDgYsG99GnasXx9c7mZSzw0rI5QCZRUDgY7035Y/jwkEIhET
         //SyReKW9JjjJucOIxRqhB29/qOd4FJouwJMwOq05gVXJnoAaw9T8BRB2KyG/rTWdf/3
         JChxfan6qdczRC8W0KyNqWCcGtDTmC/Dkg1vIrMMrJS8DHl6PHjNIY+V4aHI/Ct1MUx+
         eWAX6pjHBWif9lJixach4FExApXyy+orxoCRlPl5egBwUKbfvgBbI0LxRO4uqztDVEGx
         zcs89gRS7lDl7xhNTMO0tfkzqTOrF99K6B28pwaFimR4JkOr12A8c0sB/e3NKvoHqzWt
         KJ5w==
In-Reply-To: <20220111010302.8864-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Jan 10, 2022 at 5:03 PM Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> The parent we get from page_counter is correct, while this is two
> different hierarchy.
>
> Let's retrieve the parent memcg from css.parent just like parent_cs(),
> blkcg_parent(), etc.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

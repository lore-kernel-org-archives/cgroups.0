From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: Simplify the mem_cgroup_page_lruvec
Date: Thu, 29 Oct 2020 09:01:37 -0700
Message-ID: <CALvZod68-f-_1pevYbegzXk_b0L=XbCJkM5KqcRF9TuLiz3_ww@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <20201028035013.99711-4-songmuchun@bytedance.com> <20201029090806.GD17500@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p81Xb4QB6WZnyTYb/aPQJGGs3MtSmkCjVSQFBTfTe00=;
        b=eeVMWmyLkGAhC1rQFKkLvBOCkWQ6Smot20Si3H+Lg87YKkUxflwYxLcfGFqVLc5KLf
         SwfZDbAGSj4utMXHZmxzJ7TGpzf/Jd7X5Inmxc4MCtwfLFLZytqccPGQm1mHvSm7j5Lp
         dMfYdPJhpw9CWTTVqZsaV7ks5rzt5ea8aULFpgqf8ikV/61BMq3p8Szx3rYFDUXOUAnZ
         mAnrQOY1y6sAb0KwsoD3XeL7AmBHXhk4w543PNyD0NFf6HqcD0asVoBZ1/Q11E6qJedJ
         7abxq5IUrm3H3tQgcVV7hVxwNp+ND66/eKEZkhmXVM7KiHEur3c3SDi/bzfspTKvt+9q
         iOGQ==
In-Reply-To: <20201029090806.GD17500-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Oct 29, 2020 at 2:08 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 28-10-20 11:50:13, Muchun Song wrote:
> [...]
> > -struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
> > +static struct lruvec *
> > +__mem_cgroup_node_lruvec(struct mem_cgroup *memcg, struct pglist_data *pgdat,
> > +                      int nid)
>
> I thought I have made it clear that this is not a good approach. Please
> do not repost new version without that being addressed. If there are any
> questions then feel free to ask for details.

You can get nid from pgdat (pgdat->node_id) and also pgdat from nid
(NODE_DATA(nid)), so, __mem_cgroup_node_lruvec() only need one of them
as parameter.

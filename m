From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: vmscan: reclaim anon pages if there are swapcache pages
Date: Wed, 23 Aug 2023 08:29:19 -0700
Message-ID: <CAJD7tkYivogrRtAx8a+EPfjRqQNgoOZFZyG8rC91E_hW6pdTEw@mail.gmail.com>
References: <20230822024901.2412520-1-liushixin2@huawei.com>
 <CAJD7tkZkYsopuqGH_Lo=kE4=HO33wmvK6mXhuq4p_KZ6pYuXtw@mail.gmail.com>
 <50c49baf-d04a-f1e3-0d0e-7bb8e22c3889@huawei.com> <ZOYFydIp3q8BNrEa@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692804595; x=1693409395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ri9cgA1PiCU6du3dgZZGBozLYOkCK1hmpsIStPWqOXw=;
        b=4iVGNXXiBWOb9z6ygfEgopQKgtjz/ArlqeOIHwCCa/5HrFRqcdkbL/B0k4sFHBO1k4
         Eg1bl7/uU37OwC7NsikD+jNiX9ImSC6a/lYPt8cooDBXForLZnqPxR/cYv4nWicYXfke
         A3r/tvU9OZ3Q9XPQLgWMi/OV2FCvfrfWL1nz+l42yojLn7TATXXxvZIeO4U6KWgdao41
         Lo+wjmL5LNqoWRr44aX9H57Lihc2x3PKwGSMAD616I37GXzf54uBCUK2ac/wZ2S47XDk
         pY90bs1cRDWtt1y7RWKZ0WClLg37X7BnHlRXwYd274I4jnLCaiakgMeL4SnMcxnxgQUl
         M/oA==
In-Reply-To: <ZOYFydIp3q8BNrEa-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Aug 23, 2023 at 6:12=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Wed 23-08-23 10:00:58, Liu Shixin wrote:
> >
> >
> > On 2023/8/23 0:35, Yosry Ahmed wrote:
> > > On Mon, Aug 21, 2023 at 6:54=E2=80=AFPM Liu Shixin <liushixin2@huawei=
.com> wrote:
> > >> When spaces of swap devices are exhausted, only file pages can be re=
claimed.
> > >> But there are still some swapcache pages in anon lru list. This can =
lead
> > >> to a premature out-of-memory.
> > >>
> > >> This problem can be fixed by checking number of swapcache pages in
> > >> can_reclaim_anon_pages(). For memcg v2, there are swapcache stat tha=
t can
> > >> be used directly. For memcg v1, use total_swapcache_pages() instead,=
 which
> > >> may not accurate but can solve the problem.
> > > Interesting find. I wonder if we really don't have any handling of
> > > this situation.
> > I have alreadly test this problem and can confirm that it is a real pro=
blem.
> > With 9MB swap space and 10MB mem_cgroup limit=EF=BC=8Cwhen allocate 15M=
B memory,
> > there is a probability that OOM occurs.
>
> Could you be more specific about the test and the oom report?

I actually couldn't reproduce it using 9MB of zram and a cgroup with a
10MB limit trying to allocate 15MB of tmpfs, no matter how many
repetitions I do.

>
> --
> Michal Hocko
> SUSE Labs

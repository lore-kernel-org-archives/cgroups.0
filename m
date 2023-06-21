From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/6] mm: working set reporting
Date: Wed, 21 Jun 2023 12:48:22 -0600
Message-ID: <CAOUHufbb9_Cah6tT61+WKfM0T9CDmkZ5zym=MuHj2YVsgh-hiw@mail.gmail.com>
References: <20230621180454.973862-1-yuanchu@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687373339; x=1689965339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktaN2gfy2UoFzSis8IakrvfByDQPNIqA2OzFHTKqH6g=;
        b=6g8bjgJ05d+rXqPxYemA4IWXC+J1Ela6mFMkncMRIuq1/qtJbHccQZq5eNnK8I5qe0
         hHNtT089lxLYIpUCWKimJ7OvTnk3AqftjEne3x/QKdPrTQj7whhf9V7QXpmEIjhdikxt
         3RUxgdzBP7JyIEHwuW1EfLOcXwuB5TITZDI0M9cW8LfCeT6p8VPkPbdIAj+Bz1xOsg4h
         wX9LbCEVcoDUhWSHLG5Y939Eqa61h2yFQYFGh0vJ5vX9YJMSwF0ASQbl++WFw3qZiFK/
         UWDxKAbJQKcXA5CFkGIQw1AxgIxNjJ0wsXMZhvPgK37ovf8LI3YrUUA00uM18dZNvF5J
         3yWQ==
In-Reply-To: <20230621180454.973862-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T . J . Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org, A

On Wed, Jun 21, 2023 at 12:16=E2=80=AFPM Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> w=
rote:
>
> RFC v1: https://lore.kernel.org/linux-mm/20230509185419.1088297-1-yuanchu=
@google.com/
> For background and interfaces, see the RFC v1 posting.

v1 only mentioned one use case (ballooning), but we both know there
are at least two solid use cases (the other being job
scheduling/binpacking, e.g., for kubernetes [1]).

Please do a survey, as thoroughly as possible, of use cases.
* What's the significance of WSR to the landscape, in terms of server
and client use cases?
* How would userspace tools, e.g., a PMU-based memory profiler,
leverage the infra provided by WSR?
* Would those who register slab shrinkers, e.g., DMA buffs [2], want
to report their working sets?
* Does this effort intersect with memory placement with NUMA and CXL.mem?

[1] https://kubernetes.io/docs/concepts/configuration/manage-resources-cont=
ainers/
[2] https://lore.kernel.org/linux-mm/20230123191728.2928839-1-tjmercier@goo=
gle.com/

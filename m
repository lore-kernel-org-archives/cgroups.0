From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Fri, 25 Mar 2022 11:10:19 +0800
Message-ID: <CAGWkznGnDUvAqX3KCP+HZCyn49XU9=2bV9vfiFbutsQw8mK=hw@mail.gmail.com>
References: <Yjx/3yi7BfH7wLPz@chrisdown.name> <FE4CCCF9-CF08-424B-85D0-B5C1BA63329D@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rZkrO50N8MIM5fdKHsVpbm2U8iuVkvk0CAUhdGmqqWM=;
        b=LEzCQ1BWpC5mhJuQigVniD6FG8W+FawIPFRfZn+Kc8wgPtrkzAdxNxjdF2z4sGF77R
         vx2tdr04eu9K+qltad/QTWCS+aJIjicWUybB4qRGdUGf2MFLsUJ26Wt2s/Yd3g/69drO
         nfmJa7B2HNNRWw5dUCx6PEQbxGEKpJEBmTZ+oYi4Mk4h7XqPLyFV36M4lrktps1MDGIM
         7416CjhidMppBvW1QZARuGBCy9CPxN2gcZDERMFLwvRVPuByqnQ60bhEsGDqoBoYMpzf
         oYJTqoXCa3jnCaLnvzBLSEQ3zz+UytX3asngvJyWKFknxSwXSATB4MWAIynVxZeEhPvl
         u90Q==
In-Reply-To: <FE4CCCF9-CF08-424B-85D0-B5C1BA63329D-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 25, 2022 at 12:23 AM Roman Gushchin
<roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> It seems like what=E2=80=99s being proposed is an ability to express the =
protection in % of the current usage rather than an absolute number.
> It=E2=80=99s an equivalent for something like a memory (reclaim) priority=
: e.g. a cgroup with 80% protection is _always_ reclaimed less aggressively=
 than one with a 20% protection.
>
> That said, I=E2=80=99m not a fan of this idea.
> It might make sense in some reasonable range of usages, but if your workl=
oad is simply leaking memory and growing indefinitely, protecting it seems =
like a bad idea. And the first part can be easily achieved using an userspa=
ce tool.
>
> Thanks!
>
> > On Mar 24, 2022, at 7:33 AM, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
> >
> > =EF=BB=BFI'm confused by the aims of this patch. We already have propor=
tional reclaim for memory.min and memory.low, and memory.high is already "p=
roportional" by its nature to drive memory back down behind the configured =
threshold.
> >
> > Could you please be more clear about what you're trying to achieve and =
in what way the existing proportional reclaim mechanisms are insufficient f=
or you?
ok, I think it could be fixable for memory leak issues. Please refer
to my reply on Chris's comment for more explanation.

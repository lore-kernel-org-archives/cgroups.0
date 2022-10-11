From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] bpf: cgroup_iter: support cgroup1 using cgroup fd
Date: Tue, 11 Oct 2022 06:49:18 -1000
Message-ID: <Y0WejttpkBmM3yr2@slm.duckdns.org>
References: <20221011003359.3475263-1-yosryahmed@google.com>
 <20221011003359.3475263-3-yosryahmed@google.com>
 <2ba0ee79-2e7e-6807-3312-1a2c5ef3bae0@linux.dev>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hY48VDrSzbNwqgQrTRMw8Ws7A/RJwf4Ei5MNSQeswrs=;
        b=cQC+PH2lZiUHWyj98ZXVBDmjg7/8/df+X98sp8YnymRQhLZid6OYG8dCeBcpYtCXp3
         OrR94346LxPvqCJUKOIqnyS47AKdphHIxh4sBhbUxuGwSJ9Xm8NiGNuqlx/Tkfxat7ZJ
         OI05Ph+FWzJzKhU9pZgLR+fw3xGtvvbJEJkPvR7j5ErCXlJ1Ipj4cGNDv7Fw62e8/IQZ
         aLbMAopbWrhXFm/KnJdshIL+S4mXmKieBiE4oDEXnQL+AMKafIJ1HD7zofgChOG23Cwo
         sOWWR0iSI6ED+g6lBKggEjJnP3uNrHglHK6Yg2myxQCH7EOD4KTjBjgMfoB5+9WTjSv+
         DcSw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <2ba0ee79-2e7e-6807-3312-1a2c5ef3bae0@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>

On Tue, Oct 11, 2022 at 09:46:27AM -0700, Martin KaFai Lau wrote:
> On 10/10/22 5:33 PM, Yosry Ahmed wrote:
> > Use cgroup_v1v2_get_from_fd() in cgroup_iter to support attaching to
> > both cgroup v1 and v2 using fds.
> > 
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   kernel/bpf/cgroup_iter.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> > index 0d200a993489..9fcf09f2ef00 100644
> > --- a/kernel/bpf/cgroup_iter.c
> > +++ b/kernel/bpf/cgroup_iter.c
> > @@ -196,7 +196,7 @@ static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> >   		return -EINVAL;
> >   	if (fd)
> > -		cgrp = cgroup_get_from_fd(fd);
> > +		cgrp = cgroup_v1v2_get_from_fd(fd);
> 
> Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
> 
> Tejun, patch 1 should depend on a recent revert that is not in the bpf tree
> yet.  Do you want to take this set to the cgroup tree?

Yeah, will do.

Thanks.

-- 
tejun

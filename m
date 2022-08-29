From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 4/4] cgroup/bpf: Honor cgroup NS in cgroup_iter for ancestors
Date: Mon, 29 Aug 2022 10:30:45 -0700
Message-ID: <CAJD7tkZySzWgJgp4xbkpSstc_RMN_tJqt83-FFrxv6jASeg8CA@mail.gmail.com>
References: <20220826165238.30915-1-mkoutny@suse.com> <20220826165238.30915-5-mkoutny@suse.com>
 <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g@mail.gmail.com> <20220829125957.GB3579@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=6dZvHbb8IWueLS4eFstq1vaFfQHUYChceiQvahnGWHU=;
        b=cqoVFEaZpeJD8EjNsoLJ56vZYmVurORt4hKHbg5R3LIFg2MPYs9W9NyBzZJkO2Oxaf
         wbD4TpbwyAA2cTNYtWJJ+0bHscp0QXqLghWLQzaihARVQXFbGamD/y+wT7uiaBbIMUNk
         IVcoC++0s7an6V+WAZu0yKjuQWtiHUBYPm2UNNnR/UE4ORHA6YhRMrm4knhOzp0OGr47
         bvzrpTWLtfX0Bn0PTH4HHg8r3omAX828OO3edjzOICn6IY4eGH9PQhxQwPDxHAtllPBH
         ncEYOgWP7jsLmEWXULP94ZnYf+pkVq8pn2BhQh5lYmSlUPV5koIisqeachjraxEBVBaf
         OmNQ==
In-Reply-To: <20220829125957.GB3579@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Hao Luo <haoluo@google.com>

On Mon, Aug 29, 2022 at 6:00 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> On Fri, Aug 26, 2022 at 10:41:37AM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > I understand that currently cgroup_iter is the only user of this, but
> > for future use cases, is it safe to assume that cgrp will always be
> > inside ns? Would it be safer to do something like:
>
> I preferred the simpler root_cgrp comparison to avoid pointer
> arithmetics in cgroup_is_descendant. But I also made the assumption of
> cgrp in ns.
>
> Thanks, I'll likely adjust cgroup_path_ns to make it more robust for
> an external cgrp.
>

Great, thanks!

>
> I'd like to clarify, if a process A in a broad cgroup ns sets up a BPF
> cgroup iterator, exposes it via bpffs and than a process B in a narrowed
> cgroup ns (which excludes the origin cgroup) wants to traverse the
> iterator, should it fail straight ahead (regardless of iter order)?
> The alternative would be to allow self-dereference but prohibit any
> iterator moves (regardless of order).
>

imo it should fail straight ahead, but maybe others (Tejun? Hao?) have
other opinions here.

>
> Thanks,
> Michal

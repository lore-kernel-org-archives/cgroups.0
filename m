From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Date: Fri, 19 Aug 2022 06:45:43 -1000
Message-ID: <Yv++N6OFEe6I9uEQ@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <CALOAHbDt9NUv9qK_J1_9CU0tmW9kiJ+nig_0NfzGJgJmrSk2fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=43IB1l85zFZx2xfIvsACnvdd0hD/Sqi80j0FvnZgz+w=;
        b=JQy2QfMvU993ELBmz2m2IaJHojQluWlc2EN1XG0ztr6V8OaUTHOJN6euMR6ZmYAlbl
         v0gDSEyBQCndO31qlao27Cg9HJjzj49/CDBem77UVSFkGSlC71Kw1brKSCMjzxi5Hfnj
         st8s2amoKpXOB2XplmnOm2Sony8Fk5a8Q21/jD4R+Vl1Ku3mG0/4G4ifVq6qmy0a8fuj
         apyv5fnK9IzqKogBCTmEjTQ3i6v3yXfFFJztAVKLeoGNEaP1vWx4w+k0o9AK2gZNiN+S
         kxlNRXmxImlpHp1cYsPdNZW3sHdtC2KjL+HkwJgEXQ7oaY97sWNrcStYnF/hITQJBwUo
         B13Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbDt9NUv9qK_J1_9CU0tmW9kiJ+nig_0NfzGJgJmrSk2fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hello,

On Fri, Aug 19, 2022 at 08:59:20AM +0800, Yafang Shao wrote:
> On Fri, Aug 19, 2022 at 6:20 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > memcg folks would have better informed opinions but from generic cgroup pov
> > I don't think this is a good direction to take. This isn't a problem limited
> > to bpf progs and it doesn't make whole lot of sense to solve this for bpf.
> 
> This change is bpf specific. It doesn't refactor a whole lot of things.

I'm not sure what point the above sentence is making. It may not change a
lot of code but it does introduce significantly new mode of operation which
affects memcg and cgroup in general.

> > We have the exact same problem for any resources which span multiple
> > instances of a service including page cache, tmpfs instances and any other
> > thing which can persist longer than procss life time. My current opinion is
> > that this is best solved by introducing an extra cgroup layer to represent
> > the persistent entity and put the per-instance cgroup under it.
> 
> It is not practical on k8s.
> Because, before the persistent entity, the cgroup dir is stateless.
> After, it is stateful.
> Pls, don't continue keeping blind eyes on k8s.

Can you please elaborate why it isn't practical for k8s? I don't know the
details of k8s and what you wrote above is not a detailed enough technical
argument.

> > It does require reorganizing how things are organized from userspace POV but
> > the end result is really desirable. We get entities accurately representing
> > what needs to be tracked and control over the granularity of accounting and
> > control (e.g. folks who don't care about telling apart the current
> > instance's usage can simply not enable controllers at the persistent entity
> > level).
> 
> Pls.s also think about why k8s refuse to use cgroup2.

This attitude really bothers me. You aren't spelling it out fully but
instead of engaging in the technical argument at the hand, you're putting
forth conforming upstream to the current k8s's assumptions and behaviors as
a requirement and then insisting that it's upstream's fault that k8s is
staying with cgroup1.

This is not an acceptable form of argument and it would be irresponsible to
grant any kind weight to this line of reasoning. k8s may seem like the world
to you but it is one of many use cases of the upstream kernel. We all should
pay attention to the use cases and technical arguments to determine how we
chart our way forward, but being k8s or whoever else clearly isn't a waiver
to claim this kind of unilateral demand.

It's okay to emphasize the gravity of the specific use case at hand but
please realize that it's one of the many factors that should be considered
and sometimes one which can and should get trumped by others.

Thanks.

-- 
tejun

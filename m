From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 6/9] cgroup: add v1 support to cgroup_get_from_id()
Date: Tue, 10 May 2022 11:36:17 -0700
Message-ID: <CAJD7tkb_fP=qTQRR7Os1UXSqFQvCEX+GYA9QHvbcoXyW1Kq48Q@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-7-yosryahmed@google.com> <YnqwFuhncWiR3rjq@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3DuZ6qMz/zwur/XREOAPzrxtrhGwT4mYkZCOIIgE34=;
        b=WuHN5uHfYZAEE44qYg/3gHrDYCuYzwfu4xNG6V/Zli6CdrZFKQs64WVQEKWSplNQWr
         n8LTONmYEdFhQr80eHUqicHY0F7KIyV9I6eytS4eIB2kbllV3FoHgnqv2JZ3QUbo9pqM
         +yM5oaOfkvFmkC+Qdp4sevWhPH5KsMkvW4Bjd4X7ksx4LwclFy19gupcY7cFHeKQWOlk
         XoyN5NTwbGfFVXSP1eGuJCbsfhL1nWx7LP2IxcKd3XCGVdDM2Z80UDhq/qt9sZuFwyKo
         8BdnKJbzrJGC7LMInRLmjjoK5jNWC1i47zYKCcrZdPpq30LOSlVGfxVYgElsBoVJVAdZ
         7OYw==
In-Reply-To: <YnqwFuhncWiR3rjq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 10, 2022 at 11:34 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, May 10, 2022 at 12:18:04AM +0000, Yosry Ahmed wrote:
> > The current implementation of cgroup_get_from_id() only searches the
> > default hierarchy for the given id. Make it compatible with cgroup v1 by
> > looking through all the roots instead.
> >
> > cgrp_dfl_root should be the first element in the list so there shouldn't
> > be a performance impact for cgroup v2 users (in the case of a valid id).
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kernel/cgroup/cgroup.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index af703cfcb9d2..12700cd21973 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -5970,10 +5970,16 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
> >   */
> >  struct cgroup *cgroup_get_from_id(u64 id)
> >  {
> > -     struct kernfs_node *kn;
> > +     struct kernfs_node *kn = NULL;
> >       struct cgroup *cgrp = NULL;
> > +     struct cgroup_root *root;
> > +
> > +     for_each_root(root) {
> > +             kn = kernfs_find_and_get_node_by_id(root->kf_root, id);
> > +             if (kn)
> > +                     break;
> > +     }
>
> I can't see how this can work. You're smashing together separate namespaces
> and the same IDs can exist across multiple of these hierarchies. You'd need
> a bigger surgery to make this work for cgroup1 which would prolly involve
> complications around 32bit ino's and file handle support too, which I'm not
> likely to ack, so please give it up on adding these things to cgroup1.
>
> Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.

Completely understandable. I sent this patch knowing that it likely
will not be accepted, with hopes of hearing feedback on whether this
can be done in a simple way or not. Looks like I got my answer, so
thanks for the info!

Will drop this patch in the incoming versions.

>
> --
> tejun

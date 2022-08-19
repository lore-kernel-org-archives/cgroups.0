From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Date: Fri, 19 Aug 2022 07:06:51 -1000
Message-ID: <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=UZnrLccuewBeUTHa7he/1pdbfRtAri2WoHO63fUtNRc=;
        b=XAW0y0n14GbbI93QKgU2Mko3gRIRMRbjNK8yh6f00kxV2u+FwfJBFOdIFc4ubGtXnZ
         96Q7W+i5mtTv/AvpxsVclO3S1wahAB9QAbiT33xETdG3I+uCk/1gLZGnE5/tLTsGvFFo
         0I1/8QoikeezFphqIzolui9+0fafgFMClIoRK29EKwdtKR/ArQz1f/PwmdqHMOlsUEsG
         dqop2MHzljQjY7dyyBDVAy6aQF6pfzlwuE2uTIsOz0RjIQnTjgUncRBAtxpzCdihOVK4
         J5eGefsDHsvQ+K+HppyuUs/yFRkhgEdyNd4tDdrkcRyyCjtSWG74pKB6qGa2PWRznqxB
         5AvQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hello,

On Fri, Aug 19, 2022 at 09:09:25AM +0800, Yafang Shao wrote:
> On Fri, Aug 19, 2022 at 6:33 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> > > We have the exact same problem for any resources which span multiple
> > > instances of a service including page cache, tmpfs instances and any other
> > > thing which can persist longer than procss life time. My current opinion is
> >
> > To expand a bit more on this point, once we start including page cache and
> > tmpfs, we now get entangled with memory reclaim which then brings in IO and
> > not-yet-but-eventually CPU usage.
> 
> Introduce-a-new-layer vs introduce-a-new-cgroup, which one is more overhead?

Introducing a new layer in cgroup2 doesn't mean that any specific resource
controller is enabled, so there is no runtime overhead difference. In terms
of logical complexity, introducing a localized layer seems a lot more
straightforward than building a whole separate tree.

Note that the same applies to cgroup1 where collapsed controller tree is
represented by simply not creating those layers in that particular
controller tree.

No matter how we cut the problem here, if we want to track these persistent
resources, we have to create a cgroup to host them somewhere. The discussion
we're having is mostly around where to put them. With your proposal, it can
be anywhere and you draw out an example where the persistent cgroups form
their own separate tree. What I'm saying is that the logical place to put it
is where the current resource consumption is and we just need to put the
persistent entity as the parent of the instances.

Flexibility, just like anything else, isn't free. Here, if we extrapolate
this approach, the cost is evidently hefty in that it doesn't generically
work with the basic resource control structure.

> > Once you start splitting the tree like
> > you're suggesting here, all those will break down and now we have to worry
> > about how to split resource accounting and control for the same entities
> > across two split branches of the tree, which doesn't really make any sense.
> 
> The k8s has already been broken thanks to the memcg accounting on  bpf memory.
> If you ignored it, I paste it below.
> [0]"1. The memory usage is not consistent between the first generation and
> new generations."
> 
> This issue will persist even if you introduce a new layer.

Please watch your tone.

Again, this isn't a problem specific to k8s. We have the same problem with
e.g. persistent tmpfs. One idea which I'm not against is allowing specific
resources to be charged to an ancestor. We gotta think carefully about how
such charges should be granted / denied but an approach like that jives well
with the existing hierarchical control structure and because introducing a
persistent layer does too, the combination of the two works well.

> > So, we *really* don't wanna paint ourselves into that kind of a corner. This
> > is a dead-end. Please ditch it.
> 
> It makes non-sensen to ditch it.
> Because, the hierarchy I described in the commit log is *one* use case
> of the selectable memcg, but not *the only one* use case of it. If you
> dislike that hierarchy, I will remove it to avoid misleading you.

But if you drop that, what'd be the rationale for adding what you're
proposing? Why would we want bpf memory charges to be attached any part of
the hierarchy?

> Even if you introduce a new layer, you still need the selectable memcg.
> For example, to avoid the issue I described in [0],  you still need to
> charge to the parent cgroup instead of the current cgroup.

As I wrote above, we've been discussing the above. Again, I'd be a lot more
amenable to such approach because it fits with how everything is structured.

> That's why I described in the commit log that the selectable memcg is flexible.

Hopefully, my point on this is clear by now.

Thanks.

-- 
tejun

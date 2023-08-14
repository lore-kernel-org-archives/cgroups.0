From: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: fix test_kmem_memcg_deletion false
 positives
Date: Mon, 14 Aug 2023 11:55:45 -0400
Message-ID: <eex2vdlg4ow2j5bybmav73nbfzuspkk4zobnk7svua4jaypqb5@7ie6e4mci43t>
References: <edpx3ejic2cxolhoynxvwal2i4a35akopg6hshcfxker6oxcn7@l32pzfyucgec>
 <20230804163716.GA337691@cmpxchg.org>
 <x2zp6vbr5c3oa3xyfctj66y4ikdxtuo7wsqamkqgyt5ppu6ccb@vwxzimqvrhgk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692028652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qH/OU93DvHxo0hLIYaxXR0nJoX5oGDzCEQsY4s9O1c=;
        b=A4GFCdphoNmiW7VBWxTZmhLZp2rXPB1LhchwHvY59q+Vdr62Z46lBuXhrpsLgWTFFaQWsT
        NyorszjeYBrs33U1uTMCW/1ZyOA4CqGPfoOo+PsgtrJCz4YmmvYMR33pNp6Xty3N6M6Vkx
        h2AATDaxKpCW7aEyf6SdNDzxQ6M0Qrw=
Content-Disposition: inline
In-Reply-To: <x2zp6vbr5c3oa3xyfctj66y4ikdxtuo7wsqamkqgyt5ppu6ccb@vwxzimqvrhgk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 04, 2023 at 02:59:28PM -0400, Lucas Karpinski wrote:
> On Fri, Aug 04, 2023 at 12:37:16PM -0400, Johannes Weiner wrote:
> > On Fri, Aug 04, 2023 at 11:37:33AM -0400, Lucas Karpinski wrote:
> > > The test allocates dcache inside a cgroup, then destroys the cgroups and
> > > then checks the sanity of numbers on the parent level. The reason it
> > > fails is because dentries are freed with an RCU delay - a debugging
> > > sleep shows that usage drops as expected shortly after.
> > > 
> > > Insert a 1s sleep after completing the cgroup creation/deletions. This
> > > should be good enough, assuming that machines running those tests are
> > > otherwise not very busy. This commit is directly inspired by Johannes
> > > over at the link below.
> > > 
> > > Link: https://lore.kernel.org/all/20230801135632.1768830-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> > > 
> > > Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Maybe I'm missing something, but there isn't a limit set anywhere that
> > would cause the dentries to be reclaimed and freed, no? When the
> > subgroups are deleted, the objects are just moved to the parent. The
> > counters inside the parent (which are hierarchical) shouldn't change.
> > 
> > So this seems to be a different scenario than test_kmem_basic. If the
> > test is failing for you, I can't quite see why.
> >
> You're right, the parent inherited the counters and it should behave
> the same whether I'm directly removing the child or if I was moving it
> under another cgroup. I do see the behaviour you described on my
> x86_64 setup, but the wrong behaviour on my aarch64 dev. platform. I'll
> take a closer look, but just wanted to leave an example here of what I
> see.
> 
> Example of slab size pre/post sleep:
> slab_pre = 18164688, slab_post = 3360000
> 
> Thanks,
> Lucas
Looked into the failures and I do have a proposed solution, just want
some feedback first. With how the kernel entry in memory.stat is 
updated, it takes into account all charged / uncharged pages, it looks 
like it makes more sense to use that single entry rather than `slab + 
anon + file + kernel_stack + pagetables + percpu + sock' as it would
cover all utilization.

Thanks,
Lucas


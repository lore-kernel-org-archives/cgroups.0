From: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: fix test_kmem_memcg_deletion false
 positives
Date: Fri, 4 Aug 2023 14:59:28 -0400
Message-ID: <x2zp6vbr5c3oa3xyfctj66y4ikdxtuo7wsqamkqgyt5ppu6ccb@vwxzimqvrhgk>
References: <edpx3ejic2cxolhoynxvwal2i4a35akopg6hshcfxker6oxcn7@l32pzfyucgec>
 <20230804163716.GA337691@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691175583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8TRlrLFCMco4XO+xD44hANqOAJKBhYI/ogDyetWODDc=;
        b=h7sp4Sog4dhP+jLK55vXWj/8VefiAvkVBQqOLTL7LDgj9t0tdlVqLn2se6GqLUkzcpgR3I
        /Ak1YRlVHPOodQnLbjLH/QPfQLxNEXKnEhXCfZ3qIcnsJpKMhCKqhWEK2pTFP294/uzj6l
        lJ7NSyPpzuJMnCA8HjlAGfwo3oRnLsA=
Content-Disposition: inline
In-Reply-To: <20230804163716.GA337691-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 04, 2023 at 12:37:16PM -0400, Johannes Weiner wrote:
> On Fri, Aug 04, 2023 at 11:37:33AM -0400, Lucas Karpinski wrote:
> > The test allocates dcache inside a cgroup, then destroys the cgroups and
> > then checks the sanity of numbers on the parent level. The reason it
> > fails is because dentries are freed with an RCU delay - a debugging
> > sleep shows that usage drops as expected shortly after.
> > 
> > Insert a 1s sleep after completing the cgroup creation/deletions. This
> > should be good enough, assuming that machines running those tests are
> > otherwise not very busy. This commit is directly inspired by Johannes
> > over at the link below.
> > 
> > Link: https://lore.kernel.org/all/20230801135632.1768830-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> > 
> > Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Maybe I'm missing something, but there isn't a limit set anywhere that
> would cause the dentries to be reclaimed and freed, no? When the
> subgroups are deleted, the objects are just moved to the parent. The
> counters inside the parent (which are hierarchical) shouldn't change.
> 
> So this seems to be a different scenario than test_kmem_basic. If the
> test is failing for you, I can't quite see why.
>
You're right, the parent inherited the counters and it should behave
the same whether I'm directly removing the child or if I was moving it
under another cgroup. I do see the behaviour you described on my
x86_64 setup, but the wrong behaviour on my aarch64 dev. platform. I'll
take a closer look, but just wanted to leave an example here of what I
see.

Example of slab size pre/post sleep:
slab_pre = 18164688, slab_post = 3360000

Thanks,
Lucas


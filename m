From: Lucas Karpinski <lkarpins@redhat.com>
Subject: Re: [PATCH v2] selftests: cgroup: fix test_kmem_memcg_deletion
 kernel mem check
Date: Thu, 17 Aug 2023 14:11:38 -0400
Message-ID: <nnxvxk23hrbr2rj2g5upbks6w766cgubhltfamvsto3mxidcxa@iovra4ubeq35>
References: <jnyjalhg43mdnn6su2a2kmwzqasdyjsfdvipim2i2hvqo7w6y2@st57sbo4bkxf>
 <20230817170702.mwem4nsy2ka4gj7n@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692295912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rTErNomPttgl/viRXoYlofNYirDpLy640wteux782+8=;
        b=YNK5dy8uH35jY42ykJTHL3vk6ecyuqc4Odixp3qIjbUzypaoZPVSfjTVvHxSTGHcDhGmcd
        i61T8KwQGkX5YzdSJMdtpjrd0jQa42BALyqyV7yA58fOgKXFLwqFj2aJGmAzzDWOkai+vH
        fvRwBs2kBKciR1q6GKnBxdoLAegD3Ls=
Content-Disposition: inline
In-Reply-To: <20230817170702.mwem4nsy2ka4gj7n@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 17, 2023 at 05:07:02PM +0000, Shakeel Butt wrote:
> On Thu, Aug 17, 2023 at 08:47:26AM -0400, Lucas Karpinski wrote:
> > The combination of using slab, anon, file, kernel_stack, and percpu is
> > not accurate for total kernel memory utilization. Checking kernel within
> > memory.stat provides a more accurate measurement.
> > 
> > Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
> > ---
> >  v1: https://lore.kernel.org/all/eex2vdlg4ow2j5bybmav73nbfzuspkk4zobnk7svua4jaypqb5@7ie6e4mci43t/
> > 
> >  tools/testing/selftests/cgroup/test_kmem.c | 25 +++++-----------------
> >  1 file changed, 5 insertions(+), 20 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
> > index ed2e50bb1e76..3ef979ee0edf 100644
> > --- a/tools/testing/selftests/cgroup/test_kmem.c
> > +++ b/tools/testing/selftests/cgroup/test_kmem.c
> > @@ -166,7 +166,7 @@ static int cg_run_in_subcgroups(const char *parent,
> >   */
> >  static int test_kmem_memcg_deletion(const char *root)
> >  {
> > -	long current, slab, anon, file, kernel_stack, pagetables, percpu, sock, sum;
> > +	long current, kernel;
> >  	int ret = KSFT_FAIL;
> >  	char *parent;
> >  
> > @@ -184,30 +184,15 @@ static int test_kmem_memcg_deletion(const char *root)
> >  		goto cleanup;
> >  
> >  	current = cg_read_long(parent, "memory.current");
> > -	slab = cg_read_key_long(parent, "memory.stat", "slab ");
> > -	anon = cg_read_key_long(parent, "memory.stat", "anon ");
> > -	file = cg_read_key_long(parent, "memory.stat", "file ");
> > -	kernel_stack = cg_read_key_long(parent, "memory.stat", "kernel_stack ");
> > -	pagetables = cg_read_key_long(parent, "memory.stat", "pagetables ");
> > -	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
> > -	sock = cg_read_key_long(parent, "memory.stat", "sock ");
> > -	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
> > -	    kernel_stack < 0 || pagetables < 0 || percpu < 0 || sock < 0)
> > +	kernel = cg_read_key_long(parent, "memory.stat", "kernel ");
> > +	if (current < 0 || kernel < 0)
> >  		goto cleanup;
> >  
> > -	sum = slab + anon + file + kernel_stack + pagetables + percpu + sock;
> > -	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
> > +	if (abs(kernel - current) < MAX_VMSTAT_ERROR) {
> 
> I don't think this is what you want. Since slab, kernel_stack,
> pagetables and percpu are included in the kmem stats, you just want to
> replace those with kmem. Basically keep the anon, file and sock stats.
>

Will fix and send new patch version.

Thanks,
Lucas


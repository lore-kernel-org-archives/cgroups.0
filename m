From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Wed, 28 Oct 2020 17:14:08 -0700
Message-ID: <20201029001408.GF827280@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com>
 <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=e4qfs3c6hq3qjYfIkZbRYlr987dDDr1SrVeVnLIVytY=;
 b=BCnjdE8miFZTGvw73MM1WJfUTq2WD9Ck/jXMWtjx89Yx7p4OxYVdhh4RED3qr6U2w4wE
 7y5K9rXIuYi+nO06VWUrt9wH7k5RvOUAsHqE8L2uLtyhbvXAP4AZWo94Lq5yreOOuVS1
 7zH5yq5Au6mbcu1FULQDBKq0UqEHtkEqlGo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4qfs3c6hq3qjYfIkZbRYlr987dDDr1SrVeVnLIVytY=;
 b=ZH7NUGHHjQOVtdvr/VTyuYtoHCzC2t211QRqE0B+Q/vfhqPe9lTs9Rw+N3Kts8pdiysNQI+o46Q5k0Rf9ilHd1bhLxnZFcHgjrBvDvBR/ULuxR+UFd0TR0mfd7X87BVitAA7OsmLjxVwjAtGEZHLBYOk4OoSwufDwyERY+9n6J0=
Content-Disposition: inline
In-Reply-To: <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Oct 28, 2020 at 10:56:20AM +0800, Muchun Song wrote:
> On Wed, Oct 28, 2020 at 2:48 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> > > If we reparent the slab objects to the root memcg, when we free
> > > the slab object, we need to update the per-memcg vmstats to keep
> > > it correct for the root memcg. Now this at least affects the vmstat
> > > of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> > > size is smaller than the PAGE_SIZE.
> > >
> > > Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> >
> > Can you, please, drop this patch for now?
> >
> > I'm working on a bigger cleanup related to the handling of the root memory
> > cgroup (I sent a link earlier in this thread), which already does a similar change.
> > There are several issues like this one, so it will be nice to fix them all at once.
> 
> I have read the patch of https://lkml.org/lkml/2020/10/14/869. You
> mean this patch
> fixes this issue? It chooses to uncharge the root memcg. But here we may need to
> uncharge the root memcg to keep root vmstats correct. If we do not do
> this, we can
> see the wrong vmstats via root memory.stat(e.g. NR_KERNEL_STACK_KB).

I pointed at a different patch in the same thread (it looks like you read the first one):
https://lkml.org/lkml/2020/10/21/612

It contained the following part:

@@ -868,7 +860,7 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 	memcg = mem_cgroup_from_obj(p);
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);

So it's exactly what your patch does.

Thanks!

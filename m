From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-next v5 3/4] mm/memcg: Improve refill_obj_stock() performance
Date: Mon, 26 Apr 2021 12:24:02 -0700
Message-ID: <CALvZod7_NtptXi=1QdfgyobL-bw72xGeZ9Sm3pn1pxtZ9crTow@mail.gmail.com>
References: <20210420192907.30880-1-longman@redhat.com> <20210420192907.30880-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1+fehePF1LQa+ETT3QS1bc9x/S6CdwPnRCT51uHUm4=;
        b=Iap4Uo88x+wPaxUmMexmQyhYyjf2sL25rylbPddEu+U/hlOmwkIefEtnY9a0lTsa+d
         DUbgh7t+lOXHdq4VYz0VlwX3lCFYFB9Lm27pp+hlnNM+4iymjU+rWrmDC8hvTSBH4Wv2
         1CkyEz7xj5NMP4EM/vwkZawFtnVeCrcaL9+ByUY9j70Rdaig1pbM0LyMSpkkbYp1A5lL
         /mXaVwXO48K5isxqZhn8/7TsMvkeR+0Z9j4PvHF3GxA75g9scTENPeaggakn1ZRNx/nR
         0GyKQl7X5aA60jsuye9ISomU28l0tO06+F4UFDCPU2V4zz1wWjvJKdL91tRtAT+Rq/2l
         vsRw==
In-Reply-To: <20210420192907.30880-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing@linu>

On Tue, Apr 20, 2021 at 12:30 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> There are two issues with the current refill_obj_stock() code. First of
> all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
> atomically flush out remaining bytes to obj_cgroup, clear cached_objcg
> and do a obj_cgroup_put(). It is likely that the same obj_cgroup will
> be used again which leads to another call to drain_obj_stock() and
> obj_cgroup_get() as well as atomically retrieve the available byte from
> obj_cgroup. That is costly. Instead, we should just uncharge the excess
> pages, reduce the stock bytes and be done with it. The drain_obj_stock()
> function should only be called when obj_cgroup changes.
>
> Secondly, when charging an object of size not less than a page in
> obj_cgroup_charge(), it is possible that the remaining bytes to be
> refilled to the stock will overflow a page and cause refill_obj_stock()
> to uncharge 1 page. To avoid the additional uncharge in this case,
> a new overfill flag is added to refill_obj_stock() which will be set
> when called from obj_cgroup_charge().
>
> A multithreaded kmalloc+kfree microbenchmark on a 2-socket 48-core
> 96-thread x86-64 system with 96 testing threads were run.  Before this
> patch, the total number of kilo kmalloc+kfree operations done for a 4k
> large object by all the testing threads per second were 4,304 kops/s
> (cgroup v1) and 8,478 kops/s (cgroup v2). After applying this patch, the
> number were 4,731 (cgroup v1) and 418,142 (cgroup v2) respectively. This
> represents a performance improvement of 1.10X (cgroup v1) and 49.3X
> (cgroup v2).
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

After incorporating Roman's suggestion, you can add:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

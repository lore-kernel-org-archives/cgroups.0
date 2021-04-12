From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] mm/memcg: Introduce obj_cgroup_uncharge_mod_state()
Date: Mon, 12 Apr 2021 08:50:51 -0700
Message-ID: <CALvZod5m_J4z0sZrd72yftXhYF9PmtJDfRKDK9WVSMvo7PP6uw@mail.gmail.com>
References: <20210409231842.8840-1-longman@redhat.com> <20210409231842.8840-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXdDtDVkOliHR0wKt8o4xOp+hVyUebs5k6d6U80wmt4=;
        b=caAQ4Xqg3sQpXpGaPNU3gKD7/UtnjwdhKAtTaqk6OAPLz6XqnT2JJIRntD7Xo7/K9F
         9Uze7K7jgVp9YNlmci2T07wzH6iQWrk+KTChEXZtVUcgMPlTqiGfCtQyExMN3RCaBNlU
         r3gk9p6TrZEHgs+aBrSlqaWZjux7xtU1Ml1dFps1vFQeJDdkRHM2uZKddjni+P37e0A7
         Dd4j8BViFagxn40TtOl79/kk9ps0I/pPMz8qJ8qkA0WKCny7QuwcCqKUFGQJAY0cEaVT
         1kIY2G4ii+zqIlQgDlq513nOi6v7A0qNOa0mRYFLP5FsDXuMXFkV+1jLK8SEo/JBXW7X
         itog==
In-Reply-To: <20210409231842.8840-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys>

On Fri, Apr 9, 2021 at 4:19 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> In memcg_slab_free_hook()/pcpu_memcg_free_hook(), obj_cgroup_uncharge()
> is followed by mod_objcg_state()/mod_memcg_state(). Each of these
> function call goes through a separate irq_save/irq_restore cycle. That
> is inefficient.  Introduce a new function obj_cgroup_uncharge_mod_state()
> that combines them with a single irq_save/irq_restore cycle.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

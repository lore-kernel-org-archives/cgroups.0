From: Yang Shi <shy828301@gmail.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Fri, 28 Jun 2019 10:16:13 -0700
Message-ID: <CAHbLzkr+EJWgAQ9VhAdeTtMx+11=AX=mVVEvC-0UihROf2J+PA@mail.gmail.com>
References: <20190624174219.25513-1-longman@redhat.com> <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com> <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
 <20190627212419.GA25233@tower.DHCP.thefacebook.com> <0100016b9eb7685e-0a5ab625-abb4-4e79-ab86-07744b1e4c3a-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X/aiZ9J+dd4UJLcrpdr3hoLcNRw4Si2ePjPQfQ4q8YM=;
        b=ahnblyStPij2rtGufd7uEL9kTluJbQDHGS1iKvW73t2ebo3vRNn8FTuQKgazM07J6O
         +wXSCQjEJyVN+Z3gV5TMXtCb4Y0BIUZC4KxjAK9eozvCWn7wRcEL7pPsnDG3O9sFCOtj
         7mtNmpZC6VCXYGNzMz40aPZe0km5xgpLwl3cJ2tu5+2EK3h7m9alVYStSrdTVHqHMtp8
         JjPRmJwPCsm/WT2+xKeeXM+QzweX3GmM5GeVUw98UEEx+NBdcny3Wqp02cGUnsp03S2w
         3znGOn57MuwAlyVtWFo05byzrDA0uYw0CMUTrbFQ7ORqxyJYHci8YsBH/OSm/emVhCjd
         KvHg==
In-Reply-To: <0100016b9eb7685e-0a5ab625-abb4-4e79-ab86-07744b1e4c3a-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Jun 28, 2019 at 8:32 AM Christopher Lameter <cl@linux.com> wrote:
>
> On Thu, 27 Jun 2019, Roman Gushchin wrote:
>
> > so that objects belonging to different memory cgroups can share the same page
> > and kmem_caches.
> >
> > It's a fairly big change though.
>
> Could this be done at another level? Put a cgoup pointer into the
> corresponding structures and then go back to just a single kmen_cache for
> the system as a whole? You can still account them per cgroup and there
> will be no cleanup problem anymore. You could scan through a slab cache
> to remove the objects of a certain cgroup and then the fragmentation
> problem that cgroups create here will be handled by the slab allocators in
> the traditional way. The duplication of the kmem_cache was not designed
> into the allocators but bolted on later.

I'm afraid this may bring in another problem for memcg page reclaim.
When shrinking the slabs, the shrinker may end up scanning a very long
list to find out the slabs for a specific memcg. Particularly for the
count operation, it may have to scan the list from the beginning all
the way down to the end. It may take unbounded time.

When I worked on THP deferred split shrinker problem, I used to do
like this, but it turns out it may take milliseconds to count the
objects on the list, but it may just need reclaim a few of them.

>

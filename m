From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Wed, 8 Jun 2022 19:53:43 -0700
Message-ID: <YqFgt6nZn78euEb/@carbon>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <CAMZfGtX4hseDnJA9JrsXDG=nu28h+9UMMpKFnBZCL47Re1OvUg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654743229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=liHmTBtyJ9J2SmbRAamKC6TDE1854irD6g+yxKU90Rg=;
        b=Zewa/ikGSBOIhVlHKnzCYGIZRO7S1NDsj/t9KqNUA1RDrdSxf5B0jNigzCKcfzgGlz4VHB
        5fXAmKGHvfNVQcJYP9UgReR+ypsq/ZXZJr5Q3jDsVINJO7iIqShxfwgSixK19rEiPfXV7G
        pySvDgNd5zNfe6UqcMm9i2Nf4sj4LnM=
Content-Disposition: inline
In-Reply-To: <CAMZfGtX4hseDnJA9JrsXDG=nu28h+9UMMpKFnBZCL47Re1OvUg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Xiongchun duan <duanxiongchun@bytedance.com>, Waiman Long <longman@redhat.com>

On Thu, Jun 09, 2022 at 10:43:24AM +0800, Muchun Song wrote:
> Hi,
> 
> Friendly ping. Any comments or objections?

I'm sorry, I was recently busy with some other stuff, but it's on my todo list.
I'll try to find some time by the end of the week.

Thanks!

> 
> Thanks.
> 
> On Mon, May 30, 2022 at 3:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > This version is rebased on v5.18.
> >
> > Since the following patchsets applied. All the kernel memory are charged
> > with the new APIs of obj_cgroup.
> >
> >         [v17,00/19] The new cgroup slab memory controller [1]
> >         [v5,0/7] Use obj_cgroup APIs to charge kmem pages [2]

Btw, both these patchsets were merged a long time ago, so you can refer
to upstream commits instead.

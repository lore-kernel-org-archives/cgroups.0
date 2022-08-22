From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Mon, 22 Aug 2022 09:04:59 -0700
Message-ID: <CALvZod4whYX+0ZuCGgyKuG-Q_9d0g7N_x+=WXOeB_1TM=3Q7vg@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <YwNZD4YlRkvQCWFi@dhcp22.suse.cz> <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
 <YwOde3qFvne7Umld@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Gsdq66BkjynIpRPrwWnOavgdKVDsGQ5+owwtyl9S4wc=;
        b=FCtgY9iinm8oIY5V3F0fuHisMULPTP8CQ+xh/Bo5Gk3eVocKSH5pJdqM+NrFCk5yNp
         C/YGEDtKfv2IeT6AmCu73ng/KgcB1e3J6zvGZBDJaQRXHcj3tN23Tv/MhEOscujEMLJ5
         xyYk5bpEg2crzlxiekFp9X9OD/yfiaG6k0mDe8aulUmg8Umb7MrkjHZX4pGlK3JTLFNe
         Ywl56Z7zDPixLCxQT7eP7burucLhwhQBi8Bmc51HtR0S3LB5qkV698CWc9NctsG4DkCE
         5U6M+vkFI6nGdhVyAgLZmrPCSAgv732qwe2Dng3VOnpr0ocEVXV6qBHvaBbf6pfIfatM
         h98g==
In-Reply-To: <YwOde3qFvne7Umld@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Aug 22, 2022 at 8:15 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 22-08-22 08:06:14, Shakeel Butt wrote:
> [...]
> > > >  struct page_counter {
> > > > +     /*
> > > > +      * Make sure 'usage' does not share cacheline with any other field. The
> > > > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > > > +      */
> > > > +     PC_PADDING(_pad1_);
> > >
> > > Why don't you simply require alignment for the structure?
> >
> > I don't just want the alignment of the structure. I want different
> > fields of this structure to not share the cache line. More
> > specifically the 'high' and 'usage' fields. With this change the usage
> > will be its own cache line, the read-most fields will be on separate
> > cache line and the fields which sometimes get updated on charge path
> > based on some condition will be a different cache line from the
> > previous two.
>
> I do not follow. If you make an explicit requirement for the structure
> alignement then the first field in the structure will be guarantied to
> have that alignement and you achieve the rest to be in the other cache
> line by adding padding behind that.

Oh, you were talking explicitly about _pad1_, yes, we can remove it
and make the struct cache align. I will do it in the next version.

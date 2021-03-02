From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to
 CONFIG_MEMCG_KMEM
Date: Mon, 1 Mar 2021 19:58:06 -0800
Message-ID: <YD23zlVg+1sKJYvy@carbon.DHCP.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com>
 <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
 <CALvZod4rWvMJdnbfMm4SGtj0WyqDzvH8RY9G32y=NLNCZqJ2Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1anEYPlXeCA8QVDJWhWrL7Jesrjov7VMWN5N28YTCOg=;
 b=XAPWDmlLUoJX5jDl2d7KacxV6G/fAF8Fy3uQdSpPBsP295FNUAgCzup5l45sLRSQ7OY2
 aO4j6vrIH7NZfPB76jVWLEFcb4dvmbNcRYfGmq8oAqHqnEGA3rlhSq5FMJDDFyNRMi3G
 VpDeJPZeHYArFXt1zEIHelTX7DdcxG8ys3s= 
Content-Disposition: inline
In-Reply-To: <CALvZod4rWvMJdnbfMm4SGtj0WyqDzvH8RY9G32y=NLNCZqJ2Gg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Muchun Song <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, esyr@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Mon, Mar 01, 2021 at 07:43:27PM -0800, Shakeel Butt wrote:
> On Mon, Mar 1, 2021 at 5:16 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> > > The remote memcg charing APIs is a mechanism to charge kernel memory
> > > to a given memcg. So we can move the infrastructure to the scope of
> > > the CONFIG_MEMCG_KMEM.
> >
> > This is not a good idea, because there is nothing kmem-specific
> > in the idea of remote charging, and we definitely will see cases
> > when user memory is charged to the process different from the current.
> >
> 
> Indeed and which remind me: what happened to the "Charge loop device
> i/o to issuing cgroup" series? That series was doing remote charging
> for user pages.

Yeah, this is exactly what I minded. We're using it internally, and as I
remember there were no obstacles to upstream it too.
I'll ping Dan when after the merge window.

Thanks!

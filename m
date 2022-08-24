From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Wed, 24 Aug 2022 17:34:42 +0800
Message-ID: <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
References: <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
 <Yv/EArPDTcCrGqJh@slm.duckdns.org> <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
 <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
 <YwRjyx6wFLk8WTDe@dhcp22.suse.cz> <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
 <YwSQ4APOu/H7lYGL@dhcp22.suse.cz> <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz> <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GCl8dHqPSzKvC1qvvjcvE0b120LUuRhLO2pWkva8f+U=;
        b=GstEXS+VfViwMMFI9HBPPaVshMA7v+fU6E0LQ2UW84b7h0tAoknsXgpbrvStzEf8p6
         aHTgEit/8mjbIJRRSRjqQkyTybpZ9qjHpci+7CAA2JFANBa9HpMekvB3o+4Ebcl5nwIM
         nF2pdYIK6LxUdCW+Q8djZYUjpkrYCkZbafYjdD9U2N8TBmEG/r+Gr+UEW27jzJyRozif
         +rAcIQSy5Uw8kJlnIuswEMcxNWjKkl9gGBnw+Aan0zqqY/1MYB0YYJBOdWAN5hisBrDF
         NXOsjql7wKVQ+X5UqkHjyRsg2FwE1r2BPa6GXfl8ePOee01L0QVZfoqfNqLxCG8KsoXg
         qn9w==
In-Reply-To: <YwXYVjRpXQjQMsxr-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Wed, Aug 24, 2022 at 3:50 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 24-08-22 10:23:14, Zhaoyang Huang wrote:
> > On Tue, Aug 23, 2022 at 7:51 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> [...]
> > > One way to achieve that would be shaping the hierarchy the following way
> > >             root
> > >         /         \
> > > no_memcg[1]      memcg[2]
> > > ||||||||         |||||
> > > app_cgroups     app_cgroups
> > >
> > > with
> > > no_memcg.subtree_control = ""
> > > memcg.subtree_control = memory
> > >
> > > no?
> > According to my understanding, No as there will be no no_memcg. All
> > children groups under root would have its cgroup.controllers = memory
> > as long as root has memory enabled.
>
> Correct
>
> > Under this circumstance, all
> > descendants group under 'no_memcg' will charge memory to its parent
> > group.
>
> Correct. And why is that a problem? I thought you main concern was a per
> application LRUs. With the above configuration all app_cgroups which do
> not require an explicit memory control will share the same (no_memcg)
> LRU and they will be aged together.
I can't agree since this indicates the processes want memory free
depending on a specific hierarchy which could have been determined by
other subsys. IMHO, charging the pages which out of explicitly memory
enabled group to root could solve all of the above constraints with no
harm.
> --
> Michal Hocko
> SUSE Labs

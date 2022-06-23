From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 23 Jun 2022 18:37:02 +0200
Message-ID: <YrSWruhPlJV1X9kp@dhcp22.suse.cz>
References: <20220623000530.1194226-1-yosryahmed@google.com>
 <YrQe5A+FXnbgOR1f@dhcp22.suse.cz>
 <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz>
 <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656002224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xjy8SPQ+d5ER4berxN3l8OR04THIzep3YipbQ/OBM0g=;
        b=Ew+9Nb9MszfcKz8/CBOy/vbT3LdyWXYXJmxRGKgwX44dyVrdqLUM2gHRY/sEx6UyjnRIDM
        XzKj749fNM/8KrvLqqDkVWcOjsXB8hvCCVPr2RXCWZIpa/zrlE67nFC15urvWI1xAa1OjU
        AnLic47l3onMcYVNv9L25O3PWNX0d3c=
Content-Disposition: inline
In-Reply-To: <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu 23-06-22 09:22:35, Yosry Ahmed wrote:
> On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
[...]
> > > In our internal version of memory.reclaim that we recently upstreamed,
> > > we do not account vmpressure during proactive reclaim (similar to how
> > > psi is handled upstream). We want to make sure this behavior also
> > > exists in the upstream version so that consolidating them does not
> > > break our users who rely on vmpressure and will start seeing increased
> > > pressure due to proactive reclaim.
> >
> > These are good reasons to have this patch in your tree. But why is this
> > patch benefitial for the upstream kernel? It clearly adds some code and
> > some special casing which will add a maintenance overhead.
> 
> It is not just Google, any existing vmpressure users will start seeing
> false pressure notifications with memory.reclaim. The main goal of the
> patch is to make sure memory.reclaim does not break pre-existing users
> of vmpressure, and doing it in a way that is consistent with psi makes
> sense.

memory.reclaim is v2 only feature which doesn't have vmpressure
interface. So I do not see how pre-existing users of the upstream kernel
can see any breakage.

-- 
Michal Hocko
SUSE Labs

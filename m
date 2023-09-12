From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes
 help unified flushes
Date: Tue, 12 Sep 2023 13:03:20 +0200
Message-ID: <ZQBFeHxzO49gv987@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com>
 <ZPXupwjewuLgksAI@dhcp22.suse.cz>
 <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
 <ZPX6luPGqypp68+L@dhcp22.suse.cz>
 <hrpw2bjsrs3pzxympb7cz4nohyeztnxkmdtzbzlfdba6ugkken@dhcdbbbrv4fn>
 <CAJD7tkaHVtMiMYFocNiABuyhPcqt77gei0UeaDq4J7V-=tMFYA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694516601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PlNpuPSqWIqOE0DwsvfoNnsmeYOzW02ShwOmRdVvGGY=;
        b=MhPUvXVFP4OmyPGqhryRQRDMUAdVx6IyQ77oN9SuE0NTFREpi/Hr63l8a46k1tz1U6gLxS
        spIv8n4MmEY/r1mNnpLOYB6XQ9CYXFhXwTf5u7t1Eg6gr5jSeOSbdW+0fZMDkMZuCfz0OC
        TIHai/JH/h+g3ExVXULDJaSjK/ypAhI=
Content-Disposition: inline
In-Reply-To: <CAJD7tkaHVtMiMYFocNiABuyhPcqt77gei0UeaDq4J7V-=tMFYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 05-09-23 08:54:46, Yosry Ahmed wrote:
> On Tue, Sep 5, 2023 at 7:10 AM Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Mon, Sep 04, 2023 at 05:41:10PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > So it also creates an undocumented but userspace visible behavior.
> > > Something that userspace might start depending on, right?
> >
> > Yes but -
> > - depending on undocumented behavior is a mistake,
> > - breaking the dependency would manifest (in the case I imagine) as a
> >   performance regression (and if there are some users, the future can
> >   allow them configuring periodic kernel flush to compensate for that).
> 
> I think I am missing something. This change basically makes userspace
> readers (for the root memcg) help out unified flushers, which are
> in-kernel readers (e.g. reclaim) -- not the other way around.
> 
> How would that create a userspace visible behavior that a dependency
> can be formed on? Users expecting reclaim to be faster right after
> reading root stats? I would guess that would be too flaky to cause a
> behavior that people can depend on tbh.

Flaky or not, it might cause behavior difference and a subtle one. I can
imagine nohz and similar workloads wanting to (ab)use this to reduce
kernel footprint. If we really need this then make it obvious in the
changelog at least.

-- 
Michal Hocko
SUSE Labs

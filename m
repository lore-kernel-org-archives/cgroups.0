From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Wed, 20 Apr 2022 14:47:10 +0200
Message-ID: <YmAAzkwGg6GspCiu@dhcp22.suse.cz>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com>
 <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <YlBCeadBqbeVvALK@dhcp22.suse.cz>
 <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <CAJD7tkbFjbGJ7CnNogpGq5enh_uhP8T5c0U+ku9PfwMoVLf2gg@mail.gmail.com>
 <CAJD7tkYJj2O-zaux9BZxJxG+JBjPrwRYKXPAAAh7i9GVE53VGQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650458832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fE2JVFjVSECX2xSom7dha9uadrw2m4rx6MxVgcht3TU=;
        b=ls08cpYNS6BsFKbzep+CNbq8sfVdl2ellBWBujxnccydNYGlZusiruxwRBWAGNdG+LbEjN
        jBIdNmHiFta1RBcAXwfZU0dmIdTZsOgoaKPo4njd2eiadAdPKoabYOFObP16BYeeo/IWJ6
        6qVYRksrngynbRG+maQ3Tkc4EqFNkn0=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYJj2O-zaux9BZxJxG+JBjPrwRYKXPAAAh7i9GVE53VGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kern>

On Thu 14-04-22 10:25:29, Yosry Ahmed wrote:
> On Fri, Apr 8, 2022 at 1:08 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, Apr 8, 2022 at 7:55 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > On Fri, Apr 08, 2022 at 04:11:05PM +0200, Michal Hocko wrote:
> > > > Regarding "max" as a possible input. I am not really sure to be honest.
> > > > I can imagine that it could be legit to simply reclaim all the charges
> > > > (e.g. before removing the memcg) which should be achieveable by
> > > > reclaiming the reported consumption. Or what exactly should be the
> > > > semantic?
> > >
> > > Yeah, it just allows you to avoid reading memory.current to just
> > > reclaim everything if you can specify "max" - you're still protected
> > > by nretries to eventually bail out. Mostly, though I just feel like
> > > supporting "max" makes memory.reclaim semetric with a lot of the
> > > cgroup memory control files which tend to support "max".
> >
> > One possible approach here is to have force_empty behavior when we
> > write "max" to memory.reclaim. From Google's perspective we don't have
> > a preference, but it seems to me like logical behavior. We can do this
> > either by directly calling mem_cgroup_force_empty() or just draining
> > stock and lrus in memory_reclaim().
> >
> > This actually brings up another interesting point. Do you think we
> > should drain lrus if try_to_free_mem_cgroup_pages() fails to reclaim
> > the request amount? We can do this after the first call or before the
> > last one. It could introduce more evictable pages for
> > try_to_free_mem_cgroup_pages() to free.
> 
> Hey Michal, any thoughts on this? I am looking for feedback on this
> before I send out v4.

As I've already said I do not have strong preferences for the "max"
value to be accepted by the interface. Maybe you can add a support for
max in a separate patch so the discussion would not delay the rest of
the work.

For the LRU draining I do not see any problem for that to be added. The
overhead of the operation would increase, especially on larger machines,
which could be a concern. So the real question is whether not doing so
is a big problem. Our force_empty implementation optimistically drains
pcp caches but please note that this is not really guranteeing anything
as charges can happen at any time. 

-- 
Michal Hocko
SUSE Labs

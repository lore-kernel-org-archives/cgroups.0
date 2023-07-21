From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 09:18:24 -1000
Message-ID: <ZLraAD0F-McgdJNv@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
 <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
 <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
 <ZLrN1BE42Tsybm6j@slm.duckdns.org>
 <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689967106; x=1690571906;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sxUJQYgkClQx653D+GLhwGjuASPJZY3UChFEBbRQygA=;
        b=mAkNV7/TkrTRt+4xRyYVs8bvaw/fK1B7/XnSKv8lxCseRRpsGfLzQfkVn+eOClOviz
         88azYzYMlLiQwxDNiTu9AYJAdsHizyT/BwQ8Plm2itEb9RnWNeRgCSFf4EdIS16a1sak
         aYRBKLeMZQMW9EVuXp0t0qMaCiRc1rHmVMWfmOh5gDdfXGa0oG+YG2830o3mTPdvHL6e
         vH9U7Mt3P3EmCao0guiqhKMLkn+xj3uxeSldJ3kgXK9mSNRmQ8CAWR6EavAWBeJ6WDMN
         pp1i6eklTZCez9JN3tl2Y/wC2ZsyC0RyRmxlVGUPhyrr/flYK7KV0HpNYHCV9Cf2ZY33
         kxfg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jul 21, 2023 at 11:47:49AM -0700, Yosry Ahmed wrote:
> On Fri, Jul 21, 2023 at 11:26 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Fri, Jul 21, 2023 at 11:15:21AM -0700, Yosry Ahmed wrote:
> > > On Thu, Jul 20, 2023 at 3:31 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > memory at least in our case. The sharing across them comes down to things
> > > > like some common library pages which don't really account for much these
> > > > days.
> > >
> > > Keep in mind that even a single page charged to a memcg and used by
> > > another memcg is sufficient to result in a zombie memcg.
> >
> > I mean, yeah, that's a separate issue or rather a subset which isn't all
> > that controversial. That can be deterministically solved by reparenting to
> > the parent like how slab is handled. I think the "deterministic" part is
> > important here. As you said, even a single page can pin a dying cgroup.
> 
> There are serious flaws with reparenting that I mentioned above. We do
> it for kernel memory, but that's because we really have no other
> choice. Oftentimes the memory is not reclaimable and we cannot find an
> owner for it. This doesn't mean it's the right answer for user memory.
> 
> The semantics are new compared to normal charging (as opposed to
> recharging, as I explain below). There is an extra layer of
> indirection that we did not (as far as I know) measure the impact of.
> Parents end up with pages that they never used and we have no
> observability into where it came from. Most importantly, over time
> user memory will keep accumulating at the root, reducing the accuracy
> and usefulness of accounting, effectively an accounting leak and
> reduction of capacity. Memory that is not attributed to any user, aka
> system overhead.

That really sounds like the setup is missing cgroup layers tracking
persistent resources. Most of the problems you describe can be solved by
adding cgroup layers at the right spots which would usually align with the
logical structure of the system, right?

...
> I believe recharging is being mis-framed here :)
> 
> Recharging semantics are not new, it is a shortcut to a process that
> is already happening that is focused on offline memcgs. Let's take a
> step back.

Yeah, it does sound better when viewed that way. I'm still not sure what
extra problems it solves tho. We experienced similar problems but AFAIK all
of them came down to needing the appropriate hierarchical structure to
capture how resources are being used on systems.

Thanks.

-- 
tejun

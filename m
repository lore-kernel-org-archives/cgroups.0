From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] shrink support for memcg kmem controller
Date: Tue, 21 Feb 2012 15:35:10 -0800
Message-ID: <CABCjUKCcGWsSqUnN-9g77bTLQdZ0HF3ryLz+2PyLK1VucqPjSg@mail.gmail.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com>
	<1329824079-14449-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=ckv6JxxzKzYHW3k/jlF5jUkn2H4arpA8RxmGau7t7i8=;
        b=pHfSyd3PKsNoA4lL9E7mHOcojC1IvRonhE0elXg+G7dJBaawbpwjtSXwyfGmtU5/PP
         +ME+EuZIg1ZIZgGv57321QHRsgGXD98vW2FlAjdAIZxi9ilrNqZOT/1D4yBbseETILoR
         2MFCXGgI1oSHpKQp84OdWFVfQAOKvWiAMEiOY=
In-Reply-To: <1329824079-14449-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:

> @@ -5055,8 +5117,21 @@ int memcg_kmem_newpage(struct mem_cgroup *memc=
g, struct page *page, unsigned lon
> =A0{
> =A0 =A0 =A0 =A0unsigned long size =3D pages << PAGE_SHIFT;
> =A0 =A0 =A0 =A0struct res_counter *fail;
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 bool do_softlimit;
> +
> + =A0 =A0 =A0 ret =3D res_counter_charge(memcg_kmem(memcg), size, &fa=
il);
> + =A0 =A0 =A0 if (unlikely(mem_cgroup_event_ratelimit(memcg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 MEM_CGROUP_TARGET_THRESH))) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_softlimit =3D mem_cgroup_event_ratel=
imit(memcg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 MEM_CGROUP_TARGET_SOFTLIMIT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_threshold(memcg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(do_softlimit))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_update_tree(=
memcg, page);
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 return res_counter_charge(memcg_kmem(memcg), size, &fai=
l);
> + =A0 =A0 =A0 return ret;
> =A0}

It seems like this might cause a lot of kernel memory allocations to
fail whenever we are at the limit, even if we have a lot of
reclaimable memory, when we don't have independent accounting.

Would it be better to use __mem_cgroup_try_charge() here, when we
don't have independent accounting, in order to deal with this
situation?

-- Suleiman

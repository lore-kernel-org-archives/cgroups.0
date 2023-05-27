From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sat, 27 May 2023 16:07:08 +0100
Message-ID: <ZHIcnOV/mrkcerlG@casper.infradead.org>
References: <20230527103126.398267-1-linmiaohe@huawei.com>
 <ZHGAcaqOx/e8lqwV@casper.infradead.org>
 <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=loxo3o+bCByV7kuxO8tBvwlfDa2341F3CpYgMrLNBcA=; b=AfN7nBhiA+MsFKTyviECPRCgZG
        cji0YDU+jsr87bzmrt10rBcc5NwzjUiNNHINgZV0FeQHCeGKL5PbmI58kQ4wXUPyt7BowsndH05J6
        vKhMd5kdVYhYAWwpr0q7dKn8UFbYqtB8mI9fdOHj9An/K0TpwcUTJ3mrd/HVS5FrPvVOaP7D2Y58s
        HObFa4n4setAY/vRQ5EfL84Rxi1iHLQJUifvZITYUBUrgPNgJGdQ3Q7uNnMLlwahFqDYCX5Lu3TTB
        /1I8RtvxvQRzAUggbAKizv5koVTqUxkvB18EED/l6BseB9iOZQKTQoCymtfBPiewYHl9D1g78AU4M
        yUosG5fg==;
Content-Disposition: inline
In-Reply-To: <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 26, 2023 at 09:13:05PM -0700, Yosry Ahmed wrote:
> On Fri, May 26, 2023 at 9:01=E2=80=AFPM Matthew Wilcox <willy-wEGCiKHe2Lq=
WVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Sat, May 27, 2023 at 06:31:26PM +0800, Miaohe Lin wrote:
> > > The function mem_cgroup_from_obj() is not used anymore. Remove it and
> > > clean up relevant comments.
> >
> > You should have looked at the git history to see why it was created
> > and who used it.
> >
> > Shakeel, Vasily, are you going to retry adding commit 1d0403d20f6c?
>=20
> That commit did not introduce the function though, no? It was
> introduced before it and replaced by other variants over time (like
> mem_cgroup_from_slab_obj()). It looks like that commit was reverted ~9
> months ago. We can always bring it back if/when needed.

The commit immediately preceding it is fc4db90fe71e.

Of course we can bring it back.  It's just code.  But avoiding
unnecessary churn is also good.  Let's wait to hear from Vasily.

> It also looks to me that 1d0403d20f6c was using mem_cgroup_from_obj()
> on a struct net object, which is allocated in net_alloc() from a slab
> cache, so mem_cgroup_from_slab_obj() should be sufficient, no?

Clearly not.

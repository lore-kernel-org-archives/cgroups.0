From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: localize
 mem_cgroup_sockets_enabled() check
Date: Tue, 13 Oct 2020 00:04:44 +0800
Message-ID: <CAMZfGtXE1DaDXSOWObaJDTxUH2zB2hjfKoX38Y2oKgNaDkyoCA@mail.gmail.com>
References: <20201010104521.67262-1-songmuchun@bytedance.com> <20201012135823.GA188876@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8I5XKTgq/Z0bLvn2YmKFNFJu3bvFZkBI41VZpa4KwVY=;
        b=ZjmvDvxLIavsomBf4sUVGuCczLwUrYqvKoVsenBx5ZDRysgwBdTa+1a1hCLp4Qv/HB
         k4Wxd5SxpANhGENEB9lk+phhkrybxUbtpj3DlcrL1Q7YuRIsYIHnjAlD+kfS0fSxfR8y
         9WfbcrXwfavgTijWwW63FTK24YGHQMz+hktTJfj+1mgQCNXDExJDfFVLF00EwSS8Frz9
         P3dg0bc4S4XIpcPWsub1WMZmrlYxkqIYdJNiHh9PUyVvS7Uuvo7U99bT7Pxc2Oq9qcDg
         7BQxc8sXd+fJ3+GfRaJ16RG40eODbhCHJET4XmpCc9mchniOFbFOF9DU45Mv5RnpltPa
         ZS6w==
In-Reply-To: <20201012135823.GA188876-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm@kvack.>

On Mon, Oct 12, 2020 at 9:59 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Sat, Oct 10, 2020 at 06:45:21PM +0800, Muchun Song wrote:
> > Move the mem_cgroup_sockets_enabled() checks into memcg socket charge
> > or uncharge functions, so the users don't have to explicitly check that
> > condition.
> >
> > This is purely code cleanup patch without any functional change. But
> > move the sk_memcg member of the sock structure to the CONFIG_MEMCG
> > scope.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  include/linux/memcontrol.h      | 78 ++++++++++++++++++++++++++-------
> >  include/net/sock.h              |  5 ++-
> >  include/net/tcp.h               |  3 +-
> >  mm/memcontrol.c                 | 43 +++++++++++++-----
> >  net/core/sock.c                 | 15 +++----
> >  net/ipv4/inet_connection_sock.c |  6 +--
> >  net/ipv4/tcp_output.c           |  3 +-
> >  7 files changed, 111 insertions(+), 42 deletions(-)
>
> Hm, this is almost 3 times as much code.
>
> The sk_memcg saving on !CONFIG_MEMCG is somewhat nice, but it's not
> clear how many users would benefit here. And it adds ifdefs in code.

The 'ifdefs in code' means the initialization of sk_memcg in the sk_clone_lock?
If yes, we can add a new inline initialization function to avoid this.

>
> Also memcg code now has to know about struct sock.

Without this patch, the memcg code also has to know about struct sock.
You can see the code of  mem_cgroup_sk_alloc and mem_cgroup_sk_free.

Thanks.

>
> I'm not quite sure that this is an overall improvement.



-- 
Yours,
Muchun

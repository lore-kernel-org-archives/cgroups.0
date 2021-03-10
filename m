From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/9] memcg: accounting for fib6_nodes cache
Date: Tue, 9 Mar 2021 16:13:48 -0800
Message-ID: <YEgPPLYHnaphsB7V@carbon.dhcp.thefacebook.com>
References: <f105248d-bd21-8e6f-bdac-4f2c4792fc4b@virtuozzo.com>
 <CALvZod5QnzwpKwGqCYDKMUpHgPcvtS99go+u34NYGKaWsr0UAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ujkvm2nAZ7bhInatZ2ieQWioqdcNWNp1J22DUEpB7hk=;
 b=o0Y2V44fTAoWgJ+YiNxaavdmjUnAiI/H6V6ALJwebXd9qbrbqTMQl3oYua0iv3o8lgmS
 hQwM3tqPFayv28lVJGS97n2IQ7bIQW9U15C2iP1H+uXO8ainLaoWSf64eMo3EZovl/VW
 s4nu0MQQqU27Gzl6pd+ybPZevpu7GB2CMYU= 
Content-Disposition: inline
In-Reply-To: <CALvZod5QnzwpKwGqCYDKMUpHgPcvtS99go+u34NYGKaWsr0UAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 09, 2021 at 01:16:13PM -0800, Shakeel Butt wrote:
> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> >
> > Objects can be created from memcg-limited tasks
> > but its misuse may lead to host OOM.
> >
> > Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > ---
> >  net/ipv6/ip6_fib.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> > index ef9d022..fa92ed1 100644
> > --- a/net/ipv6/ip6_fib.c
> > +++ b/net/ipv6/ip6_fib.c
> > @@ -2445,7 +2445,7 @@ int __init fib6_init(void)
> >
> >         fib6_node_kmem = kmem_cache_create("fib6_nodes",
> 
> Can you talk a bit more about the lifetime of the object created from
> this kmem cache? Also who and what operation can trigger allocation?

The lifetime is less of a concern since we have a slab reparenting mechanism,
unless it's a very short-living object.

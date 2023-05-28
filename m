From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sun, 28 May 2023 21:01:37 +0800
Message-ID: <D2B59104-B602-45A3-B938-AE5DC67BAC98@linux.dev>
References: <20230527103126.398267-1-linmiaohe@huawei.com>
 <ZHGAcaqOx/e8lqwV@casper.infradead.org>
 <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com>
 <ZHIcnOV/mrkcerlG@casper.infradead.org>
 <CAJD7tkZ2Q1ZCqNchpiiC6FCE08dYH6tzANA=VqujeDgT8YhRUA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685278936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZXa+Q1xIzbQ2IAdpFSYo7sWvHd3UcTbXBMlCfmZbUY=;
        b=RMKThOY2ZnoegXflMWRJU6adp4QipmRp12PejT2eSBK5bGcQuCW/uwq5m7XRDS/fpn8M+H
        TlgkD1l4KBJ4QFavGpsbbNmOnikoASMtE6nscS8YaMUy2OFyi2uR4ZJNY1V4REsxC7cOO2
        Io2kSEYTrQJnHO5WUV1QMF8iulfouBQ=
In-Reply-To: <CAJD7tkZ2Q1ZCqNchpiiC6FCE08dYH6tzANA=VqujeDgT8YhRUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



> On May 28, 2023, at 02:54, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On Sat, May 27, 2023 at 8:07=E2=80=AFAM Matthew Wilcox =
<willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>=20
>> On Fri, May 26, 2023 at 09:13:05PM -0700, Yosry Ahmed wrote:
>>> On Fri, May 26, 2023 at 9:01=E2=80=AFPM Matthew Wilcox =
<willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>>>=20
>>>> On Sat, May 27, 2023 at 06:31:26PM +0800, Miaohe Lin wrote:
>>>>> The function mem_cgroup_from_obj() is not used anymore. Remove it =
and
>>>>> clean up relevant comments.
>>>>=20
>>>> You should have looked at the git history to see why it was created
>>>> and who used it.
>>>>=20
>>>> Shakeel, Vasily, are you going to retry adding commit 1d0403d20f6c?
>>>=20
>>> That commit did not introduce the function though, no? It was
>>> introduced before it and replaced by other variants over time (like
>>> mem_cgroup_from_slab_obj()). It looks like that commit was reverted =
~9
>>> months ago. We can always bring it back if/when needed.
>>=20
>> The commit immediately preceding it is fc4db90fe71e.
>>=20
>> Of course we can bring it back.  It's just code.  But avoiding
>> unnecessary churn is also good.  Let's wait to hear from Vasily.
>>=20
>>> It also looks to me that 1d0403d20f6c was using =
mem_cgroup_from_obj()
>>> on a struct net object, which is allocated in net_alloc() from a =
slab
>>> cache, so mem_cgroup_from_slab_obj() should be sufficient, no?
>>=20
>> Clearly not.
>=20
> I dived deeper into the history on LKML, and you are right:
> https://lore.kernel.org/all/Yp4F6n2Ie32re7Ed@qian/
>=20
> I still do not understand why mem_cgroup_from_slab_obj() would not be
> sufficient, so I am hoping Vasily or Shakeel can help me understand
> here. Seems to be something arch-specific.

I think it is because *init_net* which is not allocated from slab meant
its address does not belong to linear mapping addresses on arm64. =
However,
virt_to_page() is only applicable to linear mapping addresses. So,
mem_cgroup_from_slab_obj() is not sufficient. mem_cgroup_from_obj() is =
used
in this case, which will use vmalloc_to_page() for the page associated
with *init_net*. If Vasily does not want to bring commit 1d0403d20f6c =
back,
this patch LGTM. Otherwise, let's wait for Vasily.

Thanks.


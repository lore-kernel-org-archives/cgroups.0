From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Tue, 14 Mar 2023 23:06:53 -0400
Message-ID: <61e8e6d3-697e-f9a5-a1fb-45a3448ee5db@redhat.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678849621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/9uUNak1Tu2TI0+onJdIdCGcTQ1Jze/K6cutYT1dX2Y=;
        b=NUuLDFKSTXovbx8tqwf/S0x8P/vK0pVNOho/s8j20bBitVMS3sov0n4e3VuIXDUfJVNpuD
        dzohhgejRhBXKjNkESy6lHgNmm0QGYmyyoe32pZ5z9R1pZnbPNcG/3ugjMXKcsihRHbuSW
        +HNT42bVzs9dPp432oT3Do01bJHdWVw=
Content-Language: en-US
In-Reply-To: <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 3/13/23 17:08, Yosry Ahmed wrote:
> On Mon, Mar 13, 2023 at 12:44=E2=80=AFPM Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>> On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT=
0dZR+AlfA@public.gmane.org> wrote:
>>
>>> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>
>>> In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
>>> observed a warning from page_cgroup_ino() when reading
>>> /proc/kpagecgroup.
>> If this is the only known situation in which page_memcg_check() is
>> passed a tail page, why does page_memcg_check() have
>>
>>          if (PageTail(page))
>>                  return NULL;
>>
>> ?  Can we remove this to simplify, streamline and clarify?
> I guess it's a safety check so that we don't end up trying to cast a
> tail page to a folio. My opinion is to go one step further and change
> page_memcg_check() to do return the memcg of the head page, i.e:
>
> static inline struct mem_cgroup *page_memcg_check(struct page *page)
> {
>      return folio_memcg_check(page_folio(page));
> }
>
> This makes it consistent with page_memcg(), and makes sure future
> users are getting the "correct" memcg for whatever page they pass in.
> I am interested to hear other folks' opinions here.
>
> The only other user today is print_page_owner_memcg(). I am not sure
> if it's doing the right thing by explicitly reading page->memcg_data,
> but it is already excluding pages that have page->memcg_data =3D=3D 0,
> which should be the case for tail pages.

It is reading memcg_data directly to see if it is slab cache page. It is=20
currently skipping page that does not have memcg_data set.

Cheers,
Longman


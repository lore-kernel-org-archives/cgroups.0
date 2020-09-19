From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 00/13] mm: clean up some lru related pieces
Date: Sat, 19 Sep 2020 08:31:26 +0800
Message-ID: <56062aa9-bec7-6757-e49b-f94da141cb2c@linux.alibaba.com>
References: <20200918030051.650890-1-yuzhao@google.com>
 <alpine.LSU.2.11.2009181317350.11298@eggly.anvils>
 <20200918210126.GA1118730@google.com>
 <alpine.LSU.2.11.2009181406410.11531@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009181406410.11531-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



=D4=DA 2020/9/19 =C9=CF=CE=E75:19, Hugh Dickins =D0=B4=B5=C0:
>>>> 2.28.0.681.g6f77f65b4e-goog
>>> Sorry, Yu, I may be out-of-line in sending this: but as you know,
>>> Alex Shi has a long per-memcg lru_lock series playing in much the
>>> same area (particularly conflicting in mm/swap.c and mm/vmscan.c):
>>> a patchset that makes useful changes, that I'm very keen to help
>>> into mmotm a.s.a.p (but not before I've completed diligence).
>>>
>>> We've put a lot of effort into its testing, I'm currently reviewing
>>> it patch by patch (my general silence indicating that I'm busy on that,
>>> but slow as ever): so I'm a bit discouraged to have its stability
>>> potentially undermined by conflicting cleanups at this stage.
>>>
>>> If there's general agreement that your cleanups are safe and welcome
>>> (Michal's initial reaction sheds some doubt on that), great: I hope
>>> that Andrew can fast-track them into mmotm, then Alex rebase on top
>>> of them, and I then re-test and re-review.
>>>
>>> But if that quick agreement is not forthcoming, may I ask you please
>>> to hold back, and resend based on top of Alex's next posting?
>> The per-memcg lru lock series seems a high priority, and I have
>> absolutely no problem accommodate your request.
> Many thanks!
>=20
>> In return, may I ask you or Alex to review this series after you
>> have finished with per-memcg lru lock (to make sure that I resolve
>> all the conflicts correctly at least)?
> Fair enough: I promise to do so.
>=20
> And your rebasing will necessarily lead you to review some parts
> of Alex's patchset, which will help us all too.
>=20
> Andrew, Yu asked at the start:
>>>> I see you have taken this:
>>>>   mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
>>>> Do you mind dropping it?
> Dropping that for now will help too.

Hi Hugh & Yu,

Thanks for all your considerations! I will looking into this series after t=
hing
on lru_lock finished.

Thanks a lot!
Alex

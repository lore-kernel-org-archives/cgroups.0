From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: folding CONFIG_MEMCG_SWAP as default
Date: Sat, 18 Apr 2020 21:44:32 +0800
Message-ID: <caa13db1-3094-0aae-bfb9-c3534949fa21@linux.alibaba.com>
References: <1587134624-184860-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200417155317.GS26707@dhcp22.suse.cz>
 <CALvZod7Xa4Xs=7zC8OZ7GOfvfDBv+yNbGCzBxeoMgAeRGRtw0A@mail.gmail.com>
 <20200417165442.GT26707@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200417165442.GT26707-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



=D4=DA 2020/4/18 =C9=CF=CE=E712:54, Michal Hocko =D0=B4=B5=C0:
> On Fri 17-04-20 09:41:04, Shakeel Butt wrote:
>> On Fri, Apr 17, 2020 at 9:03 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROf=
E0A@public.gmane.org> wrote:
>>>
>>> On Fri 17-04-20 22:43:43, Alex Shi wrote:
>>>> This patch fold MEMCG_SWAP feature into kernel as default function. Th=
at
>>>> required a short size memcg id for each of page. As Johannes mentioned
>>>>
>>>> "the overhead of tracking is tiny - 512k per G of swap (0.04%).'
>>>>
>>>> So all swapout page could be tracked for its memcg id.
>>>
>>> I am perfectly OK with dropping the CONFIG_MEMCG_SWAP. The code that is
>>> guarded by it is negligible and the resulting code is much easier to
>>> read so no objection on that front. I just do not really see any real
>>> reason to flip the default for cgroup v1. Why do we want/need that?
>>>
>>
>> Yes, the changelog is lacking the motivation of this change. This is
>> proposed by Johannes and I was actually expecting the patch from him.
>> The motivation is to make the things simpler for per-memcg LRU locking
>> and workingset for anon memory (Johannes has described these really
>> well, lemme find the email). If we keep the differentiation between
>> cgroup v1 and v2, then there is actually no point of this cleanup as
>> per-memcg LRU locking and anon workingset still has to handle the
>> !do_swap_account case.
>=20
> All those details really have to go into the changelog. I have to say
> that I still do not understand why the actual accounting swap or not
> makes any difference for per per-memcg LRU. Especially when your patch
> keeps the kernel command line parameter still in place.
>=20
> Anyway, it would be much more simpler to have a patch that drops the
> CONFIG_MEMCG_SWAP and a separate one which switches the default
> beahvior. I am not saying I am ok with the later but if the
> justification is convincing then I might change my mind.
>=20

Hi Shakeel & Michal,

Thanks for all comments!

Yes, we still need to remove swapaccount from cmdline and keep swap_cgroup.=
id
permanently. Just I don't know if this patch could fit into the details of =

Johannes new solution.

Anyway, I will send out v2 for complete memcg id record patch, just in case
if they are useful.

Thanks
Alex

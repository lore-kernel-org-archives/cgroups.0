From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Fri, 10 Jan 2020 10:01:27 +0800
Message-ID: <d2efad94-750b-3298-8859-84bccc6ecf06@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org>
 <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: hannes@cmpxchg.org
Cc: Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com



=D4=DA 2020/1/2 =CF=C2=CE=E76:21, Alex Shi =D0=B4=B5=C0:
>=20
>=20
> =D4=DA 2020/1/1 =C9=CF=CE=E77:05, Andrew Morton =D0=B4=B5=C0:
>> On Wed, 25 Dec 2019 17:04:16 +0800 Alex Shi <alex.shi@linux.alibaba.co=
m> wrote:
>>
>>> This patchset move lru_lock into lruvec, give a lru_lock for each of
>>> lruvec, thus bring a lru_lock for each of memcg per node.
>>
>> I see that there has been plenty of feedback on previous versions, but
>> no acked/reviewed tags as yet.
>>
>> I think I'll take a pass for now, see what the audience feedback looks
>> like ;)
>>
>=20

Hi Johannes,

Any comments of this version? :)

Thanks
Alex

>=20
> Thanks a lot! Andrew.
>=20
> Please drop the 10th patch since it's for debug only and cost performan=
ce drop.
>=20
> Best regards & Happy new year! :)
> Alex
>=20


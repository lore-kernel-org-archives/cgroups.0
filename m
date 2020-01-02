From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Thu, 2 Jan 2020 18:21:47 +0800
Message-ID: <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org



=D4=DA 2020/1/1 =C9=CF=CE=E77:05, Andrew Morton =D0=B4=B5=C0:
> On Wed, 25 Dec 2019 17:04:16 +0800 Alex Shi <alex.shi@linux.alibaba.com> =
wrote:
>=20
>> This patchset move lru_lock into lruvec, give a lru_lock for each of
>> lruvec, thus bring a lru_lock for each of memcg per node.
>=20
> I see that there has been plenty of feedback on previous versions, but
> no acked/reviewed tags as yet.
>=20
> I think I'll take a pass for now, see what the audience feedback looks
> like ;)
>=20


Thanks a lot! Andrew.

Please drop the 10th patch since it's for debug only and cost performance d=
rop.

Best regards & Happy new year! :)
Alex

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Fri, 28 Aug 2020 13:22:28 +0800
Message-ID: <327a1bb4-b64d-65b8-e18f-db33e03ca9ed@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
 <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
 <01ed6e45-3853-dcba-61cb-b429a49a7572@linux.alibaba.com>
 <20200828014022.y5xju6weysqpzxd2@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200828014022.y5xju6weysqpzxd2@ca-dmjordan1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com


=D4=DA 2020/8/28 =C9=CF=CE=E79:40, Daniel Jordan =D0=B4=B5=C0:
> I went back to your v1 post to see what motivated you originally, and you=
 had
> some results from aim9 but nothing about where this reared its head in the
> first place.  How did you discover the bottleneck?  I'm just curious abou=
t how
> lru_lock hurts in practice.

We have gotten very high 'sys' in some buiness/machines. And found much of =
time spent
on the lru_lock and/or zone lock. Seems per memcg lru_lock could help this,=
 but still
no idea on zone lock.

Thanks
Alex

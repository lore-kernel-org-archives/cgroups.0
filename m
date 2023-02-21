From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 15:22:32 +0800
Message-ID: <61CA5FFC-547B-4F56-9238-C9096223BF80@linux.dev>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676964187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cf+LpAhEO5DOwBgtr3qmUSxNMxu2ZN676lArhjLROM4=;
        b=aE81HyfVARJQiFBwWqtpuXcHzHwO+fJlvZRELGjtccNk4x3KKsPKW6F+yelYbWJeMWtd2p
        9iOz5RShcuT6nitSNpVzRU57VrAzHB+c2ty/PlwUJ8ukZKQgkCQ8L0lFWlUgCTMXP0I5Df
        jV0wjaQPQfHo2Qanog3rA0gyyhjSl3k=
In-Reply-To: <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>, Yue Zhao <findns94@gmail.com>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



> On Feb 21, 2023, at 13:17, Roman Gushchin <roman.gushchin@linux.dev> =
wrote:
>=20
>> On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb@google.com> =
wrote:
>>=20
>> =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin =
wrote:
>>>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
>>>> The knob for cgroup v2 memory controller: memory.oom.group
>>>> will be read and written simultaneously by user space
>>>> programs, thus we'd better change memcg->oom_group access
>>>> with atomic operations to avoid concurrency problems.
>>>>=20
>>>> Signed-off-by: Yue Zhao <findns94@gmail.com>
>>>=20
>>> Hi Yue!
>>>=20
>>> I'm curious, have any seen any real issues which your patch is =
solving?
>>> Can you, please, provide a bit more details.
>>>=20
>>=20
>> IMHO such details are not needed. oom_group is being accessed
>> concurrently and one of them can be a write access. At least
>> READ_ONCE/WRITE_ONCE is needed here.
>=20
> Needed for what?
>=20
> I mean it=E2=80=99s obviously not a big deal to put =
READ_ONCE()/WRITE_ONCE() here, but I struggle to imagine a scenario when =
it will make any difference. IMHO it=E2=80=99s easier to justify a =
proper atomic operation here, even if it=E2=80=99s most likely an =
overkill.
>=20
> My question is very simple: the commit log mentions =E2=80=9C=E2=80=A6 =
to avoid concurrency problems=E2=80=9D, so I wonder what problems are =
these.

I think there is no difference in the assembly code between them in most
cases. The only intention that I can think of is to avoid the potential
complaint (data race) emitted by KCSAN.

>=20
> Also there are other similar cgroup interfaces without =
READ_ONCE()/WRITE_ONCE().

If we decide to fix, then we should fix all.

Thanks.

>=20
> Thanks!



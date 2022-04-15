From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 1/4] kselftests: memcg: update the oom group leaf events test
Date: Fri, 15 Apr 2022 08:59:48 -0700
Message-ID: <238226BB-6536-489A-BCC7-4611F86D036D@linux.dev>
References: <20220415140817.ljznpvacne6nchg5@dev0025.ash9.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650038391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQ/j24GLveqMBhfRtNWZjMAkMOjKnLZwyOdqxvR91eI=;
        b=mq1u7phOZ+sAnnnDp1ut5N/Hn+PA19vw5Hl9rcpv4HyniUFuSb1Ip8FJOHuMswzWFy+9ht
        G5wznUQt6OzRY0vmj9yjRRAktUQzidZUihGdWrXAUX1HC67JUtN80CUN3HdqKdjn3iV6M3
        kaYCMNoSWwyJP7mKhn1RmZsaj+BJg6c=
In-Reply-To: <20220415140817.ljznpvacne6nchg5@dev0025.ash9.facebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: David Vernet <void@manifault.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>


> On Apr 15, 2022, at 7:08 AM, David Vernet <void@manifault.com> wrote:
>=20
> =EF=BB=BFOn Thu, Apr 14, 2022 at 05:01:30PM -0700, Roman Gushchin wrote:
>> Commit 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events") mad=
e
>> memory.events recursive: all events are propagated upwards by the
>> tree. It was a change in semantics.
>=20
> In one of our offline discussions you mentioned that we may want to
> consider having the test take mount options into account. If we decide to
> go that route we should probably have this testcase take memory_localevent=
s
> into account as well. If so, I'm happy to take care of that in a follow-on=

> patch after this is merged as I already have a patch locally that reads an=
d
> parses /proc/mounts to detect these mount options.

It would be great, thank you!

>> -    if (cg_read_key_long(parent, "memory.events", "oom_kill ") !=3D 0)
>> +    if (cg_read_key_long(parent, "memory.events", "oom_kill ") <=3D 0)
>>        goto cleanup;
>>=20
>>    ret =3D KSFT_PASS;
>> --=20
>> 2.35.1
>>=20
>=20
> Looks good, thanks.
>=20
> Reviewed-by: David Vernet <void@manifault.com>

Thanks!=

From: Hao Jia <jiahao.os@bytedance.com>
Subject: Re: [External] Re: [PATCH] cgroup: rstat: Simplified
 cgroup_base_stat_flush() update last_bstat logic
Date: Wed, 24 May 2023 14:54:10 +0800
Message-ID: <4d49f7e7-2488-9690-258e-34e617cfef6f@bytedance.com>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
 <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684911260; x=1687503260;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAefNZG4LZt3cqRcnMIDIEa1kLQTnHp5yWi9GEafibo=;
        b=VwbzWvjELIc1qjtZStMTGBOTUduER8iG58DJEbYd/ddVTi2TfixOAtyoDTqt2ldy1G
         rZUgroqQKWoUlSpGOFCuPB0gGBVHAdU7VZaRr5R9xZ4B5pFdsk7GquXQywDcJi4Gb+YC
         Wj+/HMOO86aH7ngxWmsyFbdnO8XVec2hMx8RKzrCbPk1JOCKsxar3EbCpYGFWGRp6Pa5
         sz3ISMMJqpsw/PUsJgttzpXzHeVNDWp0i4fA9HJtJyI14tucKyu57jvOioltpBmizHGY
         ZgAnjHtserzDng6cH5dxyXVgY8I6/vviqHVllEoaC4o9ALiNhroPlnnga0MxW8ZaZqvt
         QqQg==
In-Reply-To: <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 2023/5/23 Michal Koutn=C3=BD wrote:
> Hello Jia.
>=20
> On Fri, May 19, 2023 at 12:15:57PM +0800, Hao Jia <jiahao.os@bytedance.co=
m> wrote:
>> Maybe something like this?
>=20
> (Next time please send with a version bump in subject.)

Thanks for your review, I will do it in the next version.

>=20
>=20
>> In cgroup_base_stat_flush() function, {rstatc, cgrp}->last_bstat
>> needs to be updated to the current {rstatc, cgrp}->bstat after the
>> calculation.
>>
>> For the rstatc->last_bstat case, rstatc->bstat may be updated on other
>> cpus during our calculation, resulting in inconsistent rstatc->bstat
>> statistics for the two reads. So we use the temporary variable @cur to
>> record the read statc->bstat statistics, and use @cur to update
>> rstatc->last_bstat.
>=20
> If a concurrent update happens after sample of bstat was taken for
> calculation, it won't be reflected in the flushed result.
> But subsequent flush will use the updated bstat and the difference from
> last_bstat would account for that concurrent change (and any other
> changes between the flushes).
>=20
> IOW flushing cannot prevent concurrent updates but it will give
> eventually consistent (repeated without more updates) results.
>=20

Yes, so we need @curr to record the bstat value after the sequence fetch=20
is completed.


>> It is better for us to assign directly instead of using
>> cgroup_base_stat_add() to update {rstatc, cgrp}->last_bstat.
>=20
> Or do you mean the copying is faster then arithmetics?
>=20

Yes, but it may not be obvious.
Another reason is that when we complete an update, we snapshot=20
last_bstat as the current bstat, which is better for readers to=20
understand. Arithmetics is somewhat obscure.

Thanks,
Hao

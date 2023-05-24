From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup: rstat: Simplified
 cgroup_base_stat_flush() update last_bstat logic
Date: Wed, 24 May 2023 16:41:08 +0800
Message-ID: <8e65aa62-c92c-857d-3e27-8ccddf51b07f@bytedance.com>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
 <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
 <4d49f7e7-2488-9690-258e-34e617cfef6f@bytedance.com>
 <remnwctqmxleig7ywt6puhxnpmzjo7xm6hlfhpnul46ulfnw7j@36sbuxhuatto>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684917680; x=1687509680;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTHbB0gony/TYMogUW6Qo/V1GtsaSfduo/QCXMjaxUM=;
        b=ZnX7arnhJ7Q+Ipi910Jn2NK7QtDaPy4TlGLSCmXMrFgaUyqr1HH/K1c8b6/vd5Uy7O
         jNoxiqXlVyu7dS8JQ6XZcHcyTIWBo5LiGPQ2ieUIGyL0YZetHQ2aHFnCghlX8XgkIv+F
         f5EuBJnyV4VDQSb9NGCcJtePUs1XekOOsQ7ZeebwLbsoZ8oXPbGQ8lEuVgI+YY4ZT/0S
         A5DUGll7sRLEHXSOQqu1Q8FZI26Y3oe3l2415CbQ8TxjnBND2kMPXNEJYohRbUKP5kVZ
         woD/ctZI3vJHoAqhsIdLRO+9uYd6q4ASQGv3xtle4N7GIVzykLdRozpCCKQxXXlzaFno
         K06w==
In-Reply-To: <remnwctqmxleig7ywt6puhxnpmzjo7xm6hlfhpnul46ulfnw7j@36sbuxhuatto>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/5/24 Michal Koutn=C3=BD wrote:
> On Wed, May 24, 2023 at 02:54:10PM +0800, Hao Jia <jiahao.os-EC8Uxl6Npydl=
57MIdRCFDg@public.gmane.org> wrote:
>> Yes, so we need @curr to record the bstat value after the sequence fetch=
 is
>> completed.
>=20
> No, I still don't see a problem that it solves. If you find incorrect
> data being reported, please explain it more/with an example.

Sorry to confuse you.

My earliest patch is like this:

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 9c4c55228567..3e5c4c1c92c6 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -376,14 +376,14 @@ static void cgroup_base_stat_flush(struct cgroup=20
*cgrp, int cpu)
     /* propagate percpu delta to global */
     cgroup_base_stat_sub(&delta, &rstatc->last_bstat);  (1) <---
     cgroup_base_stat_add(&cgrp->bstat, &delta);
- cgroup_base_stat_add(&rstatc->last_bstat, &delta);
+ rstatc->last_bstat =3D rstatc->bstat; 			(2) <--

     /* propagate global delta to parent (unless that's root) */
     if (cgroup_parent(parent)) {
        delta =3D cgrp->bstat;
        cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
        cgroup_base_stat_add(&parent->bstat, &delta);
- cgroup_base_stat_add(&cgrp->last_bstat, &delta);
+ cgrp->last_bstat =3D cgrp->bstat;
     }
   }

If I understand correctly, the rstatc->bstat at (1) and (2) may be=20
different. At (2) rstatc->bstat may have been updated on other CPUs.
Or we should not read rstatc->bstat directly, we should pass the=20
following way

     do {
        seq =3D __u64_stats_fetch_begin(&rstatc->bsync);
        cur =3D rstatc->bstat;
     } while (__u64_stats_fetch_retry(&rstatc->bsync, seq));


>=20
>> Yes, but it may not be obvious.
>> Another reason is that when we complete an update, we snapshot last_bsta=
t as
>> the current bstat, which is better for readers to understand. Arithmetic=
s is
>> somewhat obscure.
>=20
> The readability here is subjective. It'd be interesting to have some
> data comparing arithmetics vs copying though.

Thanks for your suggestion, I plan to use RDTSC to compare the time=20
consumption of arithmetics vs copying. Do you have better suggestions or=20
tools?

Thanks,
Hao

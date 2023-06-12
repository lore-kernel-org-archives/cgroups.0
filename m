From: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup: rstat: Simplified
 cgroup_base_stat_flush() update last_bstat logic
Date: Mon, 12 Jun 2023 11:13:41 +0800
Message-ID: <d6d19a61-a584-1839-e6cc-ea63479ca800@bytedance.com>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
 <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
 <4d49f7e7-2488-9690-258e-34e617cfef6f@bytedance.com>
 <remnwctqmxleig7ywt6puhxnpmzjo7xm6hlfhpnul46ulfnw7j@36sbuxhuatto>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686539625; x=1689131625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isvk/E9G1J5c+bipF9hN5zG+Nag5iOn+AJ5rYPC8Si8=;
        b=azPuT2b/FtHoAE095FDR2kcjtJf9/JJ1kwqBOO/u2aEEI3Upa/kUJnA5vvloGhQG7r
         Iq+fbnSJBqkhGGYeCBgoOWvSIujRe8NiJ3FYP1EHlVv7vrfk6oxNh8ZHXDfYsBuKotAy
         +5+Cpmfhr7aM9znnX2mKAAj3dqHQUyVUhQZN1OLISWBXX9O8eJHZ7BIZAYE5CXkzSFC6
         sZvc2fzdRRDexf2en3ztWWHCPpXkv4oj5GFlhfIkzBO3Xp/0g8psQ5l1YC4ye66gAwfH
         ghNd3rtQE07xppYBOMZIBJDrr4kp5uJ8mKIhAXPrM2LZE4peyAM6++6FZZ1os15mN2Ie
         Yedw==
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
>=20

Sorry for replying you so late. I am using RDTSC on my machine (an Intel=20
Xeon(R) Platinum 8260 CPU@2.40GHz machine with 2 NUMA nodes each of=20
which has 24 cores with SMT2 enabled, so 96 CPUs in total.) to compare=20
the time consumption of arithmetics vs copying. There is almost no=20
difference in the time consumption between arithmetics and copying.



> HTH,
> Michal

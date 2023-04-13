From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 14:33:15 -1000
Message-ID: <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681345997; x=1683937997;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qeVTMtCux2BOeObz5+AKrGQQdxp1bdVbjpePeClNJpo=;
        b=k3ksXRI5boYH1PJ4aL51Taqw6hvtAg0KYVtZ5LSutd4bs+Ama7qpxAoSze4A7L0gpl
         omUHyPRglIG6cycY06ZvINus+/9GsBNP02RktCm3rfaO9kZcr+52IgMeegbeUlkP6Ol4
         GnazoLBbvVbzAzWqgpBN14eYhnsrg7iPxKjt972IuYhn1qhpJuaINoJQTyp5UolqC3Qb
         60fnP8jse8Wk56KwrYncNxP9bcPeNiolIjfeD2lH5R8FbbY8XfaJxoGRREv/tqGaTITD
         B5HenCw6mN5oXFjVd5BO0bvN9qPsuUcLTfEZmg9nlwkiEdsQg7Qa5l55m36Z+aDmNu5C
         705g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello,

On Wed, Apr 12, 2023 at 08:26:03PM -0400, Waiman Long wrote:
> =A0 If the "cpuset.cpus.isolated" isn't set, the existing rules applies. =
If it
> is set, the new rule will be used.
>=20
> Does that look reasonable to you?

Sounds a bit contrived. Does it need to be something defined in the root
cgroup? The only thing that's needed is that a cgroup needs to claim CPUs
exclusively without using them, right? Let's say we add a new interface
file, say, cpuset.cpus.reserve which is always exclusive and can be consumed
by children whichever way they want, wouldn't that be sufficient? Then,
there would be nothing to describe in the root cgroup.

Thanks.

--=20
tejun

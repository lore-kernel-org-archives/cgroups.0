From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Wed, 25 Aug 2021 14:50:38 +0800
Message-ID: <75e53c51-396d-cce2-65ed-70fb60e226bd@gmail.com>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
 <20210824164423.GA11859@blackbody.suse.cz> <YSVDwc/1sEmXdOK9@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d+uKINOa87NY5sQC8KbNNxmjG4mjEIMotNpUXzjMBt8=;
        b=F2is7s0JDyYCs9D1dcOtqeVs29jPzSaMZ7VSaYeDx5jx0LCpMSW3ONANNVlYIxWg75
         83Uhx+ODUBgYV7AY17ST/XnTZZbXr92paojRXtqS93k57uaoLa78WjBBkf4729YzyAUd
         oCHDcNbSB5dOk3UUKILqu3yZb+99afLnUSBfhTBqoHigK+7zHgJOwCT9fzUo6Y1nWXJa
         rT5jcQBDU24SzDWLidC5lAxH2P4zaUic77sZcI2+PuTsx0hyA+xlJWIyd94V0gIyg7UJ
         Z1WPs7QmwFQ4/PDbOxmKKhA7RX2Cg4rS4JCwrGVLtCTqzM3p06vn0aK8Jlzl5EQNxZ5W
         BlBA==
In-Reply-To: <YSVDwc/1sEmXdOK9-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Tejun Heo wrote on 2021/8/25 3:08:
> Hello,
>=20
> On Tue, Aug 24, 2021 at 06:44:23PM +0200, Michal Koutn=C3=BD wrote:
>> However, the non-hierarchical failcnt interface looks like v1ism to me
>> (I think new features should come with v2 first in mind).
>> What about exposing this in misc.events file with max.$res_name entries?=
=20
>=20
> Ah yeah, good point. misc.events sounds like a good spot to put these.
>=20
>> Or if the hierarchical reporting is unnecessary now, there can be just
>> misc.events.local for starters.
>=20
> I'd prefer to stick with hierarchical counting as the first step at least.
>=20
>> (That reminds me the forgotten pids.events[.local] rework [1], oops.)
>>
>> https://lore.kernel.org/lkml/20191128172612.10259-1-mkoutny-IBi9RG/b67k@=
public.gmane.org/#t
>=20
> I think both counters are useful - the number of failures due to this type
> of limit in this subhierarchy, and the number of failures caused by this
> particular limit in this subhierarchy. It's a pretty subtle difference to
> encapsulate in a counter name tho.

Thanks all for good suggestion, I try to do it in next version.=20

> Thanks.
>=20

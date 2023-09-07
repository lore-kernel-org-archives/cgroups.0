From: Luiz Capitulino <luizcap@amazon.com>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Thu, 7 Sep 2023 14:57:33 -0400
Message-ID: <542553d6-5e52-5d2a-66db-9c3b409de01b@amazon.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <lqcl5cblo3s45afvtgqjkbz2an3zwccsckglhpe3ufyffqavjk@ui45m6itz4ne>
 <236f84be-26b0-758d-3d3f-380e536f72c2@amazon.com>
 <zqgnootbsjyj7wq5ayiallz4m2bz7ad6w67t24peglhc5v6ern@4pfqlshgpnie>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1694113068; x=1725649068;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=hArgUTfo4A9QwEbpAp+HoDaLEQZ6wVWaKg9DCKFFPXs=;
  b=q4eBNGu1zff93Bn8n/joKncrj+0PbN9h7DSwb2I20qlzwj48dK8w8wS4
   sYx7gZGLA/Wy63LaK2uMvsRnwtGXEte40a+yhVg06oOIrrELWtCKSK7KN
   LShaUNkUBTeEaJIMBJZbBx6etiApJVgJ2edmvRv5+TbZxQzxCTuvWB1eo
   0=;
Content-Language: en-US
In-Reply-To: <zqgnootbsjyj7wq5ayiallz4m2bz7ad6w67t24peglhc5v6ern@4pfqlshgpnie>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, longman@redhat.com, lcapitulino@gmail.com

[Resending, looks like I'm having issues with my mail server]

On 2023-09-07 11:57, Michal Koutn=C3=BD wrote:
> On Thu, Sep 07, 2023 at 11:16:41AM -0400, Luiz Capitulino <luizcap@amazon=
.com> wrote:
>> Yeah, this works for cgroup v2 but my understanding is that cgroup v1
>> doesn't support changing flags in remount, take a look at
>> cgroup1_reconfigure().
>=20
> Ah, didn't notice.
> Alhtough -- there seems to be a deeper issue -- the mount option doesn't
> have a per-root semantics. There is only a single
> cgroup_threadgroup_rwsem afterall.
>=20
> Even with your cmdline option, you may loose the behavior after
> unmounting any of the v1 hierarchies (cgroup_destroy_root()
> unconditionally disables it).

Good point. I haven't checked this in detail yet, but if
CONFIG_CGROUP_FAVOR_DYNMODS has the same behavior then I wouldn't worry
much about this. Also, I don't know how common it is to unmount and
mount a cgroup hierarchies (if it's not so common then it's even
less important).

We could also investigate on how to make the flag stick as a follow
up work on this.

>=20
> Or you could still achieve the result by mounting cgroup2 hierarchy with
> favordynmods. (And unmount it, default root is not ever released.)
>=20
> Maybe it would be the best to have this controllable only via v2
> hierarchy (as it's the only documented).
> (And maybe v1s should not show the option at all.)

The main motivation for this patch is really v1 since we can
simply remount v2 with favordynmods enabled (although we do
find this very useful for v2 as well).

Another crazy idea (based on your suggestion to allow only this
controllable in v2), would be to make favordynmods enabled by
default in v1 w/ the rationale that new behavior changes affect
only v2.

- Luiz

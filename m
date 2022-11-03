From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Thu, 3 Nov 2022 10:13:22 +0800
Message-ID: <25f6a188-4cc6-dace-1468-fd5645711515@shopee.com>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
 <20221027080558.GA23269@blackbody.suse.cz>
 <adb7418c-39a2-6202-970a-a039ad8201dd@shopee.com>
 <20221031131140.GC27841@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMzrvYyYy/W+4cGhBZeoRUR17rUZ1JZqGeV1907ajb4=;
        b=POmg/14cGPQ2xtPMaiDVwNaxOFfwYJ9iR4Zycxg3geAV9EKyOz0uySgFDDvmaKTUZi
         alFKmuXoeHA1Xjf3nZ8ZTFhTKuwtUpI0Tcd+uu8g8qKOqz6dZO3k0ewtWNsbJwLT5PJ5
         370knaA+E40T7Z0QQYhOPZRpZJWH9vBpz59pW0NxDgxiqCQeFGPGGxcacctuBI0/vaYx
         wD+/+thF2Cko0M7CE6Tgv0oy6f54p6hVyvF24DOOMmbt4bpw/s+gVc7a0ELFUKyAGONu
         JtM7NGmWmBZQ/8zJHs0JB2AJAN8PkH8DXimsaHM+0wxggkJi7WlFDE0Bmz1iNE0oB7N1
         J8Ug==
In-Reply-To: <20221031131140.GC27841-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/10/31 21:11, Michal Koutn=C3=BD wrote:
> Hello.
>=20
>> 1) If calls 'css_set_update_populated' , the cset is either getting the
>> first task or losing the last. There is a need to update the populated
>> state of the cset only when 'css_set_populated' returns false.
>> In other words, the last has been deleted from from_cset and the first
>> hasn't been added to to_cset yet.
>=20
> I've likely misread the condition previously. I see how this works now
> (update happens after "from_cset" but before "to_cset" migration).
>=20
>> 3) In order to update the populated state of to_cset the same way
>> from_cset does, 'css_set_update_populated' is also invoked during the
>> process of moving a task to to_cset.
>=20
> As I think more about this in the context of vertical migrations
> (ancestor<->descendant, such as during controller dis- or enablement),
> I'm afraid the inverted order would lead to "spurious" emptiness
> notifications in ancestors (in the case a there is just a single task
> that migrates parent->child, parent/cgroup.populated would generate and
> event that'd be nullified by the subsequent population of the child).
Hi, Michal.

I understand your worries. Can I just check the populated state of
css_set in 'css_set_update_populated' and don't change the order any
more? I think it can also streamline 'css_set_move_task' a bit.

Thanks,
Hiafeng.
>=20
> So I'm not sure the change is worth it.
>=20
> Michal

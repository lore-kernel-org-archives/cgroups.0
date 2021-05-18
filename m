From: =?iso-2022-jp?B?Tk9NVVJBIEpVTklDSEkoGyRCTG5CPCEhPV8wbBsoQik=?= 
        <junichi.nomura-YMj9X0ASwKA@public.gmane.org>
Subject: Re: ##freemail## Re: [PATCH] cgroup: disable controllers at parse
 time
Date: Tue, 18 May 2021 23:28:19 +0000
Message-ID: <dee7912f-c797-963c-909e-4f7681433a32@nec.com>
References: <20210512201946.2949351-1-shakeelb@google.com>
 <CALvZod5a_W8P0v7xg0jdh-TLvy4OUYaQkyjBx-1RSTUBo+YQmg@mail.gmail.com>
 <CAHbLzkqziUEUz-4nxBs4H5z4pZS3y+ceKciKYt8KVN34Gw8egw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jca7gpM5jq61hUaPufeRsEZ30MHS3g63z6H/2NEarpI=;
 b=iHc9JRC4pc+QOu62rDIvOsnKoM7/vZuqtEaBCLCwUxvH4yRMxuz6dwMxgiv+Kfq/CeEoEnXPvUhd5PA8l2goXZy/KIn+EyHQt27tefk2DTlQi/wLSTwinEaccZoeVjKw+XVRrDLaMgcycNwO+9rLJYJW9m2ym9fj9a5SPDR+IsQ=
In-Reply-To: <CAHbLzkqziUEUz-4nxBs4H5z4pZS3y+ceKciKYt8KVN34Gw8egw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <7D92BB4160A89548BD440755338749B1-6/qVZsYcVcicE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: =?iso-2022-jp?B?Tk9NVVJBIEpVTklDSEkoGyRCTG5CPCEhPV8wbBsoQik=?= <junichi.nomura-YMj9X0ASwKA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2021/05/19 4:54, Yang Shi wrote:
> On Tue, May 18, 2021 at 11:13 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
>>
>> On Wed, May 12, 2021 at 1:19 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
>>>
>>> This patch effectively reverts the commit a3e72739b7a7 ("cgroup: fix
>>> too early usage of static_branch_disable()"). The commit 6041186a3258
>>> ("init: initialize jump labels before command line option parsing") has
>>> moved the jump_label_init() before parse_args() which has made the
>>> commit a3e72739b7a7 unnecessary. On the other hand there are
>>> consequences of disabling the controllers later as there are subsystems
>>> doing the controller checks for different decisions. One such incident
>>> is reported [1] regarding the memory controller and its impact on memor=
y
>>> reclaim code.
>>>
>>> [1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371=
e4-YMj9X0ASwKA@public.gmane.org
>>>
>>> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Reported-by: NOMURA JUNICHI(=1B$BLnB<!!=3D_0l=1B(B) <junichi.nomura@nec=
.com>
>>
>> Nomura, I think you have already tested this patch, so, can you please
>> add your tested-by tag?

Sure, I have confirmed the problem still occurs with v5.13-rc2 and it
disappeared with your patch.

So,
Tested-by: Jun'ichi Nomura <junichi.nomura-YMj9X0ASwKA@public.gmane.org>

--=20
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.=

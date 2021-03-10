From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 12:21:38 +0300
Message-ID: <32fab450-c62b-4f71-4d8e-4e956bc37cdd@virtuozzo.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
 <YEfYFIlRH0+0XWwT@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/fNXpTuxABcaNN8chdZ8GWl7T6M35RohMwWnBTGqKk=;
 b=Cfmny1WRBpD8/ahSv2CkA86TuXy+cNk728//sUzoC1FcHzCfHiI41QKry+9xnVRuGxV81S4+w5CmFgsKAlUR/kccxcfRshHCVZLxFJ5pdOe+8YRcinSPZ0TWriBZizGTRIrxoKjNfb8HlfKIBQ2O6fzo5+pTxk2Y4uEMCMEc+Eg=
In-Reply-To: <YEfYFIlRH0+0XWwT-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/9/21 11:18 PM, Roman Gushchin wrote:
> On Tue, Mar 09, 2021 at 11:39:41AM -0800, Shakeel Butt wrote:
>> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>>
>>> in_interrupt() check in memcg_kmem_bypass() is incorrect because
>>> it does not allow to account memory allocation called from task context
>>> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
>>>
>>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>>
>> In that file in_interrupt() is used at other places too. Should we
>> change those too?
> 
> Yes, it seems so. Let me prepare a fix (it seems like most of them were
> introduced by me).

No objects from my side, just keep me informed and add me in "Reported-by:" in your patches. 

Thank you,
	Vasily Averin

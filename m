From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/10] memcg: Add CONFIG_CGROUP_MEM_RES_CTLR_KMEM_ACCT_ROOT.
Date: Wed, 29 Feb 2012 11:24:05 -0800
Message-ID: <CABCjUKBFFKap9SfCWDO6ZsA5o+b0152sNhGhckpYG2-f0LaMUw@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-9-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD7E7.1070901@parallels.com>
	<CABCjUKAUQZuW9hFeMJ1Oh=0UeS2Ffx4-vHpnaGpjOFu+3KktAA@mail.gmail.com>
	<4F4E5BC5.9010408@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=TIECSannH86SR8QeluwAsqQqqaxrztLtKeaIqp+xeuM=;
        b=DP5SFCDf1yccMSwLSzwlDnHWreffLMHCidOHPwCw07oRD9uj06WE0BXatz2KOantOk
         7UoP+lO2RMhwPRqWhqsOoLw9G2ndti+MaHMaidhv4zPhrw9YIakFOBj6L0grINt6hzvv
         fmUAOO9J1AGOgxYvNYaf+b83Tq+BhGJhaIxcIaTj8HM1LRx20WrkK6ZkS/IT+ol3XG3T
         FBVj2gSyENFqKNKXsNqw5etS46rj2QDA+vt0dkEh+lXlYWGdNjxWv56cruZEHDInl64D
         ErUGw1meB74SSIxzSXXX1hGgu2egO5k91lvWg7dw4702CMEFSly/eUxihuks6sC77hD7
         t29w==
In-Reply-To: <4F4E5BC5.9010408-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, Feb 29, 2012 at 9:09 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 02/28/2012 08:36 PM, Suleiman Souhlal wrote:
>>
>> On Tue, Feb 28, 2012 at 5:34 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org=
>
>> =A0wrote:
>>>
>>> On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
>>>>
>>>>
>>>> This config option dictates whether or not kernel memory in the
>>>> root cgroup should be accounted.
>>>>
>>>> This may be useful in an environment where everything is supposed =
to be
>>>> in a cgroup and accounted for. Large amounts of kernel memory in t=
he
>>>> root cgroup would indicate problems with memory isolation or accou=
nting.
>>>
>>>
>>>
>>> I don't like accounting this stuff to the root memory cgroup. This =
causes
>>> overhead for everybody, including people who couldn't care less abo=
ut
>>> memcg.
>>>
>>> If it were up to me, we would simply not account it, and end of sto=
ry.
>>>
>>> However, if this is terribly important for you, I think you need to=
 at
>>> least make it possible to enable it at runtime, and default it to
>>> disabled.
>>
>>
>> Yes, that is why I made it a config option. If the config option is
>> disabled, that memory does not get accounted at all.
>
>
> Doesn't work. In reality, most of the distributions enable those stuf=
f if
> there is the possibility that someone will end up using. So everybody=
 gets
> to pay the penalty.
>
>
>> Making it configurable at runtime is not ideal, because we would
>> prefer slab memory that was allocated before cgroups are created to
>> still be counted toward root.
>>
>
> Again: Why is that you really need it ? Accounting slab to the root c=
group
> feels quite weird to me

Because, for us, having large amounts of unaccounted memory is a
"bug", and we would like to know when it happens.
Also, we want to know how much memory is actually available in the
machine for jobs (sum of(accounted memory in containers) - unaccounted
kernel memory).

That said, I will drop this patch from the series for now.

-- Suleiman

From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Questions about replacing isolcpus by cgroup-v2
Date: Fri, 12 Nov 2021 16:46:08 +0100
Message-ID: <2587fcb7-6c3f-e44c-ba4b-20e7327337e3@siemens.com>
References: <AM9PR10MB48692A964E3106D11AC0FDEE898D9@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211112153656.qkwyvdmb42ze25iw@linutronix.de>
 <AM9PR10MB4869F9A2D7F5F95C29B5521889959@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM9PR10MB4869F9A2D7F5F95C29B5521889959-M49tMopaQCDO+/9PLUklKbUAtUbAAahqZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Moessbauer, Felix (T RDA IOT SES-DE)" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Schild, Henning (T RDA IOT SES-DE)" <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Schmidt, Adriaan (T RDA IOT SES-DE)" <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 12.11.21 16:45, Moessbauer, Felix (T RDA IOT SES-DE) wrote:
> Hi Sebastian,
> 
>> -----Original Message-----
>> From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Sent: Friday, November 12, 2021 4:37 PM
>> To: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>;
>> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Schild, Henning (T RDA IOT SES-DE)
>> <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Kiszka, Jan (T RDA IOT)
>> <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Schmidt, Adriaan (T RDA IOT SES-DE)
>> <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Subject: Re: Questions about replacing isolcpus by cgroup-v2
>>
>> On 2021-11-04 17:29:08 [+0000], Moessbauer, Felix wrote:
>>> Dear subscribers,
>> Hi,
>>
>> I Cced cgroups@vger since thus question fits there better.
>> I Cced Frederic in case he has come clues regarding isolcpus and cgroups.
> 
> Indeed. Thanks!
> 
>>
>>> we are currently evaluating how to rework realtime tuning to use cgroup-v2
>> cpusets instead of the isolcpus kernel parameter.
>>> Our use-case are realtime applications with rt and non-rt threads. Hereby, the
>> non-rt thread might create additional non-rt threads:
>>>
>>> Example (RT CPU=1, 4 CPUs):
>>> - Non-RT Thread (A) with default affinity 0xD (1101b)
>>> - RT Thread (B) with Affinity 0x2 (0010b, via set_affinity)
>>>
>>> When using pure isolcpus and cgroup-v1, just setting isolcpus=1 perfectly
>> works:
>>> Thread A gets affinity 0xD, Thread B gets 0x2 and additional threads get a
>> default affinity of 0xD.
>>> By that, independent of the threads' priorities, we can ensure that nothing is
>> scheduled on our RT cpu (except from kernel threads, etc...).
>>>
>>> During this journey, we discovered the following:
>>>
>>> Using cgroup-v2 cpusets and isolcpus together seems to be incompatible:
>>> When activating the cpuset controller on a cgroup (for the first time), all
>> default CPU affinities are reset.
>>> By that, also the default affinity is set to 0xFFFF..., while with isolcpus we
>> expect it to be (0xFFFF - isolcpus).
>>> This breaks the example from above, as now the non-RT thread can also be
>> scheduled on the RT CPU.
>>>
>>> When only using cgroup-v2, we can isolate our RT process by placing it in a
>> cgroup with CPUs=0,1 and remove CPU=1 from all other cgroups.
>>> However, we do not know of a strategy to set a default affinity:
>>> Given the example above, we have no way to ensure that newly created
>> threads are born with an affinity of just 0x2 (without changing the application).
>>>
>>> Finally, isolcpus itself is deprecated since kernel 5.4.
>>
>> Where is this the deprecation of isolcpus announced/ written?
> 
> https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
> isolcpus=       [KNL,SMP,ISOL] Isolate a given set of CPUs from disturbance.
>                         [Deprecated - use cpusets instead]
>                         Format: [flag-list,]<cpu-list>
> 

That was Frederic himself via b0d40d2b22fe - but already for 4.15...

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux

From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking
 dependency
Date: Mon, 27 Apr 2020 21:39:44 -0400
Message-ID: <dbbfe685-7374-9a96-b7c2-684142746e30@redhat.com>
References: <20200427235621.7823-5-longman@redhat.com>
 <55509F31-A503-4148-B209-B4D062AD0ED7@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588037995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWt0oKx+pB01zuowl3HYopTA8sOUDIn9j7BD+UlNWuQ=;
        b=Ouxne/IIEAnH0KL7fRqf8jqXc+MyoCV+MG/DFOHJ2JUOiZWOuIpHSckKTXcIFMkQAxrB7G
        58ELjB7iHbLsKus6uw70DYwyKKInSklS92JQ/pOnZKSYmGcT+mpp5ETiS+GfH5pZN24O8Y
        1qHmFOMifiyQz0FKGI+wCgOVSAFj2ss=
In-Reply-To: <55509F31-A503-4148-B209-B4D062AD0ED7@lca.pw>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Qian Cai <cai@lca.pw>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

On 4/27/20 8:13 PM, Qian Cai wrote:
>
>> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman@redhat.com> wrote:
>>
>> A lockdep splat is observed by echoing "1" to the shrink sysfs file
>> and then shutting down the system:
>>
>> [  167.473392] Chain exists of:
>> [  167.473392]   kn->count#279 --> mem_hotplug_lock.rw_sem --> slab_mu=
tex
>> [  167.473392]
>> [  167.484323]  Possible unsafe locking scenario:
>> [  167.484323]
>> [  167.490273]        CPU0                    CPU1
>> [  167.494825]        ----                    ----
>> [  167.499376]   lock(slab_mutex);
>> [  167.502530]                                lock(mem_hotplug_lock.rw=
_sem);
>> [  167.509356]                                lock(slab_mutex);
>> [  167.515044]   lock(kn->count#279);
>> [  167.518462]
>> [  167.518462]  *** DEADLOCK ***
>>
>> It is because of the get_online_cpus() and get_online_mems() calls in
>> kmem_cache_shrink() invoked via the shrink sysfs file. To fix that, we
>> have to use trylock to get the memory and cpu hotplug read locks. Sinc=
e
>> hotplug events are rare, it should be fine to refuse a kmem caches
>> shrink operation when some hotplug events are in progress.
> I don=E2=80=99t understand how trylock could prevent a splat. The funda=
mental issue is that in sysfs slab store case, the locking order (once tr=
ylock succeed) is,
>
> kn->count =E2=80=94> cpu/memory_hotplug
>
> But we have the existing reverse chain everywhere.
>
> cpu/memory_hotplug =E2=80=94> slab_mutex =E2=80=94> kn->count
>
The sequence that was prevented by this patch is "kn->count -->=20
mem_hotplug_lock.rwsem". This sequence isn't directly in the splat. Once=20
this link is broken, the 3-lock circular loop cannot be formed. Maybe I=20
should modify the commit log to make this point more clear.

Cheers,
Longman



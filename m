From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking
 dependency
Date: Tue, 28 Apr 2020 10:06:49 -0400
Message-ID: <56327de0-fa44-d5f3-2409-69cf2b97a209@redhat.com>
References: <dbbfe685-7374-9a96-b7c2-684142746e30@redhat.com>
 <28BB8A1C-CFDF-4F5A-8686-537C3CE04818@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588082821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EalMZto1mc2jYDESRAloX1UBpj60CFWLwUGGzQdq+d4=;
        b=Cqvf7PgM9Sx0kBAqxrqGZhwTJph1/KXXlayRiBpQgh6js4qLELNRtIjH78cZ/WrZ6ZBtJZ
        HyLpg2ej849lQt56znB/C0L47dTeQNsdKXd0jYuIjMUs66gppmzJ6RlE68aykknhb3zjr9
        GJT6myKMqYeUG/dcuSD426lUTctjxrQ=
In-Reply-To: <28BB8A1C-CFDF-4F5A-8686-537C3CE04818@lca.pw>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Qian Cai <cai@lca.pw>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

On 4/27/20 10:11 PM, Qian Cai wrote:
>
>> On Apr 27, 2020, at 9:39 PM, Waiman Long <longman@redhat.com> wrote:
>>
>> The sequence that was prevented by this patch is "kn->count --> mem_ho=
tplug_lock.rwsem". This sequence isn't directly in the splat. Once this l=
ink is broken, the 3-lock circular loop cannot be formed. Maybe I should =
modify the commit log to make this point more clear.
> I don=E2=80=99t know what you are talking about. Once trylock succeed o=
nce, you will have kn->count =E2=80=94> cpu/memory_hotplug_lock.
>
Trylock is handled differently from lockdep's perspective as trylock can=20
failed. When trylock succeeds, the critical section is executed. As long=20
as it doesn't try to acquire another lock in the circular chain, the=20
execution will finish at some point and release the lock. On the other=20
hand, if another task has already held all those locks, the trylock will=20
fail and held locks should be released. Again, no deadlock will happen.

Regards,
Longman


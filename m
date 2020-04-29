From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking
 dependency
Date: Tue, 28 Apr 2020 22:52:48 -0400
Message-ID: <0310F66F-0ECB-43BF-B86F-3BDB74F51B06@lca.pw>
References: <dbbfe685-7374-9a96-b7c2-684142746e30@redhat.com>
 <28BB8A1C-CFDF-4F5A-8686-537C3CE04818@lca.pw>
 <56327de0-fa44-d5f3-2409-69cf2b97a209@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZuYhQOwVqj5I2l0C3mwcWWBRC4vXsL2shmKKYh/lrQg=;
        b=aCmH7CwlwPl/0ya/suzFuA1fMGqaCRqlG1An9hZRxqlWrWA87i8lAzj19h17I7fVNY
         SkAcbxzKv2yVzNDU26bW9XPSlaGn08IkxBernQCD5ymMMy10wMAO4iA5SlJgrV6/rHaR
         UR10WckaYKHTF8QxLVBLYtLz+jd+e24vryNXvlfdrfdWXTi/pS4/yFmx45AuBPT1atFY
         e3xpNkyL5b2gkq9kVYEGW7ICo5ondTQiiXBy7zypoc2So3d00g3auY/sQKGU43yMdxoG
         ehNkl1Lxa29e4IJt1e3V3D0XETFGEopBpDd1nTLMoOy1Y1xIImQCuF2KMJqnHHy7H+M9
         uy/g==
In-Reply-To: <56327de0-fa44-d5f3-2409-69cf2b97a209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>



> On Apr 28, 2020, at 10:06 AM, Waiman Long <longman@redhat.com> wrote:
>=20
> On 4/27/20 10:11 PM, Qian Cai wrote:
>>=20
>>> On Apr 27, 2020, at 9:39 PM, Waiman Long <longman@redhat.com> wrote:
>>>=20
>>> The sequence that was prevented by this patch is "kn->count --> =
mem_hotplug_lock.rwsem". This sequence isn't directly in the splat. Once =
this link is broken, the 3-lock circular loop cannot be formed. Maybe I =
should modify the commit log to make this point more clear.
>> I don=E2=80=99t know what you are talking about. Once trylock succeed =
once, you will have kn->count =E2=80=94> cpu/memory_hotplug_lock.
>>=20
> Trylock is handled differently from lockdep's perspective as trylock =
can failed. When trylock succeeds, the critical section is executed. As =
long as it doesn't try to acquire another lock in the circular chain, =
the execution will finish at some point and release the lock. On the =
other hand, if another task has already held all those locks, the =
trylock will fail and held locks should be released. Again, no deadlock =
will happen.

So once,

CPU0 (trylock succeed):
kn->count =E2=80=94> cpu/memory_hotplug_lock.

Did you mean that lockdep will not record this existing chain?

If it did. Then later, are you still sure that CPU1 (via memcg path =
below) will still be impossible to trigger a splat just because lockdep =
will be able to tell that those arennon-exclusive =
(cpu/memory_hotplug_lock) locks instead?

 cpu/memory_hotplug_lock -> kn->count

[  290.805818] -> #3 (kn->count#86){++++}-{0:0}:
[  290.811954]        __kernfs_remove+0x455/0x4c0
[  290.816428]        kernfs_remove+0x23/0x40
[  290.820554]        sysfs_remove_dir+0x74/0x80
[  290.824947]        kobject_del+0x57/0xa0
[  290.828905]        sysfs_slab_unlink+0x1c/0x20
[  290.833377]        shutdown_cache+0x15d/0x1c0
[  290.837964]        kmemcg_cache_shutdown_fn+0xe/0x20
[  290.842963]        kmemcg_workfn+0x35/0x50   <=E2=80=94=E2=80=94 =
cpu/memory_hotplug_lock
[  290.847095]        process_one_work+0x57e/0xb90
[  290.851658]        worker_thread+0x63/0x5b0
[  290.855872]        kthread+0x1f7/0x220
[  290.859653]        ret_from_fork+0x27/0x50=

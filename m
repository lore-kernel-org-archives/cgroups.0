From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking dependency
Date: Sat, 16 May 2020 21:57:58 -0400
Message-ID: <3D1CF487-DD7E-4C5F-B977-D161CCED5234@lca.pw>
References: <20200427235621.7823-5-longman@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=s3yeuZAhDmFpBOUorb/iouNYdnDc9CDj+UxZLN9lvxg=;
        b=nkDo28rEL9kgR2hMhdY3aEgW0FJDqa7d8Al3/yHezV2tdkx30CmhQBcLfiTqOPrgjm
         ARxWaM3min6L9oyJv9TR/E2FlcMiEFBvPZi+GOOGp8QQxTSAD1A/0d1nDMyJMiJEBFlt
         cTisUARGGxzRNNipr3nyN4uDk6/wf1RqeFdZGbWd3rIOcAkAuj4SjJMXo2XR6Rte5iG/
         T5gYipkgIEKTuHxcguMJWsNTk8+IgoOTRYVBFAdEG+tn2bDC8wbgLiiB+J0M8Uwnqbdm
         YuOZdqBrSRWUWn8mWck7nvrVHNn4YJ2VCn1Vwg1F8PbZqe145Ns41oZ15DEX/nBqYWRI
         W7YQ==
In-Reply-To: <20200427235621.7823-5-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>



> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman@redhat.com> wrote:
>=20
> A lockdep splat is observed by echoing "1" to the shrink sysfs file
> and then shutting down the system:
>=20
> [  167.473392] Chain exists of:
> [  167.473392]   kn->count#279 --> mem_hotplug_lock.rw_sem --> slab_mutex
> [  167.473392]
> [  167.484323]  Possible unsafe locking scenario:
> [  167.484323]
> [  167.490273]        CPU0                    CPU1
> [  167.494825]        ----                    ----
> [  167.499376]   lock(slab_mutex);
> [  167.502530]                                lock(mem_hotplug_lock.rw_sem=
);
> [  167.509356]                                lock(slab_mutex);
> [  167.515044]   lock(kn->count#279);
> [  167.518462]
> [  167.518462]  *** DEADLOCK ***
>=20
> It is because of the get_online_cpus() and get_online_mems() calls in
> kmem_cache_shrink() invoked via the shrink sysfs file. To fix that, we
> have to use trylock to get the memory and cpu hotplug read locks. Since
> hotplug events are rare, it should be fine to refuse a kmem caches
> shrink operation when some hotplug events are in progress.
>=20
> Signed-off-by: Waiman Long <longman@redhat.com>

Feel free to use,

Reviewed-by: Qian Cai <cai@lca.pw>=

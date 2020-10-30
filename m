From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v20 02/20] mm/memcg: bail early from swap accounting if
 memcg disabled
Date: Fri, 30 Oct 2020 10:27:51 +0800
Message-ID: <96b6d122-df0e-dfb0-368c-6bd714fab116@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-3-git-send-email-alex.shi@linux.alibaba.com>
 <20201029134648.GC599825@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201029134648.GC599825@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>



=D4=DA 2020/10/29 =CF=C2=CE=E79:46, Johannes Weiner =D0=B4=B5=C0:
>>  ? release_pages+0x1ae/0x410
>>  shmem_alloc_and_acct_page+0x77/0x1c0
>>  shmem_getpage_gfp+0x162/0x910
>>  shmem_fault+0x74/0x210
>>  ? filemap_map_pages+0x29c/0x410
>>  __do_fault+0x37/0x190
>>  handle_mm_fault+0x120a/0x1770
>>  exc_page_fault+0x251/0x450
>>  ? asm_exc_page_fault+0x8/0x30
>>  asm_exc_page_fault+0x1e/0x30
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Reviewed-by: Roman Gushchin <guro@fb.com>
>> Acked-by: Michal Hocko <mhocko@suse.com>
>> Acked-by: Hugh Dickins <hughd@google.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: cgroups@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>=20
> This should go in before the previous patch that adds the WARN for it.

Right, but than the long ops may not weird. Should I remove the ops and res=
end the whole patchset?

Which way is convenient for you?

Thanks
Alex

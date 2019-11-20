From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v4 9/9] mm/lru: revise the comments of lru_lock
Date: Wed, 20 Nov 2019 19:48:57 +0800
Message-ID: <f122583d-8041-3c05-1177-1a0d43e69e4f@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-10-git-send-email-alex.shi@linux.alibaba.com>
 <20191119161958.GE382712@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119161958.GE382712@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, Ira Weiny <ira.weiny@intel.com>, Jesper Dangaard Brouer <brouer@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>, Logan Gunthorpe <logang@deltatee.com>, Souptick Joarder <jrdr.linux@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, "Tobin C. Harding" <tobin@kernel.org>, Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvado>



=D4=DA 2019/11/20 =C9=CF=CE=E712:19, Johannes Weiner =D0=B4=B5=C0:
> On Tue, Nov 19, 2019 at 08:23:23PM +0800, Alex Shi wrote:
>> Since we changed the pgdat->lru_lock to lruvec->lru_lock, it's time to
>> fix the incorrect comments in code. Also fixed some zone->lru_lock comme=
nt
>> error from ancient time. etc.
>>
>> Originally-from: Hugh Dickins <hughd@google.com>
>=20
> You can resubmit a patch written by somebody else, but you need to
> preserve authorship such that git can attribute it properly:
>=20
> 	From: Hugh Dickins <hughd@google.com>
>=20
> in the patch header, as well as
>=20
> 	Signed-off-by: Hugh Dickins <hughd@google.com>
>=20
> in the changelog tags. It should look something like this:
>=20
> ---
> From: Hugh Dickins <hughd@google.com>
> Subject: [PATCH] mm/memcg: update lru_lock Doc and comments
>=20
> Update scattered references from "zone_lru_lock" to "lruvec->lru_lock"
> (in low-level descriptions) or "lruvec lock" (where that reads better).
>=20
> In the course of doing so, update lock ordering comments in mm/rmap.c
> and mm/filemap.c and Documentation/cgroups/memory.txt - slightly, with
> no attempt to be complete (swap_lock, in particular, left out-of-date).
> Remove allusions to set_page_dirty under page_remove_rmap: gone in v3.9.
>=20
> memcg_test.txt looks quite out-of-date: just give LRU a short paragraph.
> Replaced zone by node throughout unevictable-lru.txt (except for stats).
> Leave Documentation/locking/lockstat.txt untouched this time: it doesn't
> matter if that still refers to zone->lru_lock, along with other history.
>=20
> I struggled to understand the comment above move_pages_to_lru() (surely
> it never calls page_referenced()), and eventually realized that most of
> it had got separated from shrink_active_list(): move that comment back.
>=20
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> ---
>=20

Thanks for teaching!

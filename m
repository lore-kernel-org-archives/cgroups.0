From: Qiang Yu <qiang.yu@amd.com>
Subject: [PATCH RFC 0/3] mm/memcontrol drm/ttm: charge ttm buffer backed by
 system memory
Date: Mon, 13 Jan 2020 23:35:40 +0800
Message-ID: <20200113153543.24957-1-qiang.yu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsmRFEVmj30XrwddG2qG6+/9LY7okiYo3z6I6OKGbrs=;
 b=derinofgmcsleCAXhujSxeIKTxTl2BzgWy+LVErHA29fDH2jrgZT60u4tanLCqHi05pQiT2Vcp9ND265z/Szh2rn8o4q/0X0/NG4Q9WNRtGVqPoIkSrjflFK+XlmhgNasTzdMYDUY2lMG5ft3kI14ELG9WR0ddT3cyt+bBhkzFk=
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: linux-mm@kvack.org, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Kenny Ho <kenny.ho@amd.com>, Michal Hocko <mhocko@kernel.org>, Qiang Yu <qiang.yu@amd.com>, Huang Rui <ray.huang@amd.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Koenig <christian.koenig@amd.com>

Buffers created by GPU driver could be huge (often several MB and even hundred
or thousand MB). Some GPU driver call drm_gem_get_pages() which uses shmem to
allocate these buffers which will charge memcg already, while some GPU driver
like amdgpu use TTM which just allocate these system memory backed buffers with
alloc_pages() so won't charge memcg currently.

Not like pure kernel memory, GPU buffer need to be mapped to user space for user
filling data and command then let GPU hardware consume these buffers. So it is
not proper to use memcg kmem by adding __GFP_ACCOUNT to alloc_pages gfp flags.

Another reason is back memory of GPU buffer may be allocated latter after the
buffer object is created, and even in other processes. So we need to record the
memcg when buffer object creation, then charge it latter when needed.

TTM will use a page pool acting as a cache for write-combine/no-cache pages.
So adding new GFP flags for alloc_pages also does not work.

Qiang Yu (3):
  mm: memcontrol: add mem_cgroup_(un)charge_drvmem
  mm: memcontrol: record driver memory statistics
  drm/ttm: support memcg for ttm_tt

 drivers/gpu/drm/ttm/ttm_bo.c         | 10 +++++
 drivers/gpu/drm/ttm/ttm_page_alloc.c | 18 ++++++++-
 drivers/gpu/drm/ttm/ttm_tt.c         |  3 ++
 include/drm/ttm/ttm_bo_api.h         |  5 +++
 include/drm/ttm/ttm_tt.h             |  4 ++
 include/linux/memcontrol.h           | 22 +++++++++++
 mm/memcontrol.c                      | 58 ++++++++++++++++++++++++++++
 7 files changed, 119 insertions(+), 1 deletion(-)

-- 
2.17.1

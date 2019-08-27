From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v3] writeback, memcg: Implement foreign inode flushing
Date: Tue, 27 Aug 2019 09:23:09 -0600
Message-ID: <15a5a6e8-90bf-726b-f68c-db91f1afc651@kernel.dk>
References: <20190826160656.870307-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EialagdAgnBtYjzH6H0eO9CyoHJZ48U2U5aIVIJeUoo=;
        b=figx/Q98kEpCBkqo3lxQ6atjRtKnOZ/vizqGhR6ya8V3vn3+aFl2oTLswEK1VjnEMg
         An75CIk3RkB52JqKH80uhifoZiBjBgP+rPZNgE/8ipmRd77Ok9Xb6Y+4IeWDeVn8lmKd
         ySMOZk1uc2qMWNtBcJuL843WNs9SFPe/F1JQBw+7MCJe3UdkDKvttcuwKgwAi9oppUSI
         vRtaD9Uy56A0NEqyv6qNzLxcz1F6B3uV/Dp3f7ve6N1FqXtz+1EzyKNRy7GFif41nKI3
         nQoC9QQViIIaBRegMiHx06KhObDFDXWzNvmgR56X0UTpzB2kBNE2KFkzbQ9//Alh90Yc
         O4RA==
In-Reply-To: <20190826160656.870307-1-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On 8/26/19 10:06 AM, Tejun Heo wrote:
> Hello,
> 
> Changes from v1[1]:
> 
> * More comments explaining the parameters.
> 
> * 0003-writeback-Separate-out-wb_get_lookup-from-wb_get_create.patch
>    added and avoid spuriously creating missing wbs for foreign
>    flushing.
> 
> Changes from v2[2]:
> 
> * Added livelock avoidance and applied other smaller changes suggested
>    by Jan.
> 
> There's an inherent mismatch between memcg and writeback.  The former
> trackes ownership per-page while the latter per-inode.  This was a
> deliberate design decision because honoring per-page ownership in the
> writeback path is complicated, may lead to higher CPU and IO overheads
> and deemed unnecessary given that write-sharing an inode across
> different cgroups isn't a common use-case.
> 
> Combined with inode majority-writer ownership switching, this works
> well enough in most cases but there are some pathological cases.  For
> example, let's say there are two cgroups A and B which keep writing to
> different but confined parts of the same inode.  B owns the inode and
> A's memory is limited far below B's.  A's dirty ratio can rise enough
> to trigger balance_dirty_pages() sleeps but B's can be low enough to
> avoid triggering background writeback.  A will be slowed down without
> a way to make writeback of the dirty pages happen.
> 
> This patchset implements foreign dirty recording and foreign mechanism
> so that when a memcg encounters a condition as above it can trigger
> flushes on bdi_writebacks which can clean its pages.  Please see the
> last patch for more details.
> 
> This patchset contains the following four patches.
> 
>   0001-writeback-Generalize-and-expose-wb_completion.patch
>   0002-bdi-Add-bdi-id.patch
>   0003-writeback-Separate-out-wb_get_lookup-from-wb_get_create.patch
>   0004-writeback-memcg-Implement-cgroup_writeback_by_id.patch
>   0005-writeback-memcg-Implement-foreign-dirty-flushing.patch
> 
> 0001-0004 are prep patches which expose wb_completion and implement
> bdi->id and flushing by bdi and memcg IDs.
> 
> 0005 implements foreign inode flushing.
> 
> Thanks.  diffstat follows.
> 
>   fs/fs-writeback.c                |  130 ++++++++++++++++++++++++++++---------
>   include/linux/backing-dev-defs.h |   23 ++++++
>   include/linux/backing-dev.h      |    5 +
>   include/linux/memcontrol.h       |   39 +++++++++++
>   include/linux/writeback.h        |    2
>   mm/backing-dev.c                 |  120 +++++++++++++++++++++++++++++-----
>   mm/memcontrol.c                  |  134 +++++++++++++++++++++++++++++++++++++++
>   mm/page-writeback.c              |    4 +
>   8 files changed, 404 insertions(+), 53 deletions(-)

Applied for 5.4, thanks Tejun.

-- 
Jens Axboe


From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 16 Nov 2022 18:06:13 -0500
Message-ID: <4b5142be-6a47-9dfd-a238-5b9d29b296b8@redhat.com>
References: <20221105005902.407297-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668639980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWNz/QE0hFws1BC7T/rZzODjo9Sug+sYTjrv+WWI+bk=;
        b=Brb1a3sloUczU+r95lyoX3/7S6WV1NVpaNwUINt6YEmAjcPZRqe8pq46BV49Lvy8AcOhMT
        S6H/ewvUcaf2mfux9QCoOF0EmXXgGdbm0EwmFP+mdwe2ikb7rcxrIqxd3v8hCN34ngpBRq
        nx4Le3cIqUN1vdH0YtkGFwXko3RMZh0=
Content-Language: en-US
In-Reply-To: <20221105005902.407297-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Tejun Heo <tj@kernel.org>

On 11/4/22 20:58, Waiman Long wrote:
>   v10:
>    - Update patch 3 to rename the rstat function to
>      cgroup_rstat_css_cpu_flush().
>
>   v9:
>    - Remove patch "llist: Allow optional sentinel node terminated lockless
>      list" for now. This will be done as a follow-up patch.
>    - Add a new lqueued field to blkg_iostat_set to store the status of
>      whether lnode is in a lockless list.
>    - Add a new patch 3 to speed up the freeing of blkcg by flushing out
>      the rstat lockless lists at blkcg offline time.
>
>   v8:
>    - Update the llist patch to make existing llist functions and macros
>      work for both NULL and sentinel terminated lockless list as much
>      as possible and leave only the initialization and removal functions
>      to have a sentinel terminated llist variants.
>
> This patch series improves blkcg_rstat_flush() performance by eliminating
> unnecessary blkg enumeration and flush operations for those blkg's and
> blkg_iostat_set's that haven't been updated since the last flush.
>
> Waiman Long (3):
>    blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
>    blk-cgroup: Optimize blkcg_rstat_flush()
>    blk-cgroup: Flush stats at blkgs destruction path
>
>   block/blk-cgroup.c     | 103 +++++++++++++++++++++++++++++++++++------
>   block/blk-cgroup.h     |  10 ++++
>   include/linux/cgroup.h |   1 +
>   kernel/cgroup/rstat.c  |  20 ++++++++
>   4 files changed, 119 insertions(+), 15 deletions(-)

Jens, do you have any further comment on this patchset? Is it possible 
to queue it for the next Linux version?

Cheers,
Longman


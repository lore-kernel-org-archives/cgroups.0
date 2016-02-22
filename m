From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 22 Feb 2016 10:29:37 +0530
Message-ID: <CAG53R5U4feaPz+1dYg67UJvRpWugpN3G-MPaxigz4WNYLuOOUw@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=bE6TGwaVoNx1w0IgAiQqCJ2Ay9huQo4sDl4RQJI4E9Q=;
        b=flTP9l4AsaJB7MN5kCJXObIwcUUv1KOAVZiVnUOAgs9ixxnQkJPImyZ0jU0eTC55yO
         C5vyjppgGYGGFwBSIVIWGR2HmInjAUeYf0X9cSWSZztHXC6u9YPmz9e4gy9OZvSqp8BS
         0QEbr/mQoNvK9eAt1s5iQhev13Io4/3bvMgXN+JMAgExigYlqva89WwKpYUPuEkuiX5c
         SofCqEZaRwU7+QXGJZgT2KI3eizqbyUe8LVTg9jc9EUHv5NmA9dlxdW2Hjk5o30jhhER
         WRMpyODkqnMgE44JGJvHegwHWzoPF84y7jCTtqkyUSDBFHzaJOn+fOQUXjSKwiSr17af
         Fswg==
In-Reply-To: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>
Cc: Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, Parav Pandit <pandit.parav@gmail.com>

Hi Tejun, Doug,

I would like to know direction from you on how do we intent to merge this code.
So that I generate next patch v7 against right tree.

Few options that comes to me are:
1. Shall we merge this code from Doug's linux-rdma tree, where there
are no merge conflicts in cgroup?
Or
2. Shall we merge this as two separate patches one from cgroup side
from Tejun's cgroups tree as kernel support and 2nd from linux-rdma
for IB core changes to make use of those features?
Or
3. Some other options that you have in mind.

I was thinking of (1) as that has the least churn in development, test
and merge efforts.

Regards,
Parav Pandit

On Sat, Feb 20, 2016 at 4:30 PM, Parav Pandit <pandit.parav@gmail.com> wrote:
> Overview:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources. This results into service unavailibility.
>
> RDMA cgroup addresses this issue by allowing resource accounting,
> limit enforcement on per cgroup, per rdma device basis.
>
> Resources are not defined by the RDMA cgroup. Resources are defined
> by RDMA/IB stack. This allows rdma cgroup to remain constant while RDMA/IB
> stack can evolve without the need of rdma cgroup update. A new
> resource can be easily added by the RDMA/IB stack without touching
> rdma cgroup.
>
> RDMA uverbs layer will enforce limits on well defined RDMA verb
> resources without any HCA vendor device driver involvement.
>
> RDMA uverbs layer will not do accounting of hw vendor specific resources.
> Instead rdma cgroup provides set of APIs through which vendor specific
> drivers can do resource accounting by making use of rdma cgroup.
>
> Resource limit enforcement is hierarchical.
>
> When process is migrated with active RDMA resources, rdma cgroup
> continues to uncharge original cgroup for allocated resource. New resource
> is charged to current process's cgroup, which means if the process is
> migrated with active resources, for new resources it will be charged to
> new cgroup and old resources will be correctly uncharged from old cgroup.
>
> Changes from v5:
>  * (To address comments from Tejun)
>    1. Removed two type of resource pool, made is single type (as Tejun
>       described in past comment)
>    2. Removed match tokens and have array definition like "qp", "mr",
>       "cq" etc.
>    3. Wrote small parser and avoided match_token API as that won't work
>       due to different array definitions
>    4. Removed one-off remove API to unconfigure cgroup, instead all
>       resource should be set to max.
>    5. Removed resource pool type (user/default), instead having
>       max_num_cnt, when ref_cnt drops to zero and
>       max_num_cnt = total_rescource_cnt, pool is freed.
>    6. Resource definition ownership is now only with IB stack at single
>       header file, no longer in each low level driver.
>       This goes through IB maintainer and other reviewers eyes.
>       This continue to give flexibility to not force kernel upgrade for
>       few enums additions for new resource type.
>    7. Wherever possible pool lock is pushed out, except for hierarchical
>       charging/unchanging points, as it not possible to do so, due to
>       iterative process involves blocking allocations of rpool. Coming up
>       more levels up to release locks doesn't make any sense either.
>       This is anyway slow path where rpool is not allocated. Except for
>       typical first resource allocation, this is less travelled path.
>    8. Avoided %d manipulation due to removal of match_token and replaced
>       with seq_putc etc friend functions.
>  * Other minor cleanups.
>  * Fixed rdmacg_register_device to return error in case of IB stack
>    tries to register for than 64 resources.
>  * Fixed not allowing negative value on resource setting.
>  * Fixed cleaning up resource pools during device removal.
>  * Simplfied and rename table length field to use ARRAY_SIZE macro.
>  * Updated documentation to reflect single resource pool and shorter
>    file names.
>
> Changes from v4:
>  * Fixed compilation errors for lockdep_assert_held reported by kbuild
>    test robot
>  * Fixed compilation warning reported by coccinelle for extra
>    semicolon.
>  * Fixed compilation error for inclusion of linux/parser.h which
>    cannot be included in any header file, as that triggers multiple
>    inclusion error. parser.h is included in C files which intent to
>    use it.
>  * Removed unused header file inclusion in cgroup_rdma.c
>
> Changes from v3:
>  * (To address comments from Tejun)
>    1. Renamed cg_resource to rdmacg_resource
>    2. Merged dealloc_cg_rpool and _dealloc_cg_rpool to single function
>    3. Renamed _find_cg_rpool to find_cg_rpool_locked()
>    5. Removed RDMACG_MAX_RESOURCE_INDEX limitation
>    6. Fixed few alignments.
>    7. Improved description for RDMA cgroup configuration menu
>    8. Renamed cg_list_lock to rpool_list_lock to reflect the lock
>       is for rpools.
>    9. Renamed _get_cg_rpool to find_cg_rpool.
>    10. Made creator as int variable, instead of atomic as its not
>       required to be atomic.
>  * Fixed freeing right rpool during query_limit error path
>  * Added copywrite for cgroup.c
>  * Removed including parser.h from cgroup.c as its included by cgroup_rdma.h
>  * Reduced try_charge functions to single function and removed duplicate
>    comments.
>
> Changes from v2:
>  * Fixed compilation error reported by 0-DAY kernel test infrastructure
>    for m68k architecture where CONFIG_CGROUP is also not defined.
>  * Fixed comment in patch to refer to legacy mode of cgroup, changed to
>    refer to v1 and v2 version.
>  * Added more information in commit log for rdma controller patch.
>
> Changes from v1:
>  * (To address comments from Tejun)
>    a. reduces 3 patches to single patch
>    b. removed resource word from the cgroup configuration files
>    c. changed cgroup configuration file names to match other cgroups
>    d. removed .list file and merged functionality with .max file
>  * Based on comment to merge to single patch for rdma controller;
>    IB/core patches are reduced to single patch.
>  * Removed pid cgroup map and simplified design -
>    Charge/Uncharge caller stack keeps track of the rdmacg for
>    given resource. This removes the need to maintain and perform
>    hash lookup. This also allows little more accurate resource
>    charging/uncharging when process moved from one to other cgroup
>    with active resources and continue to allocate more.
>  * Critical fix: Removed rdma cgroup's dependency on the kernel module
>    header files to avoid crashes when modules are upgraded without kernel
>    upgrade, which is very common due to high amount of changes in IB stack
>    and it is also shipped as individual kernel modules.
>  * uboject extended to keep track of the owner rdma cgroup, so that same
>    rdmacg can be used while uncharging.
>  * Added support functions to hide details of rdmacg device in uverbs
>    modules for cases of cgroup enabled/disabled at compile time. This
>    avoids multiple ifdefs for every API in uverbs layer.
>  * Removed failure counters in first patch, which will be added once
>    initial feature is merged.
>  * Fixed stale rpool access which is getting freed, while doing
>    configuration to rdma.verb.max file.
>  * Fixed rpool resource leak while querying max, current values.
>
> Changes from v0:
> (To address comments from Haggai, Doug, Liran, Tejun, Sean, Jason)
>  * Redesigned to support per device per cgroup limit settings by bringing
>    concept of resource pool.
>  * Redesigned to let IB stack define the resources instead of rdma
>    controller using resource template.
>  * Redesigned to support hw vendor specific limits setting
>    (optional to drivers).
>  * Created new rdma controller instead of piggyback on device cgroup.
>  * Fixed race conditions for multiple tasks sharing rdma resources.
>  * Removed dependency on the task_struct.
>
> Patch 2/3 fails to merge with Doug's tree as it has different code.
> It requires manual merge.
> I will generate separate patch for Doug's tree for linux-rdma for
> just patch 2/3 to avoid merge conflict once we complete overall
> review.
>
>
> Parav Pandit (3):
>   rdmacg: Added rdma cgroup controller
>   IB/core: added support to use rdma cgroup controller
>   rdmacg: Added documentation for rdmacg
>
>  Documentation/cgroup-v1/rdma.txt      | 106 +++++
>  Documentation/cgroup-v2.txt           |  33 ++
>  drivers/infiniband/core/Makefile      |   1 +
>  drivers/infiniband/core/cgroup.c      | 114 +++++
>  drivers/infiniband/core/core_priv.h   |  36 ++
>  drivers/infiniband/core/device.c      |  16 +
>  drivers/infiniband/core/uverbs_cmd.c  | 164 +++++++-
>  drivers/infiniband/core/uverbs_main.c |  19 +
>  include/linux/cgroup_rdma.h           |  53 +++
>  include/linux/cgroup_subsys.h         |   4 +
>  include/rdma/ib_verbs.h               |  30 +-
>  init/Kconfig                          |  10 +
>  kernel/Makefile                       |   1 +
>  kernel/cgroup_rdma.c                  | 753 ++++++++++++++++++++++++++++++++++
>  14 files changed, 1324 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/cgroup-v1/rdma.txt
>  create mode 100644 drivers/infiniband/core/cgroup.c
>  create mode 100644 include/linux/cgroup_rdma.h
>  create mode 100644 kernel/cgroup_rdma.c
>
> --
> 1.8.3.1
>

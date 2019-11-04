From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] kernfs: Convert to u64 id
Date: Mon, 4 Nov 2019 08:59:01 -0500
Message-ID: <20191104085901.06035a26@grimm.local.home>
References: <20191104084520.398584-1-namhyung@kernel.org>
        <20191104084520.398584-2-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104084520.398584-2-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Namhyung Kim <namhyung@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Song Liu <liu.song.a23@gmail.com>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>, linux-block@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org

On Mon,  4 Nov 2019 17:45:19 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> From: Tejun Heo <tj@kernel.org>
> 
> The kernfs_id was an union type sharing a 64bit id with 32bit ino +
> gen.  But it resulted in using 32bit inode even on 64bit systems.
> Also dealing with an union is annoying especially if you just want to
> use a single id.
> 
> Thus let's get rid of the kernfs_node_id type and use u64 directly.
> The upper 32bit is used for gen and lower is for ino on 32bit systems.
> The kernfs_id_ino() and kernfs_id_gen() helpers will take care of the
> bit handling depends on the system word size.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-block@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tejun Heo <tj@kernel.org>
> [namhyung: fix build error in bpf_get_current_cgroup_id()]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  fs/kernfs/dir.c                  | 36 ++++++++-----
>  fs/kernfs/file.c                 |  4 +-
>  fs/kernfs/inode.c                |  4 +-
>  fs/kernfs/kernfs-internal.h      |  2 -
>  fs/kernfs/mount.c                | 92 +++++++++++++++++++-------------
>  include/linux/cgroup.h           | 17 +++---
>  include/linux/exportfs.h         |  5 ++
>  include/linux/kernfs.h           | 47 +++++++++-------

>  include/trace/events/writeback.h | 92 ++++++++++++++++----------------

I only looked at the above file, and didn't see anything bad about it.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


>  kernel/bpf/helpers.c             |  2 +-
>  kernel/cgroup/cgroup.c           |  5 +-
>  kernel/trace/blktrace.c          | 66 +++++++++++------------
>  net/core/filter.c                |  4 +-
>  13 files changed, 207 insertions(+), 169 deletions(-)


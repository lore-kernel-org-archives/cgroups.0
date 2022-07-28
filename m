From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v5 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Wed, 27 Jul 2022 22:51:16 -0700
Message-ID: <8678322f-01e9-862e-9c6e-1ada1c6badf5@fb.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-9-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wkxOQHgGT4k2jPe4Si8am0cE/jsE4UHpNi3tOzBsKb8=;
 b=JKgq9S1ui3aDosWiq2hYIcl3hPa+sxUYv1skyfVkyoOhNE/VVwX1INB/5MXKH7XQuthD
 G8AJo0Zld4hluIoLAu+d9xGiCGa0wCn0V6jeemFuKHp+NBDAOkovIEf24TpfIJGf4vyJ
 8wd/hI1sbaZ6guZUGGVQtT+mNd7lPW4IYBQ= 
Content-Language: en-US
In-Reply-To: <20220722174829.3422466-9-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 7/22/22 10:48 AM, Yosry Ahmed wrote:
> Add a selftest that tests the whole workflow for collecting,
> aggregating (flushing), and displaying cgroup hierarchical stats.
> 
> TL;DR:
> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it.
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats, and outputs the stats in text format to userspace (similar
>    to cgroupfs stats).
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>    updates, vmscan_flush aggregates cpu readings and propagates updates
>    to parents.
> - Userspace program makes sure the stats are aggregated and read
>    correctly.
> 
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>    measure the latency of cgroup reclaim. Per-cgroup readings are stored in
>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>    rstat updated tree on that cpu.
> 
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>    each cgroup. Reading this file invokes the program, which calls
>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
>    iteration early, so that we only expose stats for one cgroup per read.
> 
> - An ftrace program, vmscan_flush, is also loaded and attached to
>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>    from the rstat tree in a bottom-up fashion, so calls will always be
>    made for cgroups that have updates before their parents. The program
>    aggregates percpu readings to a total per-cgroup reading, and also
>    propagates them to the parent cgroup. After rstat flushing is over, all
>    cgroups will have correct updated hierarchical readings (including all
>    cpus and all their descendants).
> 
> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it, and makes sure that the stats collection, aggregation,
>    and reading workflow works as expected.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Let us tag the subject with "selftests/bpf: Add a selftest ..." instead
of "bpf: add a selftest ..."

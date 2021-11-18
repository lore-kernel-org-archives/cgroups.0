From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH RFC 0/4] Add ability to attach bpf programs to a tracepoint inside a cgroup
Date: Thu, 18 Nov 2021 15:28:36 -0500
Message-ID: <20211118202840.1001787-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Bemx6QLhgKhSDBo3I2D4fFXgf9muLskl2EoJJes6X4=;
 b=tEjp0YOqIHIPK+3S5MXJrEePEHMNu5BECso0gwG4zAmNMt4tW8hg52G7uGfX/SLWDNQkokz6f7eFOpnrgB8Oq4URzLVT99mJIYDLtFNi/fJvmVfCXmXwmCMnQ8HVtrc46zKZjfeb5LFHD5/cdYE6YHJFa23NBBuWc39YUvn7w/E=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux

Per an earlier discussion last year[1], I have been looking for a mechanism to a) collect resource usages for devices (GPU for now but there could be other device type in the future) and b) possibly enforce some of the resource usages.  An obvious mechanism was to use cgroup but there are too much diversity in GPU hardware architecture to have a common cgroup interface at this point.  An alternative is to leverage tracepoint with a bpf program inside a cgroup hierarchy for usage collection and enforcement (via writable tracepoint.)

This is a prototype for such idea.  It is incomplete but I would like to solicit some feedback before continuing to make sure I am going down the right path.  This prototype is built based on my understanding of the followings:

- tracepoint (and kprobe, uprobe) is associated with perf event
- perf events/tracepoint can be a hook for bpf progs but those bpf progs are not part of the cgroup hierarchy
- bpf progs can be attached to the cgroup hierarchy with cgroup local storage and other benefits
- separately, perf subsystem has a cgroup controller (perf cgroup) that allow perf event to be triggered with a cgroup filter

So the key idea of this RFC is to leverage hierarchical organization of bpf-cgroup for the purpose of perf event/tracepoints.

==Known unresolved topics (feedback very much welcome)==
Storage:
I came across the idea of "preallocated" memory for bpf hash map/storage to avoid deadlock[2] but I don't have a good understanding about it currently.  If existing bpf_cgroup_storage_type are not considered pre-allocated then I am thinking we can introduce a new type but I am not sure if this is needed yet.

Scalability:
Scalability concern has been raised about perf cgroup [3] and there seems to be a solution to it recently with bperf [4].  This RFC does not change the status quo on the scalability question but if I understand the bperf idea correctly, this RFC may have some similarity.

[1] https://lore.kernel.org/netdev/YJXRHXIykyEBdnTF-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/T/#m52bc26bbbf16131c48e6b34d875c87660943c452
[2] https://lwn.net/Articles/679074/
[3] https://www.linuxplumbersconf.org/event/4/contributions/291/attachments/313/528/Linux_Plumbers_Conference_2019.pdf
[4] https://linuxplumbersconf.org/event/11/contributions/899/

Kenny Ho (4):
  cgroup, perf: Add ability to connect to perf cgroup from other cgroup
    controller
  bpf, perf: add ability to attach complete array of bpf prog to perf
    event
  bpf,cgroup,tracing: add new BPF_PROG_TYPE_CGROUP_TRACEPOINT
  bpf,cgroup,perf: extend bpf-cgroup to support tracepoint attachment

 include/linux/bpf-cgroup.h   | 17 +++++--
 include/linux/bpf_types.h    |  4 ++
 include/linux/cgroup.h       |  2 +
 include/linux/perf_event.h   |  6 +++
 include/linux/trace_events.h |  9 ++++
 include/uapi/linux/bpf.h     |  2 +
 kernel/bpf/cgroup.c          | 96 +++++++++++++++++++++++++++++-------
 kernel/bpf/syscall.c         |  4 ++
 kernel/cgroup/cgroup.c       | 13 ++---
 kernel/events/core.c         | 62 +++++++++++++++++++++++
 kernel/trace/bpf_trace.c     | 36 ++++++++++++++
 11 files changed, 222 insertions(+), 29 deletions(-)

-- 
2.25.1


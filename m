Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF23527599
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168901; cv=pass; b=rm3fSu8oewgcCOLHvLMZr5HzZwWh9FzawujNy8+ch7ScPWm/YV1r1VJsmKShGnhexeLlT6+cwXm7568iOo3bMQkyZJSbpv1KmXVBplCKNRrYQXjrB6fFH5Lo+hbO9RcCy/Ak1bPpaD8q8JyTzzjTTe35JuDvRxpZ3gIR/lZiD3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168901; c=relaxed/simple;
	bh=/RAtfZYaGrMgM0hFBipcgr1fQfwrDzFXi14Gl2TQCFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNo8H+A5CJaL0tJcgi/ZfAcjAEk4XZbSlekt3NFqKfhHzJWd2aBRYyx6N467KHfVooa6xwXdoWDXoJ0DMWMDqRoJQeuAmfOluazNXrVn87F+DD5ye8U3uTYAdEkZRT80ruuaCxAN1t7TvG4XurIjRABLkv6WMSHEKs9PLNtz4PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpySlabk; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpySlabk"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43f9b119so14165887b3.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:08:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790168897; cv=none;
        d=google.com; s=arc-20260327;
        b=dL6wi68AjdoHcCwk5JHXODLQiYZ7kw4JhPklycUaU10AMEcY/8cJ2xsVSnPgTxgOCf
         lzWJ7DJftVF5cRVHks+7z9YWjQJHjqUdvL3ouDJKKL6twqY4Ow2GCgTp3rveeqaXHyO5
         LDX/d45LE0Fp8yU9hv6NXfZlte86z4w4TrWhiUAbk6FqwJhp7t40MO19WqRpcGIFUNuy
         cgMm0Syi/MzyOLN3ttEKOGDECxT++rmg6NwUqgKeqGzjizV/pE5Rx1n1/D6z0qBcz0qV
         RlB35Z5l4+4+qX/3Sx/MThdb/k49Us8KNgdLtdGwtXXMfOcvIBavKzcjfVMNfWvNaGCG
         7YQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        fh=a5dUc+3dz/i/GVtgRyo63opdys7k/jBW1BgGvYql8cg=;
        b=H/6jV8mvj0G/L8WRxrtfXPj0PNhXOuKVcJFaeMTSwf62bWs+r6AmmRrSDMt8olygpX
         ppq3BsK5/DOLTi/Y+0OQYG8BuIVdg7Vf3IIbpvHgHHS5EcEWA2P19+GXJa8pVTwHrIYP
         PSzdAewPXSk4M0RxrMUVOa4tgkNlUTm8ahRc5RIzvcibnRhasp+X1qvc2mQPZ1EJzfDt
         GlyePHWp8uIYJcXcyybLAVqGUwJBGtuOmPYGWarNnUOTVPjw0m227mk4pfBLEl2y2Mfz
         ep8TsjXyo6b4TBDrllHU3pw7jp4ad/TSNd/NcjJiJhAWwiEdXGOjMOFnom27rIU79ck8
         lipw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790168897; x=1790773697; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        b=mpySlabk+67WBHYYonxW93h5M/oebjNrbO8YhKE5Eaxtm4EAnxukVHCmtNuwy+BZCe
         lQ183KmbuJQL8XzoTkya8bWd/Dxr1P8SQvwb5WHpyCg+bCCDRLcmOA7ylDw71/9rFH/o
         AERfEoGc3NA56ogqxsaN/MRET0SOKkymjwMrHf6eFlucPoUhwxWuaQDD/bqf1rl3I4rj
         Jb/9/4GjXKXloNompG9LedGS9P6+C20eXVGRKMywPkNDz/VcOPF1JrTysLF6e0K9QNZG
         Ga6LESimDyGSdazypjYH+cXgVMnoAJ05i1a260WgGhQMQJJDPfE35AvH6HFDEIkjt44n
         0cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168897; x=1790773697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IHUbabRXBqdvbV25eXrArHoQuD9SOTIdcQ2oJXMH2as=;
        b=PvIFH0zrES4XsJww1zZljt1qChvtTXaGu1pvH/MINyrGwvE6+X2agn+8N6k9tfAJdH
         AsNHnWwriiJcuFN/NPMxxWyF+d3q+WdR3k5ZayNZ7e+gUwy9KTppq8G7pmhJV5GgLKMd
         epIVnltVrURPvyH+K5gCSXHywDAOV6tpU+Z67BkJIEFgAY0zZvIj7sa0MToUjqx4ie2j
         ShBSvYYN07p5OZ/tdhWr2S29vDbW+6R0wRNCiWsLg757ygQxH8xb1sQeSqJJWZhRzzZz
         pmX9Hq7mBNzu020VOH8cGxA91CbpXq6X9YjYlgCjN3T4JBsQsT1T21W1MZCZS4qUIEwk
         cFzQ==
X-Forwarded-Encrypted: i=1; AKwUvByMjp6NZPqoATJY8WCuED9KwIpLlgYnpaYnN1N9naLWkr3QLgCBZBcp9ZwXsLMqdow4AWudATuC@vger.kernel.org
X-Gm-Message-State: AFuF++mXbmTMteMSCaq1+U+JK3LKQPSyDTb3/1AMuh1+dBHF9PbK1Wbl
	PIudzREuiqzXT0n4uW6Jjg7DN0v34T3F0afN3nIDDt6SEOLv3q6VBkWGAb1b8mooKPdPR6X12kP
	MWgzYMSjPJUjKF6ftPoTUz/TDMItDRZE=
X-Gm-Gg: AYBFou1Ie9i2AwBx5SmxHlMhSn5nRNEckYsvMogPp8RSW0dbW0fFTz+msEDJG0Iwz3j
	VrIKPiDjMQ7BsbW/yr6je3bhHYaLCdME2magZ0m0g3jGD52UJRCf8jeyxy1wPI+EgJv007Q432L
	Zeetfqy5h3dc3Le44CCC5d1ySBtycrMDiyU3H8R7bn7LLCTATDbtVtKjRdu4C36dEmgWQ/wV6pu
	02+/vtxppiMxWGLjkwjIIl/Li2IQlwY9m95RGeJSfs8j6l7r4Ky+wB6evMsuG9JxlCttkktpEaz
	VL+EX/xNPvmza+ojqkaNNu62G3G1FlE29XewdtI1pZ+N9MdDwRR4wjQu7LwA8E7h61WsdvAzDEb
	ljO5WWWVjESDGVCqRoy6bPs35p42Jr9HiHQ==
X-Received: by 2002:a05:690c:7483:b0:8a5:1570:a2b2 with SMTP id
 00721157ae682-8a51570a635mr6866957b3.89.1790168896597; Wed, 23 Sep 2026
 06:08:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 23 Sep 2026 21:07:40 +0800
X-Gm-Features: AclHuK_8Jda0panK7HLuZ7wwf7U44o1nunsdozOcDRu1nw23Gwnh2GufMO41nA0
Message-ID: <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> This is the first series of memcg_ext, proposed at [1].  It adds
> bpf_memcg_ops, a struct_ops type through which memory controller policy i=
s
> attached to a cgroup.  A charge runs the policies of its cgroup and of
> every ancestor, and the kernel combines what they return.  BPF picks
> between things the kernel already does; it never does the work itself and
> never touches a page counter.
>
> The plan is to grow this one member at a time, and to add a member only
> when there is a concrete problem it solves and a measurement showing it
> does.  Nothing is added because it might be useful later.  So this first
> series adds one member, for one problem.
>
> The problem
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> try_charge_memcg() calls __mem_cgroup_handle_over_high() before it return=
s,
> which reclaims and can throttle the task.  That happens wherever the char=
ge
> happens, so a task holding a kernel lock can be stuck there, and everythi=
ng
> waiting on that lock is stuck behind it.
>
> One concrete scenario which can be resolved by this new feature is the
> kernfs notify worker. It delivers notifications with the cgroup2
> kernfs_rwsem held for read, and the charge for the delivery allocation go=
es
> to the cgroup that set the watch, usually one already under pressure. So
> the worker reclaims while holding the lock, a waiting writer blocks every
> later reader, and anything touching cgroupfs stalls for seconds. The patc=
h
> proposed in [2] fixes that one path in the kernel only for kernfs_rwsem.
> The same path still takes kernfs_supers_rwsem.
>
> One can make an argument that if we know the source of the issue in the
> kernel, why not fix it similarly to [2] instead of having a generic
> solution? The reason is that it will be an uphill and continuous battle a=
s
> the kernel keeps evolving and new sources of lock holders doing allocatio=
ns
> keep coming up. In addition, there will be cases where it might not be
> possible to move the allocations out of locks, or where doing so would
> make the code really ugly [3].
>
> high_policy() lets a policy say where memory.high should be enforced
> instead.  Its one request, BPF_MEMCG_HIGH_DEFER_INLINE, skips the inline
> call, leaving the debt to be paid at the return to userspace.
>
> Results
> =3D=3D=3D=3D=3D=3D=3D
>
> Measured on a kernel without [2], with a policy that marks cgroupfs kernf=
s
> lock holders.  Reproducer at [4].
>
>                                       baseline    policy    upstream fix
>   max kernfs_rwsem hold, worker        2.049 s     199 us   not taken
>   max kernfs_supers_rwsem hold         2.049 s     4.8 ms   2.056 s
>   max kernfs_rwsem write wait          4.096 s     6.2 ms   8.7 ms
>   walker passes over /sys/fs/cgroup        352       5711   6700
>   churn mkdir+rmdir ops                 13 059    364 832   415 488
>   churn max latency                     30.7 s    15.1 ms   12.7 ms
>
> The policy matches the fix on the bystander numbers, and does better on
> kernfs_supers_rwsem, which the fix does not help: it drops kernfs_rwsem
> from the delivery loop, while the policy stops the worker stalling at all=
,
> so every lock it holds benefits.
>
> The patches
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Patch 1 is a build fix.  __cgroup_bpf_query() only works because
> CGROUP_TCP_SOCK_OPS is the one struct_ops attach type; a second one break=
s
> the build and makes a query for type 0 return the wrong thing.
>
> Patch 2 adds the type and its registration, with no members, so nothing i=
s
> dispatched and behaviour does not change.  It also moves the attach type
> enum out of CONFIG_CGROUP_BPF and fixes the register_bpf_struct_ops() no-=
op
> stub, which never compiled because no caller reached it.
>
> Patch 3 adds high_policy() and wires it into try_charge_memcg().
>
> Patch 4 is the sample.  It tracks the two cgroupfs kernfs locks by hookin=
g
> the rwsem primitives rather than the forty-odd functions that take them.
>
> Known open questions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The semantics of memory.high for remote chargers or kernel threads is a
> grey area and this series does not aim to resolve that.
>
> Another open question is whether a bound on debt deferral is needed. At
> the moment, we think that rather than putting a limit on deferral for
> memory.high, it will be better to handle that through an async worker lik=
e
> memcg->high_work.  We aim to introduce that later, along with the right C=
PU
> accounting for that async work.

Hello Shakeel,

On the open question of how deferred debt eventually gets paid: would
it make sense for the policy to also notify userspace (e.g. via
ringbuf) when it defers, and have a userspace reclaimer do the reclaim
through memory.reclaim?

I understand one of the concerns for the async worker is CPU
accounting. If the concern is that the kworker's CPU usage is not
charged to the target cgroup, the userspace reclaimer could instead be
spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
cgroup, and both its CPU and memory usage get charged there.

One caveat: intermediate cgroups with the no-internal-process
constraint cannot take processes, so this would only work for leaf
cgroups.

What do you think?

>
> There is no prog_tests harness, so the numbers above come from the
> reproducer and not from the test suite.
>
> The sample's lock tracking costs about 8% throughput, because it
> instruments every rwsem operation on the system.  That is fine for a samp=
le
> that has to cover every path, but it argues for a cheaper way to track
> locks that cause isolation problems between unrelated workloads.
>
> Future work
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Asking the kernel to reclaim on the policy's behalf, so a task that canno=
t
> be throttled still pays. More members, each with a use case: hard-limit
> policy, reclaim shaping, dynamic protection.
>
> This builds on "bpf: A common way to attach struct_ops to a cgroup", whic=
h
> supplies attach, detach, ordering, update, query and the RCU rules.
> bpf_memcg_ops is its second user.
>
> [1] https://lore.kernel.org/20260307182424.2889780-1-shakeel.butt@linux.d=
ev/
> [2] https://lore.kernel.org/20260910045406.485295-1-shakeel.butt@linux.de=
v/
> [3] https://lore.kernel.org/20260917-wehten-achtfach-getarnt-c85a4812337d=
@brauner/
> [4] https://github.com/shakeelb/mempressure-repros/tree/main/kernfs-notif=
y-memcg
>
> Shakeel Butt (4):
>   bpf, cgroup: fix cgroup struct_ops query for a second attach type
>   memcg_ext: add cgroup-attached bpf_memcg_ops
>   memcg_ext: allow BPF to defer memory.high enforcement
>   selftests/bpf: add a cgroupfs lock-holder bpf_memcg_ops sample
>
>  MAINTAINERS                                   |   1 +
>  include/linux/bpf-cgroup-defs.h               |  22 +-
>  include/linux/bpf-cgroup.h                    |  14 +-
>  include/linux/bpf.h                           |   2 +-
>  include/linux/bpf_memcontrol.h                |  66 ++++++
>  include/linux/cgroup.h                        |   7 +
>  include/linux/sched.h                         |   4 +
>  kernel/bpf/cgroup.c                           |   3 +-
>  mm/bpf_memcontrol.c                           | 188 ++++++++++++++-
>  mm/memcontrol.c                               |  31 ++-
>  .../bpf/progs/memcg_ops_lockholder.c          | 222 ++++++++++++++++++
>  11 files changed, 546 insertions(+), 14 deletions(-)
>  create mode 100644 include/linux/bpf_memcontrol.h
>  create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_lockholde=
r.c
>
>
> base-commit: 6e36e099b15bed1e8e5b3e3136c5e3eb56a15aa7
> --
> 2.53.0-Meta
>
>

--=20
Regards
Yafang

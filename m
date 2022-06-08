From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Wed, 8 Jun 2022 13:17:35 +0200
Message-ID: <20220608111735.GE8747@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com>
 <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
 <20220606123222.GA4377@blackbody.suse.cz>
 <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
 <20220607121237.GC31717@blackbody.suse.cz>
 <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654687057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a6bf/XKIswMmhT0/MxqBFChdpkZvDy8EKPj+RsAd1+M=;
        b=fBte7kUPCjB2wXrYzPa9lBNyOS1Uqd5BrWTaIy5APcQPd676v4dk9jugTV1GTK9et//N67
        n6/XIeuOiXycHc+0OvVgNJ7gXBnlvz6672DsZUmJvRhPu3IRAqVx8bIQzg2HzobuOb2/m9
        u0DQh0SfHOB6vkc72pxxKqfn1iJbDII=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>

On Tue, Jun 07, 2022 at 10:43:35AM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> memory_cgrp_id is defined in "vmlinux.h" (generated from BTF) which is
> included through "bpf_iter.h". If the kernel is not compiled with
> CONFIG_MEMCG then this enum value will not be defined and the bpf prog
> should not compile.

Cool. Then it works as I would have expected.

Michal

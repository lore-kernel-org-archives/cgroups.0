From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last
 child is killed
Date: Mon, 4 Apr 2022 07:37:24 -1000
Message-ID: <Ykss1N/VYX7femqw@slm.duckdns.org>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GF6jYnbv+1XzUXRiGnhvotzYBkOK/c7/Q8J5sZsBF/I=;
        b=NMBYADdu0/CesKqHTLEl52yzW4yrtN8zu7Y7cc+5VzNIEomJlvDWGHG1C0qoy1lwLj
         ncb1Ec9VBU27yDfmdH0eFLwFs6g3KWejO19Ptfi+s92r1Y4IeCUYyxuiGS1eGBKsHnHm
         6xaxAA9nYogWlYhOKKxqb/tc+bU68zDVnK4MgF98bjAbi8CFe7hEjYKOSNBQKZSAjzqt
         M1rQZfeFWzlbSlReJ2801hwI9WOJSeNmfEOloxqbQ0YuhcMlpmp9s45vg/zanmaIXz+Y
         x64Kk+bocsKiVr3v4YCkg9clHIkO4cTMTjIFORyBh7hu1BH7r1rtZV8d5AQSIQ5qJQpP
         0kSA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220404142535.145975-1-minhquangbui99@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hello,

On Mon, Apr 04, 2022 at 09:25:34PM +0700, Bui Quang Minh wrote:
> When umounting a cgroup controller, in case the controller has no children,
> the initial ref will be dropped in cgroup_kill_sb. In cgroup_rmdir path,
> the controller is deleted from the parent's children list in
> css_release_work_fn, which is run on a kernel worker.
> 
> With this simple script
> 
> 	#!/bin/sh
> 
> 	mount -t cgroup -o none,name=test test ./tmp
> 	mkdir -p ./tmp/abc
> 
> 	rmdir ./tmp/abc
> 	umount ./tmp
> 
> 	sleep 5
> 	cat /proc/self/cgroup
> 
> The rmdir will remove the last child and umount is expected to kill the
> parent controller. However, when running the above script, we may get
> 
> 	1:name=test:/

First of all, remounting after active use isn't a well-supported use case as
documented in the admin doc. The problem is that there's no finite time
horizon around when all the references are gonna go away - some references
may be held in cache which may not be released unless certain conditions are
met. So, while changing hierarchy configuration is useful for system setup,
development and debugging, for production use, it's a boot time
configuration mechanism.

> This shows that the parent controller has not been killed. The reason is
> after rmdir is completed, it is not guaranteed that the parent's children
> list is empty as css_release_work_fn is deferred to run on a worker. In
> case cgroup_kill_sb is run before that work, it does not drop the initial
> ref. Later in the worker, it just removes the child from the list without
> checking the list is empty to kill the parent controller. As a result, the
> parent controller still has the initial ref but without any logical refs
> (children ref, mount ref).
> 
> This commit adds a free parent controller path into the worker function to
> free up the parent controller when the last child is killed.

And the suggested behavior doesn't make much sense to me. It doesn't
actually solve the underlying problem but instead always make css
destructions recursive which can lead to surprises for normal use cases.

Thanks.

-- 
tejun

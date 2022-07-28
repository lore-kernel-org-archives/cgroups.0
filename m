From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v5 2/8] cgroup: enable cgroup_get_from_file() on
 cgroup1
Date: Thu, 28 Jul 2022 06:51:38 -1000
Message-ID: <YuK+monxlKfeZmQb@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=g9oYMpODJJiPiB2rG5r6ze/G4kA+eKDoO8ibYbMUthA=;
        b=nHorLRBiYzmmSktLnl0atkrBfVHNyyqWryD458vytfEJBaXVXMMcX4m2rfOoLOYOrO
         7CmpGdfiijs8RUe6Kt411Sd+TehxZvLZPuopvtDJcnxLtxO0mXnuT7djug52tPwPqGRX
         Ooj8+29eag0pUpvI6EPOcZ8wta+4mRAuOtEeeVDMJ3Mnqalmpm3pFskgMG1ZDFvrHst9
         9JoL9omKy7Omv3IUkHczcAavUUQRTv+M9WLWQj3LUaGkJ1txxRzw3RRmfaDGEIPs+rmB
         M7nSG5K3BGew/DWOdRVMVQ7vvHQ55Qt2n8sXLH3nzdvqqjOHnGtwn55e1qCsB9UABkb7
         Bq6Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>

On Fri, Jul 22, 2022 at 05:48:23PM +0000, Yosry Ahmed wrote:
> cgroup_get_from_file() currently fails with -EBADF if called on cgroup
> v1. However, the current implementation works on cgroup v1 as well, so
> the restriction is unnecessary.
> 
> This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
> the only thing stopping bpf cgroup_iter from supporting cgroup v1.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

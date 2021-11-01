From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: bpf: Move wrapper for __cgroup_bpf_*() to
 kernel/bpf/cgroup.c
Date: Mon, 1 Nov 2021 06:50:23 -1000
Message-ID: <YYAaz469VgwskHAq@slm.duckdns.org>
References: <20211029023906.245294-1-hefengqing@huawei.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1lQPvAS9D0YptMbqbx4CESL2hczonDYMGmutZeU63Qs=;
        b=Eu2gvCSrbOfvqQrgUNJpA4aXVLITzo0Rr5s2KHm4lkO4g+GGoqlRJzULM6xhsZVatz
         /Ytrzcvgy0GStGdUWlFk2Dwqpmh5BeztdMWD3Min37Qb4AvvzT1Nx2GAqaFZYhfubv4u
         GJzMqLVblF+R1GsAgMoj8pCPSE/Y+mVLDpNicX7YilRhxzm7+p5AzbjZvSge/1T8zUy/
         /JCxUj30QQeKvTc+VanMVi7ZLme1zOy061siPLUb+FrOJWo2gbyUiuBZl6yUIJvXU8y5
         +kPewJ1v5DxcEKS8vPINbiOyJb9+BrVNTs71KtbSmjb525fEdrSBOSkwAeQIDFtjx7gV
         hzgQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211029023906.245294-1-hefengqing@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: He Fengqing <hefengqing@huawei.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org

On Fri, Oct 29, 2021 at 02:39:06AM +0000, He Fengqing wrote:
> In commit 324bda9e6c5a("bpf: multi program support for cgroup+bpf")
> cgroup_bpf_*() called from kernel/bpf/syscall.c, but now they are only
> used in kernel/bpf/cgroup.c, so move these function to
> kernel/bpf/cgroup.c, like cgroup_bpf_replace().
> 
> Signed-off-by: He Fengqing <hefengqing@huawei.com>

Applied to cgroup/for-5.16.

Thanks.

-- 
tejun

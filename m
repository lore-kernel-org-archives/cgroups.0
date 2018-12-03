From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] cpuset: Remove set but not used variable 'cs'
Date: Mon, 3 Dec 2018 08:25:55 -0800
Message-ID: <20181203162555.GM2509588@devbig004.ftw2.facebook.com>
References: <1543633976-183380-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7Bsr4wedVD9JxukZDVeRReP8kYGIjt+Mgx/noLT6+wk=;
        b=OfU4f2K4/+i0w36IQJ4ER9JlDdl0Amu+6Fi8sfliIUvurK/k311bGtZhBim0ZwLTCF
         dDY0iqwW9W1euaFaByK2cowZhCEfNAWI15ZpZSDtRj3Hg764CmFUFhvskg636alCV0AF
         SpDdPkRpqp/qVmFfJTW2ngefrjXvIPSk+ctflhGUWpQWAJe6sQluHFg3LQvHub0wiS3B
         fnSo9RV93Vbza0qST2/+mzcO9CWsCEhIs9HF4UcIs9QIjDFO1q4EA8Pvrd86kgvRjAe9
         dGg+B/ooaqL9yg0za2fx5hw5HrRp8pNsdCgdps+yKVl57zSm8UU6c8Ce3PsadBJy1CcY
         qNHg==
Content-Disposition: inline
In-Reply-To: <1543633976-183380-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: YueHaibing <yuehaibing@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>, mingo@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, Dec 01, 2018 at 03:12:56AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> kernel/cgroup/cpuset.c: In function 'cpuset_cancel_attach':
> kernel/cgroup/cpuset.c:2167:17: warning:
>  variable 'cs' set but not used [-Wunused-but-set-variable]
> 
> It never used since introduction in commit 1f7dd3e5a6e4 ("cgroup: fix handling
> of multi-destination migration from subtree_control enabling")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to cgroup/for-4.21.

Thanks.

-- 
tejun

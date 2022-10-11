From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup
 counting
Date: Tue, 11 Oct 2022 06:53:43 -1000
Message-ID: <Y0Wfl88objrECjSo@slm.duckdns.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
 <20221011052808.282394-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wl7v0z/p2+wB3apqHXeEZNHFFTX3kIYffMColIWffT4=;
        b=fe9y9dV32MzYVl0l8UVUS8Nj2Bn70r5r10DWr7jOsP0TeSUOxZa+q76FX1JAVBQx9A
         hTfwFLFpIZoms5zYBD+LZIRt2hQyqBNFctK7hSdkYml+sHmni/CuBHZs2Ywuk3GXMtu+
         4ZCQ1KznO3DwI1RWztd9HrO7W4wV2BYgGsd+ThrzhwHVy0wszz5wyd6u4T9MnSp5C3jt
         p58v8Rj31jStYBgi+gZxnp0MpIGMPmfLa9JIgfSel3+e0V1veCoP2iG+7EBat2nCyT0c
         nPadT3RqSqvFqGN5xlcgP9v19d0kVjfZTUxj3ME9IU6wKL14bhjgh8CIgtIPQsHY3HZe
         xzEg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221011052808.282394-1-namhyung@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>

On Mon, Oct 10, 2022 at 10:28:08PM -0700, Namhyung Kim wrote:
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.
> 
> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Applied to cgroup/for-6.1-fixes.

Thanks.

-- 
tejun

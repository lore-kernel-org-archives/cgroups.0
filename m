From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/5] cgroup: Enable
 task_under_cgroup_hierarchy() on cgroup1
Date: Mon, 11 Sep 2023 10:27:42 -1000
Message-ID: <ZP94Pqiz6PtUy_Ww@mtj.duckdns.org>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <20230903142800.3870-2-laoar.shao@gmail.com>
 <ZPjdc3IwX9gjXk_F@slm.duckdns.org>
 <CALOAHbA7gDFh5Bsr_99-rBa3h9dZw6ntF_+RxTjfK3yQXpYEFA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf+bounces-9690-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694464064; x=1695068864; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNnl2EUxq2zaX99R7tX9+iE5LFUxTKUThPqOegYIa5s=;
        b=i/kVnY717xMDqCNn3WYnViiOjjcMpjRZ3YDH8aw7uIBl6563xM8YlJRH0UUKIkzMnh
         Oy+VVJSeiQF17nUJj0keyWSm0EKkS064TuM65gKaN7cKXk+eDxX/f/PE9Mq659URYrHe
         xEkgSLA+Tf51xJozMHikNt7u5vqNY0lfOICQhaWYHi88CvK60oWo1gb1ggG49IBsOrsr
         I97r7rWLJyrFw3VLiX6JAeIb06R0U6ZHAoeLgqgUXnnBKcVOSzk6a/eFE9JBnEkHhCIm
         Ag6sSmOSPB8eLx6IT2BYVgPBkXm6hcCKZiUdcyOdAfD8z8xzunnGYF+heAxUmZMeWs4d
         Xy1g==
Sender: Tejun Heo <htejun@gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbA7gDFh5Bsr_99-rBa3h9dZw6ntF_+RxTjfK3yQXpYEFA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, yosryahmed@google.com, cgroups@vger.kernel.org, bpf@vger.kernel.org

On Thu, Sep 07, 2023 at 11:05:07AM +0800, Yafang Shao wrote:
> The fd-based cgroup interface plays a crucial role in BPF programs,
> particularly in components such as cgroup_iter, bpf_cgrp_storage, and
> cgroup_array maps, as well as in the attachment and detachment of
> cgroups.

Yeah, I know they're used. It's just that they are inferior identifiers from
cgroup's POV as they are ephemeral, can't easily be transferred across
process boundaries or persisted beyond the lifetime of the fd-owing process
or the cgroups which are being pointed to.

Thanks.

-- 
tejun


From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Fri, 23 Sep 2022 17:22:51 -1000
Message-ID: <Yy54CwK84JY/o+Ci@slm.duckdns.org>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=pVZ/vufAufJqpHyXPbOtKj2Be+zfIdhN74kmWcGVahk=;
        b=MDlwjG16Co36ivQru9yTmqGAh8rRKn57/5yL7cl6/Y4KJK6KlPGTOSgnHKufNpTyTJ
         HF5+9/Z9psnwV/TYIRz/lPeiWCNFTZw855a8Iatejwa1KbFJAHciym7KrtWwGG26cNtY
         PI/gg4xkwmVdcKyQYpPyI4tSlUHbMk09fG4urMx6Re4sEiTKYhrGZECV1fvWiphnkhZm
         H+pGIlsXbC8b5GmdnHLAT+PzIbOjlqYq8fLlS67nIxlM88VwXqBLAIG3ETpkei8oLi2o
         vuKEnO5bqgThdWimNby2WYiK3CYiXc6sWGoV9N2dre373lqDLVb57wP5LhEn21nD1pBL
         8sNQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220922041435.709119-1-namhyung@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org

On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.
> 
> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
> Arnaldo, I think this should go through the cgroup tree since it depends
> on the earlier change there.  I don't think it'd conflict with other
> perf changes but please let me know if you see any trouble, thanks!

FWIW, looks fine to me and I'd be happy to route this through the cgroup
tree once it gets acked.

Thanks.

-- 
tejun

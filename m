From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 3/4] selftests: cgroup: fix alloc_anon_noexit()
 instantly freeing memory
Date: Mon, 25 Apr 2022 12:18:28 -0700 (PDT)
Message-ID: <f4aee758-c3b6-5ecb-a6e-10854a6490c4@google.com>
References: <20220425190040.2475377-1-yosryahmed@google.com> <20220425190040.2475377-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=EGrHpQVhbDy5vwZTzhNYK8llc1wnwOLu4wV+jMnBYL4=;
        b=CaYfhw1w1zCr1TOBWVJ1EiBOGCE0EIxtakImw+XtoEW5vt84RvGptzaYqbrW+innlW
         +Ku88xj7fg/qsjLAFb4N18ZNeray/Se5SHppUK9OjBl0eB9PHNzoDM2LRPg44ycpi2SJ
         bjNRJBVIyxkZFe/hZdtOD8UmyZHIiFgfVHm/j3HrJhsuwLJY0Ai5lzZzWklY6oXEwfoZ
         X7ZFQXszl2q6IOU7xV6dHIkOdnvDUSnutDtxLMhn9QduayUHVDPPQG/uD1X4QAkQnYHM
         EQ8yY7q6UexyNDJjNR/gFIP/T28r2m2aPkka5RBsU4xqbdHtPNIkvuAc9lKgiFIULCS0
         BWcQ==
In-Reply-To: <20220425190040.2475377-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

On Mon, 25 Apr 2022, Yosry Ahmed wrote:

> Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
> the allocated memory. alloc_anon_noexit() is usually used with
> cg_run_nowait() to run a process in the background that allocates
> memory. It makes sense for the background process to keep the memory
> allocated and not instantly free it (otherwise there is no point of
> running it in the background).
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Shakeel Butt <shakeelb@google.com>

Acked-by: David Rientjes <rientjes@google.com>

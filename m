From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v3 2/4] selftests: cgroup: return the errno of write() in
 cg_write() on failure
Date: Fri, 8 Apr 2022 18:33:14 -0700
Message-ID: <YlDiWvL9fo0OU4Ep@carbon.dhcp.thefacebook.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649468002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3iwAnic9ZaGk3gFDQP/Vj3cKdzxhwN/VVb3lVGd9RF0=;
        b=xtOHEkxMqZl4HOoB3ggEH7wb9JOUSzuKUEFWhvfRm8vvZUtmAR1tH9Q835aO1sIbjQknne
        3ZHK6azomPxS45CT7A26DaKWdQhMnBeskt/GdBIVzO82XMqe0jiyPB8UjDhcIK5eUlCDOK
        eHGWMNHjS37/F+aBBI4Ek8+/qIwLHO8=
Content-Disposition: inline
In-Reply-To: <20220408045743.1432968-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

On Fri, Apr 08, 2022 at 04:57:41AM +0000, Yosry Ahmed wrote:
> Currently, cg_write() returns 0 on success and -1 on failure. Modify it
> to return the errno of write() syscall when write() fails.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 32 +++++++++++---------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index dbaa7aabbb4a..3b6bb09985fa 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -38,23 +38,23 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
>  	return len;
>  }
>  
> -static ssize_t write_text(const char *path, char *buf, ssize_t len)
> +/*
> + * Returns:
> + *	success -> 0
> + *	open() failure -> -1

Is there a reason why we can't return errno in this case as well?
It would be more straightforward.

Otherwise the change looks good to me.

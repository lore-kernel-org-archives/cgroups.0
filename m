From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cgroup: check the return value of kstrdup()
Date: Sun, 12 Dec 2021 20:32:44 -0800
Message-ID: <43728285a4d61331f6ba64812c21346ab6b3b0b3.camel@perches.com>
References: <tencent_6410A5887F4B906866965C000E7A8AA3F007@qq.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <tencent_6410A5887F4B906866965C000E7A8AA3F007@qq.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Xiaoke Wang <xkernel.wang@foxmail.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2021-12-13 at 11:30 +0800, Xiaoke Wang wrote:
> kstrdup() returns NULL when some internal memory errors happen, it is
> better to check the return value of it so to catch the memory error in
> time.
[]
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
[]
> @@ -2228,6 +2228,9 @@ static int cpuset_init_fs_context(struct fs_context *fc)
>  	struct cgroup_fs_context *ctx;
>  	int err;
>  
> +	if (!agent)
> +		return -ENOMEM;
> +

Did you read all the other code that uses this?
Does it matter if it's NULL?
Why is it created with kstrdup in the first place?
Why should agent be anything other than const char *?
If it's const char * it shouldn't need to be used with
kstrdup/kfree.



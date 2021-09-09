From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Thu, 9 Sep 2021 16:37:20 +0200
Message-ID: <20210909143720.GA14709@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631198241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+IrKyLL/zCoxdFm0CBl46HK6iMLrxJ4/diWExUQinM=;
        b=bzekiy+7VzwGb33GpGxCKJ9ZVvVk7sTX5tGgg3I34wbOEq9faVv4OvGXwPkWEcmuh/VqRo
        01D3BhcaZPTBfTThaRVOkwtb3X74CIKhoS2R8ESgGG/YLwW1yt0w90mRSh8jTjG/ZQ6Zat
        DkQt5n5PgGRIy5gcmVwCtzWqS/k+7xA=
Content-Disposition: inline
In-Reply-To: <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 08, 2021 at 01:24:36PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This log provides less information, we can get more detailed failure
> records through
> misc.events, misc.events.local and misc.failcnt.
> From this, perhaps we can remove it.

I hope: a) it's not used widely, b) no-one relies on parsing the
message so this is an acceptable change.

> @@ -157,13 +157,6 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
>  		new_usage = atomic_long_add_return(amount, &res->usage);
>  		if (new_usage > READ_ONCE(res->max) ||
>  		    new_usage > READ_ONCE(misc_res_capacity[type])) {
> -			if (!res->failed) {
> -				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
> -					misc_res_name[type]);
> -				pr_cont_cgroup_path(i->css.cgroup);
> -				pr_cont("\n");
> -				res->failed = true;
> -			}

`i` is the misc_cg whose limit was hit. In a sense, I think the current
implementation of the log message (before your patch) is not as useful
as it could be. The logged message here should not refer to `i` but `cg`
(i.e. the cgroup where the actual chargee resides). It's basically the
idea from [1].

So there could be two type of events (not referring to the v1-specific
failcnt):
- max - number of times the cgroup's misc.max was hit,
- fail - number of times operation failed (rejected) in the cgroup.

The former would tell you which limit is probably set too low, the
latter would capture which cgroup workload is affected. (The difference
would become apparent with >1 level deep hierarchies.)

Regards,
Michal

[1] https://lore.kernel.org/lkml/20191202191100.GF16681-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org/


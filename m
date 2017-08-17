From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Thu, 17 Aug 2017 13:07:41 +0100
Message-ID: <20170817120741.GA22854@castle.DHCP.thefacebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=8rw7q5Oqfx3bk88l640AB76as72xcDUkMeqh0ByZf78=;
 b=UfbcNVcrloVEWturW8w4qwFbnXS2uUE6VRYT49GG+islVUuFfI+U6sOU2gx5OW7KmsIo
 fOMQiSZryNW4HMov8UcRRPNBdMZ4qmhco7ehY26nPQTp3w1WQQ6+cDbJvhciRQDlCJce
 vpIBd5j2ROUGthVbQTaIhiZEGCBCF/RXZ20= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8rw7q5Oqfx3bk88l640AB76as72xcDUkMeqh0ByZf78=;
 b=e4FQvTSJspv0jaVKWiBZe+znIsuOmjGaMECOO30FmJpl3jE8zbEWLWl1lnty7WbXhRvYnrfSjvgDzjhBJhQ5zu8yM6LcBb99x8uVZzR9jviaP+D9Q2BbCXZ9UwdMD+j/gLwfQW6mhmg8y1vxi48pFggftH2G2vUregijxWMRTrs=
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-4-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

Hi Tejun!

On Fri, Aug 11, 2017 at 09:37:54AM -0700, Tejun Heo wrote:
> In cgroup1, while cpuacct isn't actually controlling any resources, it
> is a separate controller due to combinaton of two factors -

s/combinaton/combination

> @@ -4466,6 +4470,8 @@ static void css_free_work_fn(struct work_struct *work)
>  			 */
>  			cgroup_put(cgroup_parent(cgrp));
>  			kernfs_put(cgrp->kn);
> +			if (cgroup_on_dfl(cgrp))
> +				cgroup_stat_exit(cgrp);

It looks like this "if (cgroup_on_dfl(cgrp))" works here and further similar to
"#ifdef CGROUP_V2". I wonder, if it's better to move this check into the
calling function: cgroup_stat_exit() in this case.


> +void cgroup_stat_show_cputime(struct seq_file *seq, const char *prefix)
> +{

What are any other possible prefix values except "cpu."?

> +void __init cgroup_stat_boot(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		raw_spin_lock_init(per_cpu_ptr(&cgroup_cpu_stat_lock, cpu));
> +
> +	WARN_ON(cgroup_stat_init(&cgrp_dfl_root.cgrp));

I'm not sure WARN_ON() is enough here: if cgroup_stat_init() returned -ENOMEM,
the following OOPS is not avoidable, as you don't check cpu_stat pointer.
But it's very unlikely, of course.


Overall looks very good!

Thanks!

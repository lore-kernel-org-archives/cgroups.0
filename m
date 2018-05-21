From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] [RFC] bpf: tracing: new helper bpf_get_current_cgroup_ino
Date: Mon, 21 May 2018 09:26:11 -0700
Message-ID: <20180521162609.lpdrnozowmzdn57m@ast-mbp.dhcp.thefacebook.com>
References: <20180513173318.21680-1-alban@kinvolk.io>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ix86xOCR6KQ4XqpmZ++ajz7GemoCpT5tDtk4PL/yo9g=;
        b=pUU2RnhtmXb0DLZEjT5d/4aVJLCa2QgudKzFblawOz+bz3ssB7VmzoLJHSD8eHt2im
         zsBX6VylZBFGuxiCgUtdmKLg/0zekc5/VpR1hx5l6j8MksKbHhYyhzqyRzjRj0CGcuC0
         zp0hKXnza3ImOXc/w1d1JZ7Ef6k2xV/46c22T7WwwL774wBFyw7WUnHb5FiwI+k0kzn4
         kbZ+2UEp5baWV+dbAHrxwbz2hW6RSb2RlO0aY80uhdLxxK27IznsSEhtKbiFp8CTu2AW
         G4iE9G0GcjzKfJq37OpxHw9IGg6b5M0ECCs56j1ofFLhJfXSOSXH0XOh1HRw2erilrkm
         lklg==
Content-Disposition: inline
In-Reply-To: <20180513173318.21680-1-alban@kinvolk.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alban Crequy <alban.crequy@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, Alban Crequy <alban@kinvolk.io>, tj@kernel.org

On Sun, May 13, 2018 at 07:33:18PM +0200, Alban Crequy wrote:
>  
> +BPF_CALL_2(bpf_get_current_cgroup_ino, u32, hierarchy, u64, flags)
> +{
> +	// TODO: pick the correct hierarchy instead of the mem controller
> +	struct cgroup *cgrp = task_cgroup(current, memory_cgrp_id);
> +
> +	if (unlikely(!cgrp))
> +		return -EINVAL;
> +	if (unlikely(hierarchy))
> +		return -EINVAL;
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	return cgrp->kn->id.ino;

ino only is not enough to identify cgroup. It needs generation number too.
I don't quite see how hierarchy and flags can be used in the future.
Also why limit it to memcg?

How about something like this instead:

BPF_CALL_2(bpf_get_current_cgroup_id)
{
        struct cgroup *cgrp = task_dfl_cgroup(current);

        return cgrp->kn->id.id;
}
The user space can use fhandle api to get the same 64-bit id.


From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 27 Nov 2017 13:04:11 -0800
Message-ID: <20171127210411.GS983427@devbig577.frc2.facebook.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9dxEKdh2oiS4lcuU6vKXgy5CmK16fCWKUdPNjrqbYLY=;
        b=rkXawI4s97jqYl0/YfFXsm9T0/P2qIjWQrkSWDPvBLtHti2T5ytBLLcWieftT7zxir
         gr/Wb8VF39YlWd7YCHiyt6E2XKFLKfWGI6AsuAflNMXVay6APDPMBDmohOvhJ1YNQ5Iu
         Zbm8BbcKIzfLFTtTXYqRh35dqQoxDYzkQHsqojM7gvdLHY9Y0wLGqfwyHXMSv8GiYyNo
         ZN7n3dU+KsuhLfjJ3DVc/+4yAeRYa60ouHfXvBLFNuLb+brIBcLScogpJzrRCSZESf5G
         2HQCpy0TofhpVLmIG/b3cotFq2VUDJr8E6gXJAtfuJa9AfdvlLRebjCFafKp+9kigdNw
         UYmg==
Content-Disposition: inline
In-Reply-To: <1507324230-22996-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

Sorry about the long delay.

On Fri, Oct 06, 2017 at 05:10:30PM -0400, Waiman Long wrote:
> +Cpuset Interface Files
> +~~~~~~~~~~~~~~~~~~~~~~
> +
> +  cpuset.cpus
> +	A read-write multiple values file which exists on non-root
> +	cgroups.
> +
> +	It lists the CPUs allowed to be used by tasks within this
> +	cgroup.  The CPU numbers are comma-separated numbers or
> +	ranges.  For example:
> +
> +	  # cat cpuset.cpus
> +	  0-4,6,8-10
> +
> +	An empty value indicates that the cgroup is using the same
> +	setting as the nearest cgroup ancestor with a non-empty
> +	"cpuset.cpus" or all the available CPUs if none is found.
> +
> +	The value of "cpuset.cpus" stays constant until the next update
> +	and won't be affected by any CPU hotplug events.
> +
> +  cpuset.effective_cpus

Can we do cpuset.ecpus in the fashion of euid, egid..?

> +  cpuset.effective_mems

Ditto.

> +  cpuset.flags
> +	A read-write multiple values file which exists on non-root
> +	cgroups.
> +
> +	It lists the flags that are set (with a '+' prefix) and those
> +	that are not set (with a '-' prefix).	The currently supported
> +	flag is:
> +
> +	  mem_migrate
> +		When it is not set, an allocated memory page will
> +		stay in whatever node it was allocated independent
> +		of changes in "cpuset.mems".
> +
> +		When it is set, tasks with memory pages not in
> +		"cpuset.mems" will have those pages migrated over to
> +		memory nodes specified in "cpuset.mems".  Any changes
> +		to "cpuset.mems" will cause pages in nodes that are
> +		no longer valid to be migrated over to the newly
> +		valid nodes.

Let's start just with [e]cpus and [e]mems.  The flags interface looks
fine but the implementations of these features are really bad and
cgroup2 doesn't migrate resources for other controllers either anyway.

Thanks.

-- 
tejun

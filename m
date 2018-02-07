From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/7] cgroup: Allow drivers to store data
 associated with a cgroup
Date: Wed, 7 Feb 2018 14:11:57 -0800
Message-ID: <20180207221157.GJ695913@devbig577.frc2.facebook.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-2-matthew.d.roper@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DCCLm80TqOl2YcwDEv5qjWmjrrpzs1YPDKJu1QColGc=;
        b=T19Zh5pX5WA6ozxxJHiPUqnNCmNxhRbQTkAXx6lnYEQwTeCXewW2C6wq8JkKkCn+To
         kGIpZ6lPOavyjehE2WssAsusWebr2VRJ37XBwUpC8q3S9OSprhadMcPo5si+qHa4tGDB
         z4vmVJUPKx6pmNkYud+jVLgLGrLrAs1S/vAzl92wnbggFOUYnQUPv8tQeCaz3GoCcm16
         BMtQ+OWlDW/eubOPGkYwlaAc/xb+E0AkrtmjnCizd0+ayYJYvq1kFoBMY8BZ5hx3Sonf
         54XJXxPX5Rp6mh3RmVYgPZkfmaGGE3/VF65kHHL8AawhaMzjbl0PKJYAZf8qRJ+2Zk//
         4qDQ==
Content-Disposition: inline
In-Reply-To: <20180201195315.4956-2-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Feb 01, 2018 at 11:53:09AM -0800, Matt Roper wrote:
>  * Drivers may be built as modules (and unloaded/reloaded) which is not
>    something cgroup controllers support today.

As discussed in the other subthread, this shouldn't be a concern.

>  * Drivers may wish to provide their own interface to allow userspace to
>    adjust driver-specific settings (e.g., via a driver ioctl rather than
>    via the kernfs filesystem).
>  * A single driver may be managing multiple devices and wish to maintain
>    different driver-specific cgroup data for each.

If you look at io and rdma controllers, they already do this.

> Note that technically these interfaces aren't restricted to drivers
> (other non-driver parts of the kernel could make use of them as well).
> I expect drivers to be the primary consumers of this interface and
> couldn't think of a more appropriate generic name (the term "subsystem"
> would probably be more accurate, but that's already used by cgroup
> controllers).

Let's please not do "driver", it's really confusing.  Just coming up
with a made-up word would be fine as long as the connection can be
made and the word is easily identifiable.  e.g. cgroup cdata / pdata for
cgroup custom / priv data.

> +/*
> + * Driver-specific cgroup data.  Drivers should subclass this structure with
> + * their own fields for data that should be stored alongside individual
> + * cgroups.
> + */
> +struct cgroup_driver_data {
> +	/* Driver this data structure is associated with */
> +	struct cgroup_driver *drv;
> +
> +	/* Node in cgroup's data hashtable */
> +	struct hlist_node cgroupnode;
> +
> +	/* Node in driver's data list; used to cleanup on driver unload */
> +	struct list_head drivernode;
> +};
...
> +struct cgroup_driver {
> +	/* Functions this driver uses to manage its data */
> +	struct cgroup_driver_funcs *funcs;
> +
> +	/*
> +	 * List of driver-specific data structures that need to be cleaned up
> +	 * if driver is unloaded.
> +	 */
> +	struct list_head datalist;
> +};

It generally looks great but can we do something like the following in
terms of interface?

  struct cgroup_cdata {
	  const void *key;
	  void (*free)(struct cgroup_cdata *cdata);
	  /* whatever other necessary fields */
	  char data[];
  };

  int cgroup_cdata_install(struct cgroup *cgrp, struct cgroup_cdata *cdata);
  struct cgroup_cdata *cgroup_cdata_lookup(struct cgroup *cgrp, const void *key);
  int cgroup_cdata_free(struct cgroup *cgrp, const void *key);
  /* free is also automatically called when the cgroup is released */

And please use a separate lock or mutex for managing them.

Thanks.

-- 
tejun

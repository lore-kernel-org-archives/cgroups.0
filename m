From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup: rstat: support cgroup1
Date: Tue, 2 Feb 2021 17:16:49 -0800
Message-ID: <20210203011649.GD1812008@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zDRpj2EF0xCpbfhBFAq4gRCEHgVcpNC/vHwFLUaoGJg=;
 b=Jq+OZEwtwRPA8PW9PDphVMlRKHxvLrxVl6Pg0OdjaG6ymg3oixyEFU5hiyBqQ3qOR8cm
 IC+/BkihXC58TF5ipgUSi9lofqPKqGiojboHJe+QITUJV+RLxh+ECdYOXsucuIIvTLC6
 W5kxuzFuUq2WRYgRTodZkld6FgxuliRK/sw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDRpj2EF0xCpbfhBFAq4gRCEHgVcpNC/vHwFLUaoGJg=;
 b=SYG8cC5YC3M+x6tC+YdGqNWjTh+XX7wuyOXsepQ1qe8Dt5lfcJ5wvUX9gDHNjrE48MNjm4cuqRQsc95tZvVoQ1Py0eL5Te74iRLUPLDR+3zFXjJGqV1adf5bYyW/80cOlBRDYaaqwLRWtTagYU+DATG0K7kZgFd2lmLcIzskKK4=
Content-Disposition: inline
In-Reply-To: <20210202184746.119084-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 01:47:43PM -0500, Johannes Weiner wrote:
> Rstat currently only supports the default hierarchy in cgroup2. In
> order to replace memcg's private stats infrastructure - used in both
> cgroup1 and cgroup2 - with rstat, the latter needs to support cgroup1.
> 
> The initialization and destruction callbacks for regular cgroups are
> already in place. Remove the cgroup_on_dfl() guards to handle cgroup1.
> 
> The initialization of the root cgroup is currently hardcoded to only
> handle cgrp_dfl_root.cgrp. Move those callbacks to cgroup_setup_root()
> and cgroup_destroy_root() to handle the default root as well as the
> various cgroup1 roots we may set up during mounting.
> 
> The linking of css to cgroups happens in code shared between cgroup1
> and cgroup2 as well. Simply remove the cgroup_on_dfl() guard.
> 
> Linkage of the root css to the root cgroup is a bit trickier: per
> default, the root css of a subsystem controller belongs to the default
> hierarchy (i.e. the cgroup2 root). When a controller is mounted in its
> cgroup1 version, the root css is stolen and moved to the cgroup1 root;
> on unmount, the css moves back to the default hierarchy. Annotate
> rebind_subsystems() to move the root css linkage along between roots.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

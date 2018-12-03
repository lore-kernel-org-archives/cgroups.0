From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v4 7/7] cgroup: document cgroup v2 freezer interface
Date: Mon, 3 Dec 2018 08:21:23 +0200
Message-ID: <20181203062123.GE6959@rapoport-lnx>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-8-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130234745.6756-8-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Nov 30, 2018 at 03:47:45PM -0800, Roman Gushchin wrote:
> Describe cgroup v2 freezer interface in the cgroup v2 admin guide.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Cc: kernel-team@fb.com

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  Documentation/admin-guide/cgroup-v2.rst | 27 +++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 07e06136a550..f8335e26b362 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -864,6 +864,8 @@ All cgroup core files are prefixed with "cgroup."
>  	  populated
>  		1 if the cgroup or its descendants contains any live
>  		processes; otherwise, 0.
> +	  frozen
> +		1 if the cgroup is frozen; otherwise, 0.
> 
>    cgroup.max.descendants
>  	A read-write single value files.  The default is "max".
> @@ -897,6 +899,31 @@ All cgroup core files are prefixed with "cgroup."
>  		A dying cgroup can consume system resources not exceeding
>  		limits, which were active at the moment of cgroup deletion.
> 
> +  cgroup.freeze
> +	A read-write single value file which exists on non-root cgroups.
> +	Allowed values are "0" and "1". The default is "0".
> +
> +	Writing "1" to the file causes freezing of the cgroup and all
> +	descendant cgroups. This means that all belonging processes will
> +	be stopped and will not run until the cgroup will be explicitly
> +	unfrozen. Freezing of the cgroup may take some time; when this action
> +	is completed, the "frozen" value in the cgroup.events control file
> +	will be updated to "1" and the corresponding notification will be
> +	issued.
> +
> +	A cgroup can be frozen either by its own settings, or by settings
> +	of any ancestor cgroups. If any of ancestor cgroups is frozen, the
> +	cgroup will remain frozen.
> +
> +	Processes in the frozen cgroup can be killed by a fatal signal.
> +	They also can enter and leave a frozen cgroup: either by an explicit
> +	move by a user, or if freezing of the cgroup races with fork().
> +	If a process is moved to a frozen cgroup, it stops. If a process is
> +	moved out of a frozen cgroup, it becomes running.
> +
> +	Frozen status of a cgroup doesn't affect any cgroup tree operations:
> +	it's possible to delete a frozen (and empty) cgroup, as well as
> +	create new sub-cgroups.
> 
>  Controllers
>  ===========
> -- 
> 2.17.2
> 

-- 
Sincerely yours,
Mike.


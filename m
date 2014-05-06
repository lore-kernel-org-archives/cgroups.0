From: Aristeu Rozanski <arozansk@redhat.com>
Subject: Re: [PATCH 2/5] cgroup: replace cftype->write_string() with
 cftype->write()
Date: Tue, 6 May 2014 08:54:24 -0400
Message-ID: <20140506125423.GT29214@redhat.com>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
 <1399380266-3324-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1399380266-3324-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz

On Tue, May 06, 2014 at 08:44:23AM -0400, Tejun Heo wrote:
> Convert all cftype->write_string() users to the new cftype->write()
> which maps directly to kernfs write operation and has full access to
> kernfs and cgroup contexts.  The conversions are mostly mechanical.
> 
> * @css and @cft are accessed using of_css() and of_cft() accessors
>   respectively instead of being specified as arguments.
> 
> * Should return @nbytes on success instead of 0.
> 
> * @buf is not trimmed automatically.  Trim if necessary.  Note that
>   blkcg doesn't need this as blkg_conf_prep() can already handle
>   whitespaces.
> 
> cftype->write_string() has no user left after the conversions and
> removed.
> 
> While at it, remove unnecessary local variable @p in
> cgroup_subtree_control_write() and stale comment about
> CGROUP_LOCAL_BUFFER_SIZE in cgroup_freezer.c.
> 
> This patch doesn't introduce any visible behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Aristeu Rozanski <arozansk@redhat.com>
> ---
>  block/blk-throttle.c      | 32 ++++++++++++++++----------------
>  block/cfq-iosched.c       | 28 ++++++++++++++--------------
>  include/linux/cgroup.h    | 10 +---------
>  kernel/cgroup.c           | 38 +++++++++++++++++++-------------------
>  kernel/cgroup_freezer.c   | 20 +++++++++-----------
>  kernel/cpuset.c           | 16 +++++++++-------
>  mm/hugetlb_cgroup.c       | 17 +++++++++--------
>  mm/memcontrol.c           | 46 +++++++++++++++++++++++++---------------------
>  net/ipv4/tcp_memcontrol.c | 16 +++++++++-------
>  security/device_cgroup.c  | 14 +++++++-------
>  10 files changed, 118 insertions(+), 119 deletions(-)

(...)

> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 8365909..82d6b4f 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -651,27 +651,27 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	return rc;
>  }
>  
> -static int devcgroup_access_write(struct cgroup_subsys_state *css,
> -				  struct cftype *cft, char *buffer)
> +static ssize_t devcgroup_access_write(struct kernfs_open_file *of,
> +				      char *buf, size_t nbytes, loff_t off)
>  {
>  	int retval;
>  
>  	mutex_lock(&devcgroup_mutex);
> -	retval = devcgroup_update_access(css_to_devcgroup(css),
> -					 cft->private, buffer);
> +	retval = devcgroup_update_access(css_to_devcgroup(of_css(of)),
> +					 of_cft(of)->private, strstrip(buf));
>  	mutex_unlock(&devcgroup_mutex);
> -	return retval;
> +	return retval ?: nbytes;
>  }
>  
>  static struct cftype dev_cgroup_files[] = {
>  	{
>  		.name = "allow",
> -		.write_string  = devcgroup_access_write,
> +		.write = devcgroup_access_write,
>  		.private = DEVCG_ALLOW,
>  	},
>  	{
>  		.name = "deny",
> -		.write_string = devcgroup_access_write,
> +		.write = devcgroup_access_write,
>  		.private = DEVCG_DENY,
>  	},
>  	{

for the device_cgroup part
Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

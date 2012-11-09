From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
Date: Fri, 9 Nov 2012 17:09:41 +0800
Message-ID: <509CC855.4070203@huawei.com>
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121108190715.GD9672@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121108190715.GD9672@htj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: mhocko@suse.cz, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>

On 2012/11/9 3:07, Tejun Heo wrote:
> Subject: cgroup: add cgroup_subsys->post_create()
> 
> Currently, there's no way for a controller to find out whether a new
> cgroup finished all ->create() allocatinos successfully and is
> considered "live" by cgroup.
> 
> This becomes a problem later when we add generic descendants walking
> to cgroup which can be used by controllers as controllers don't have a
> synchronization point where it can synchronize against new cgroups
> appearing in such walks.
> 
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
> 
> When used in combination with the to-be-added generic descendant
> iterators, ->post_create() can be used to implement reliable state
> inheritance.  It will be explained with the descendant iterators.
> 
> v2: Added a paragraph about its future use w/ descendant iterators per
>     Michal.
> 
> v3: Forgot to add ->post_create() invocation to cgroup_load_subsys().
>     Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>

Li Zefan <lizefan@huawei.com


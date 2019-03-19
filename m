From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] device_cgroup: fix RCU imbalance in error case
Date: Tue, 19 Mar 2019 09:33:16 +0100
Message-ID: <20190319083316.GQ8924@dhcp22.suse.cz>
References: <20190319013659.86199-1-jannh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319013659.86199-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>, "Serge E . Hallyn" <serge.hallyn@ubuntu.com>, cgroups@vger.kernel.org

On Tue 19-03-19 02:36:59, Jann Horn wrote:
> When dev_exception_add() returns an error (due to a failed memory
> allocation), make sure that we move the RCU preemption count back to where
> it was before we were called. We dropped the RCU read lock inside the loop
> body, so we can't just "break".
> 
> sparse complains about this, too:
> 
> $ make -s C=2 security/device_cgroup.o
> ./include/linux/rcupdate.h:647:9: warning: context imbalance in
> 'propagate_exception' - unexpected unlock
> 
> Fixes: d591fb56618f ("device_cgroup: simplify cgroup tree walk in propagate_exception()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jann Horn <jannh@google.com>

FWIW looks good to me.
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
> Compile-tested only.
> 
> I'm not entirely sure who's supposed to be the maintainer for this thing.
> The sign-offs on the commits to this file come from Tejun, but MAINTAINERS
> claims it's part of security/, so I'm just sending this to both the
> security folks and the cgroup folks, you can figure out whose tree you want
> to take this through. :P
> If the cgroup folks feel responsible for this file, maybe you could fix up
> MAINTAINERS?
> 
>  security/device_cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index cd97929fac66..dc28914fa72e 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -560,7 +560,7 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
>  		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
>  			rc = dev_exception_add(devcg, ex);
>  			if (rc)
> -				break;
> +				return rc;
>  		} else {
>  			/*
>  			 * in the other possible cases:
> -- 
> 2.21.0.225.g810b269d1ac-goog

-- 
Michal Hocko
SUSE Labs

From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: clean up the kernel configuration menu
 nomenclature
Date: Fri, 18 Dec 2015 10:23:03 +0800
Message-ID: <56736E07.4000300@huawei.com>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
 <1450390797-4748-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450390797-4748-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2015/12/18 6:19, Johannes Weiner wrote:
> The config options for the different cgroup controllers use various
> terms: resource controller, cgroup subsystem, etc. Simplify this to
> "controller", which is clear enough in the cgroup context.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>   init/Kconfig | 65 ++++++++++++++++++++++++------------------------------------
>   1 file changed, 26 insertions(+), 39 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 16840b4..ed324f5 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -958,23 +958,22 @@ menuconfig CGROUPS
>   if CGROUPS
>
>   config CGROUP_DEBUG
> -	bool "Example debug cgroup subsystem"
> +	bool "Example controller"

But not all cgroup subsystems are controllers, which are debug, perf and
cpuacct. I'm fine the other changes.

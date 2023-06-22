From: Steven Price <steven.price-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 22 Jun 2023 11:11:42 +0100
Message-ID: <726aae97-755d-9806-11d4-2fb21aa93428@arm.com>
References: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-GB
In-Reply-To: <ZIpm3pcs3iCP9UaR@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On 15/06/2023 02:18, Gustavo A. R. Silva wrote:
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 
> These changes are based on commit d20d30ebb199 ("cgroup: Avoid compiler
> warnings with no subsystems").
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index cd497b90e11a..1ee76e62eb98 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1200,6 +1200,9 @@ static struct css_set *find_css_set(struct css_set *old_cset,
>  	unsigned long key;
>  	int ssid;
>  
> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
> +		return NULL;
> +
>  	lockdep_assert_held(&cgroup_mutex);
>  
>  	/* First see if we already have a cgroup group that matches
> @@ -6045,6 +6048,9 @@ int __init cgroup_init(void)
>  	struct cgroup_subsys *ss;
>  	int ssid;
>  
> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
> +		return -EINVAL;
> +
>  	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
>  	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
>  	BUG_ON(cgroup_init_cftypes(NULL, cgroup_psi_files));

This change (which landed in linux-next) causes a boot failure on my
(arm32) board because the cgroup filesystem isn't created which upsets
systemd:

[   11.474767] systemd[1]: Failed to mount tmpfs at /sys/fs/cgroup: No such file or directory
[   11.489933] systemd[1]: Failed to mount cgroup at /sys/fs/cgroup/systemd: No such file or directory
[!!!!!!] Failed to mount API filesystems.

Reverting this commit on the head of linux-next gets the board working
again.

Thanks,

Steve


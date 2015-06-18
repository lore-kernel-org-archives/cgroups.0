From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] selinux: enable setting security context in cgroup
Date: Thu, 18 Jun 2015 12:43:57 -0400
Message-ID: <5582F54D.6090708@tycho.nsa.gov>
References: <1434645186-4130-1-git-send-email-alexey.kodanev@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1434645186-4130-1-git-send-email-alexey.kodanev@oracle.com>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexey Kodanev <alexey.kodanev@oracle.com>, linux-security-module@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>, cgroups@vger.kernel.org, Vasily Isaenko <vasily.isaenko@oracle.com>

On 06/18/2015 12:33 PM, Alexey Kodanev wrote:
> cgroup uses kernfs that has 'security.*' setxattr handler. But setxattr
> with 'security.selinux' name returns EOPNOTSUPP, i.e. SBLABEL_MNT
> not set on the cgroup filesystem.
> 
> Fix it by adding 'cgroup' type to genfs special handling list.
> 
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  security/selinux/hooks.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 7dade28..91276c2 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -404,6 +404,7 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
>  		sbsec->behavior == SECURITY_FS_USE_TRANS ||
>  		sbsec->behavior == SECURITY_FS_USE_TASK ||
>  		/* Special handling. Genfs but also in-core setxattr handler */
> +		!strcmp(sb->s_type->name, "cgroup") ||
>  		!strcmp(sb->s_type->name, "sysfs") ||
>  		!strcmp(sb->s_type->name, "pstore") ||
>  		!strcmp(sb->s_type->name, "debugfs") ||
> 


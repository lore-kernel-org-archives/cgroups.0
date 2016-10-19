From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [RFC v3 06/22] landlock: Add LSM hooks
Date: Wed, 19 Oct 2016 17:19:06 +0200
Message-ID: <20161019151906.GC22003@pox.localdomain>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-7-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-4949-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suug-ch.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=oCS0uk0AAhkOR5/UYaqYkSLT3IPTpGgBLWOR6N3dqAc=;
        b=n8ndafIoKGG3wGcUVENxkpzhRDg2v5jAblFgEeCJCvsZHVp8z+CwdJKInTOZvYp4jF
         M2knn20zRXBhvMZfeN+TbStGzYLjjiSWmkAo7yEqEE36WT4H1OWz0UyCUa8edeQkMOMb
         cWp1xL+7z1ey8HrGyzvrvM5rr1C3OZ5rrpt+CEwW1gnY802AkuuAwk5fDuUpHqcuNoyU
         jbBgeo1gyHZy8hONaRz91vWL/7Qvj68ruPVXAYu6c2pUEhWERkCgrHGo2sUJBAgFnM7P
         ykqrNRZoLtQa/oNMLpJAGrr+a0zZ6cRxsAgtN4JTWxt/17NWRbVBVmr+irGxl/6vJG0P
         n9fA==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-7-mic@digikod.net>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org

On 09/14/16 at 09:23am, Micka=EBl Sala=FCn wrote:
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9aa01d9d3d80..36c3e482239c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -85,6 +85,8 @@ enum bpf_arg_type {
> =20
>  	ARG_PTR_TO_CTX,		/* pointer to context */
>  	ARG_ANYTHING,		/* any (initialized) argument is ok */
> +
> +	ARG_PTR_TO_STRUCT_FILE,		/* pointer to struct file */

This should go into patch 7 I guess?

> +void __init landlock_add_hooks(void)
> +{
> +	pr_info("landlock: Becoming ready for sandboxing\n");
> +	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks));
> +}

Can we add the hooks when we load the first BPF program for a hook? That
would also allow to not make this conditional on a new config option
which all all distros have to enable anyway.

I would really like to see this patch split into the LSM part which
allows running BPF progs at LSM and your specific sandboxing use case
which requires the new BPF helpers, new reg type, etc.

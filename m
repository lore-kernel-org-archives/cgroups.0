From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] cgroup: cgroup namespace setns support
Date: Tue, 24 Nov 2015 11:52:51 -0500
Message-ID: <20151124165251.GQ17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-7-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JUh81PJREOmQdGF7hTwSsS18MrEhxWDLDq2UX2mc3ss=;
        b=yAKwgT1LkeiI+MYhHIC3rMWBGt6exPLzzHm8c0u2dnH0CE1AIGc6dICA+qBz7UEL9w
         EphRMkZyo5nrBOzxhY4B7tr+hbG+ivsX8dD8x9ypQWiLMHVOXcoH6H5NeQu6T83OOAop
         asHl/2A4/cDwPipJ9/giNtmV6d/62iwJW1+btXydOEjaY0aPjw5L0196XtC8di3TTPN7
         RWhDqQq2V0l8+1BiKtSGWMTukCPZWzgGT2EO6XSSmV02VcnTT398a7vTJun/77nfC7dc
         XvSO+a+/wfIb7HzRJ6Fvpf7wBxHgN6c/lzmNg8RiN9Y1HCOm7ctNBHVixJlEwbURA8Ff
         5Z4w==
Content-Disposition: inline
In-Reply-To: <1447703505-29672-7-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

On Mon, Nov 16, 2015 at 01:51:43PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> @@ -85,10 +85,27 @@ err_out:
>  	return ERR_PTR(err);
>  }
>  
> -static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
> +static inline struct cgroup_namespace *to_cg_ns(struct ns_common *ns) {
> +	return container_of(ns, struct cgroup_namespace, ns);
> +}

Heh, what's up with the formatting?  Please update the patches to
conform to Documentation/CodingStyle in general.

Thanks.

-- 
tejun

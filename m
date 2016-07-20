From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 2/3] cgroup: allow for unprivileged subtree management
Date: Wed, 20 Jul 2016 11:45:57 -0400
Message-ID: <20160720154557.GF4574@htj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-3-asarai@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nmm/Ki015oNYgZWnQwXjAh1PjbAFtuVNKZdz6LZ7qlg=;
        b=rMxZhuf1Z2Awf34ZBH//3plPGr1k1RWOh5UX8c8LURbK9P49A2jthxr8ZpTT67U5DB
         10453PK3tM6TsOYtrMwrjTsK0D/T86H4yTruHV0Xe+b9PhhLC5w1rS1gnYiy9iCLo72c
         nidEbcqQd8L8sWo+KGoUUWyu4E8cVEfJ9Lrf5EQJfuj7Hqzf2IUwgpLjuciaCOL5Z2sT
         uilSXAex81yNyIqk6dE2sdtN1xzc53WK4P3gbGsmIF0ELlTf5RBU61DECDUgclbEC6/i
         E3lvZ8y6wnx/5cX5pWc4gkSMYwlNSnGi0WCJti7fD2cVAB1IzvWnDdTpq49me0RILXPL
         MD3A==
Content-Disposition: inline
In-Reply-To: <20160718161816.13040-3-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, Aleksa.

On Tue, Jul 19, 2016 at 02:18:15AM +1000, Aleksa Sarai wrote:
> +static int cgroup_permission(struct inode *inode, struct kernfs_node *kn,
> +			     int mask)
> +{
> +	int ret;
> +	struct cgroup *cgroup;
> +	struct cgroup_namespace *cgroupns;
> +
> +	/*
> +	 * First, compute the generic_permission return value. In most cases
> +	 * this will succeed and we can also avoid duplicating this code.
> +	 */
> +
> +	cgroup = kn->priv;
> +	cgroup_get(cgroup);

This pattern which is repated for cgroupns doesn't make sense.  The
code is already assuming that the cgroup is safe to deref.  Getting
its reference doesn't do anything.  Getting it here would only make
sense if the pointer is passed to an asynchronous context.

Thanks.

-- 
tejun

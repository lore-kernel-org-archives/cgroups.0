From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 17/26] cgroup/misc: Add notifier block list support for
 css events
Date: Mon, 14 Nov 2022 12:42:19 -1000
Message-ID: <Y3LES3rUIZ/PtwzV@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-18-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pv0RF9FjcySyliu+qAVl2fypXUgmAr/MY6Cbxd80Sz8=;
        b=eSgJ8ipCFU8uWn7ioQiHixpjSI530v8dcOHQJaH+Il8EKjYSq/C3UntNbW9AWG1uyL
         5lnt+ZiHYIaprJAq+HQe5BOu2/dBE6/l58VWMvYmTsF1TUVN+So55HqBquzLN/NsvIG6
         TGNmqinUqbHSH0VYFFNRAOmTjw8BKJJ6TF+PUcyXcNJQxus/qIlKy2zhDLXwzBC5lut+
         jS3EpUsqjWgG/lq3fblL8cKjYPhnWZkrO9WBBZKXg6D1cF/NpIX9dRuT0Pm+JKISCGGk
         ZN0Dio+ukJxJAGGcrNIKHKzvMQO8ReBPY40POFPqNst/adBwLjl6Qh6UAMoI5y18zxb6
         ZuLA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-18-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Hello,

On Fri, Nov 11, 2022 at 10:35:22AM -0800, Kristen Carlson Accardi wrote:
> +/**
> + * register_misc_cg_notifier() - Register for css callback events
> + * @nb: notifier_block to register
> + *
> + * Context: Any context.
> + */
> +int register_misc_cg_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&misc_cg_notify_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(register_misc_cg_notifier);
> +
> +/**
> + * unregister_misc_cg_notifier() - unregister for css callback events
> + * @nb: notifier_block to unregister
> + *
> + * Context: Any context.
> + */
> +int unregister_misc_cg_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&misc_cg_notify_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(unregister_misc_cg_notifier);

So, I'm not necessarily against this but wonder whether it'd be more
straightforward to add sth like struct misc_res_ops which contains the
optional callbacks and then have an array of pointers to the structs which
are initialized / registered somehow. What do you think?

Thanks.

-- 
tejun

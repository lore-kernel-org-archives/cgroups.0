From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v6 2/6] cgroup: gpu: Add a cgroup controller for
 allocator attribution of GPU memory
Date: Wed, 4 May 2022 14:25:58 +0200
Message-ID: <20220504122558.GB24172@blackbody.suse.cz>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-3-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651667160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=doyRZ/aPo6CAu2aRJZdJIbiD5u5Ey0uZjhyvfP1Ctxg=;
        b=N2vaxZGJ2unb+3IDJGpPKSzFqAbVU0whcBJYvGepz19nZuYUtUZV1YeQwH/896HEErAkZE
        Y6ajefODov6DJ/roi62apFVoZZ+Qv0Mkw7J15GK+8M7slaceWBctJQU5sdF7elqYx4+hbf
        sd773fem46TOty3AXl7mg/7SEvNr6/U=
Content-Disposition: inline
In-Reply-To: <20220502231944.3891435-3-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, daniel-/w4YWyX8dFk@public.gmane.org, hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Mon, May 02, 2022 at 11:19:36PM +0000, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This patch adds APIs to:
> -allow a device to register for memory accounting using the GPU cgroup
> controller.
> -charge and uncharge allocated memory to a cgroup.

Is this API for separately built consumers?
The respective functions should be exported (EXPORT_SYMBOL_GPL) if I
haven't missed anything.

> +#ifdef CONFIG_CGROUP_GPU
> + /* The GPU cgroup controller data structure */
> +struct gpucg {
> +	struct cgroup_subsys_state css;
> +
> +	/* list of all resource pools that belong to this cgroup */
> +	struct list_head rpools;
> +};
> +
> +/* A named entity representing bucket of tracked memory. */
> +struct gpucg_bucket {
> +	/* list of various resource pools in various cgroups that the bucket is part of */
> +	struct list_head rpools;
> +
> +	/* list of all buckets registered for GPU cgroup accounting */
> +	struct list_head bucket_node;
> +
> +	/* string to be used as identifier for accounting and limit setting */
> +	const char *name;
> +};

Do these struct have to be defined "publicly"?
I.e. the driver code could just work with gpucg and gpucg_bucket
pointers.

> +int gpucg_register_bucket(struct gpucg_bucket *bucket, const char *name)

...and the registration function would return a pointer to newly
(internally) allocated gpucg_bucket.

Regards,
Michal

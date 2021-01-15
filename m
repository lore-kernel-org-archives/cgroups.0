From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Fri, 15 Jan 2021 15:59:25 -0500
Message-ID: <YAICLR8PBXxAcOMz@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ljcsEiTwVFy9/fEf7cwMkyA7thV1aii+KQVznxeDjsM=;
        b=BPbmAO0d2VW5YNWzjkrHt/PXcfpdUW3/1LwTgdr344QL/A3fRO/M3CYiTazM3UlT7h
         NMKhDvXYYwVtM+rLvoqz52hYpYcUVz9UepwZwtMHTyqDfg/lcFlpCj0SMZvrahYeIXHD
         pRKM/bx+f/MJTIpyXICeHTDaxvOwKPWPotCqE6mUn/oQTkGjBfwzF3O6hP+yEaDakjCi
         6s9e4UhrIkl0jUxYtVr+QZICcIjUoI+kP3hQdkkksF3M0HyHhFQV1qtmBLijaRcYbzq7
         YpGdfDsdTcK/gcL80BBhZ02vaeum/TTNMLa1M+ny4AZNDmuYHWshPglwce4Rk2uS8MuX
         A12w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210108012846.4134815-2-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 07, 2021 at 05:28:45PM -0800, Vipin Sharma wrote:
> 1. encrpytion_ids.sev.max
> 	Sets the maximum usage of SEV IDs in the cgroup.
> 2. encryption_ids.sev.current
> 	Current usage of SEV IDs in the cgroup and its children.
> 3. encryption_ids.sev.stat
> 	Shown only at the root cgroup. Displays total SEV IDs available
> 	on the platform and current usage count.

Sorry, should have raised these earlier:

* Can we shorten the name to encids?

* Why is .sev a separate namespace? Isn't the controller supposed to cover
  encryption ids across different implementations? It's not like multiple
  types of IDs can be in use on the same machine, right?

> Other ID types can be easily added in the controller in the same way.

I'm not sure this is necessarily a good thing.

> +/**
> + * enc_id_cg_uncharge_hierarchy() - Uncharge the enryption ID cgroup hierarchy.
> + * @start_cg: Starting cgroup.
> + * @stop_cg: cgroup at which uncharge stops.
> + * @type: type of encryption ID to uncharge.
> + * @amount: Charge amount.
> + *
> + * Uncharge the cgroup tree from the given start cgroup to the stop cgroup.
> + *
> + * Context: Any context. Expects enc_id_cg_lock to be held by the caller.
> + */
> +static void enc_id_cg_uncharge_hierarchy(struct encryption_id_cgroup *start_cg,
> +					 struct encryption_id_cgroup *stop_cg,
> +					 enum encryption_id_type type,
> +					 unsigned int amount)
> +{
> +	struct encryption_id_cgroup *i;
> +
> +	lockdep_assert_held(&enc_id_cg_lock);
> +
> +	for (i = start_cg; i != stop_cg; i = parent_enc(i)) {
> +		WARN_ON_ONCE(i->res[type].usage < amount);
> +		i->res[type].usage -= amount;
> +	}
> +	css_put(&start_cg->css);

I'm curious whether this is necessary given that a css can't be destroyed
while tasks are attached. Are there cases where this wouldn't hold true? If
so, it'd be great to have some comments on how that can happen.

> +/**
> + * enc_id_cg_max_write() - Update the maximum limit of the cgroup.
> + * @of: Handler for the file.
> + * @buf: Data from the user. It should be either "max", 0, or a positive
> + *	 integer.
> + * @nbytes: Number of bytes of the data.
> + * @off: Offset in the file.
> + *
> + * Uses cft->private value to determine for which enryption ID type results be
> + * shown.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + * Return:
> + * * >= 0 - Number of bytes processed in the input.
> + * * -EINVAL - If buf is not valid.
> + * * -ERANGE - If number is bigger than unsigned int capacity.
> + * * -EBUSY - If usage can become more than max limit.

The aboves are stale, right?

> +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> +{
> +	unsigned long flags;
> +	enum encryption_id_type type = seq_cft(sf)->private;
> +
> +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> +
> +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);

Dup with .current and no need to show total on every cgroup, right?

Thanks.

-- 
tejun

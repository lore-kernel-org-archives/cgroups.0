From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 1/2] cgroup: sev: Add misc cgroup controller
Date: Wed, 3 Mar 2021 10:42:37 -0500
Message-ID: <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=474jOip4IgCUoyMxBEribCWEBGxFGSV2OmSthT7tIzw=;
        b=OUl4a0iSBisVMbYesUskXLxC/LPLDhIN0Z0JGTf84f1GApfyQKw6BzripeCpctzhaH
         +D7phCtY7W74P4MAMDNeGvYAAtxOcvPJwTwYjkvlPb+txGb+DC6yw9LLjjgmdNwNaBLz
         T+iX1Z5f0zC8hh/Oq4MPpupIK8Xjsq53GLg0aO8HXh+mEfyHxI0LsJ3V1WVo9UY0nEtk
         0VvSkiHz7Limw2jEyntvTsr41cqWhO/K1Rrur6QvaBoUNUytNHeQY6W0T9h/gLj3Jcox
         6FVq2aCkhvKl8XALF/xuQlmwzULpBOvkkCmMpA80t6IHJ0shgNDsfE82JWH6mpsFuv8Q
         m9hA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210302081705.1990283-2-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 02, 2021 at 12:17:04AM -0800, Vipin Sharma wrote:
> +/**
> + * struct misc_res: Per cgroup per misc type resource
> + * @max: Maximum count of the resource.
> + * @usage: Current usage of the resource.
> + */
> +struct misc_res {
> +	unsigned int max;
> +	atomic_t usage;
> +};

Can we do 64bits so that something which counts memory can use this too?

> +/*
> + * Miscellaneous resources capacity for the entire machine. 0 capacity means
> + * resource is not initialized or not present in the host.
> + *
> + * root_cg.max and capacity are independent of each other. root_cg.max can be
> + * more than the actual capacity. We are using Limits resource distribution
> + * model of cgroup for miscellaneous controller. However, root_cg.current for a
> + * resource will never exceeds the resource capacity.
                                ^
                                typo

> +int misc_cg_set_capacity(enum misc_res_type type, unsigned int capacity)
> +{
> +	if (!valid_type(type))
> +		return -EINVAL;
> +
> +	for (;;) {
> +		int usage;
> +		unsigned int old;
> +
> +		/*
> +		 * Update the capacity while making sure that it's not below
> +		 * the concurrently-changing usage value.
> +		 *
> +		 * The xchg implies two full memory barriers before and after,
> +		 * so the read-swap-read is ordered and ensures coherency with
> +		 * misc_cg_try_charge(): that function modifies the usage
> +		 * before checking the capacity, so if it sees the old
> +		 * capacity, we see the modified usage and retry.
> +		 */
> +		usage = atomic_read(&root_cg.res[type].usage);
> +
> +		if (usage > capacity)
> +			return -EBUSY;

I'd rather go with allowing bringing down capacity below usage so that the
users can set it to a lower value to drain existing usages while denying new
ones. It's not like it's difficult to check the current total usage from the
caller side, so I'm not sure it's very useful to shift the condition check
here.

> +int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
> +		       unsigned int amount)
> +{
...
> +	for (i = cg; i; i = parent_misc(i)) {
> +		res = &i->res[type];
> +
> +		/*
> +		 * The atomic_long_add_return() implies a full memory barrier
> +		 * between incrementing the count and reading the capacity.
> +		 * When racing with misc_cg_set_capacity(), we either see the
> +		 * new capacity or the setter sees the counter has changed and
> +		 * retries.
> +		 */
> +		new_usage = atomic_add_return(amount, &res->usage);
> +		if (new_usage > res->max ||
> +		    new_usage > misc_res_capacity[type]) {
> +			pr_info("cgroup: charge rejected by misc controller for %s resource in ",
> +				misc_res_name[type]);
> +			pr_cont_cgroup_path(i->css.cgroup);
> +			pr_cont("\n");

Should have commented on this in the priv thread but don't print something
on every rejection. This often becomes a nuisance and can make an easy DoS
vector at worst. If you wanna do it, print it once per cgroup or sth like
that.

Otherwise, looks good to me.

Thanks.

-- 
tejun

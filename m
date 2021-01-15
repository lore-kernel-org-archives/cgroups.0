From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Fri, 15 Jan 2021 14:18:40 -0800
Message-ID: <YAIUwGUPDmYfUm/a@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lK6irOIZuEqc0zZFe+eyBQRg0ctV5nEW+XvBTkrNvKg=;
        b=at3c+r+iqECyp24pqx4JptLnOdrvWe9hS8lLSd/ZbOfo/J9YDXju5d5ikRzyPu6Pnh
         3LWU/Da1lR2ZP6ZC1rm4eyV/jn97tmRaAn4hWZDtgPbsthjMbmy1S8aZP8E3/qj5Q5Fe
         3tGiWAqj7oH525wRpVg3rIsRXg29OYyxAaHKSe6qOiSLivwUHgLuzfq+MLSTYg6AmmSz
         9QrJe7TThrxfWjtxfT93Sc6s2799TAMXNBdQz023ksijibSI65YPbpZFrSP1/lg0xGTI
         pvVTw3+PKC7QUzphRtzDOzB6ksqBE3q7mkxLY3ui37AifjWf4tzxXrZoVf899HdmKAjo
         R13g==
Content-Disposition: inline
In-Reply-To: <YAICLR8PBXxAcOMz@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 15, 2021 at 03:59:25PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 07, 2021 at 05:28:45PM -0800, Vipin Sharma wrote:
> > 1. encrpytion_ids.sev.max
> > 	Sets the maximum usage of SEV IDs in the cgroup.
> > 2. encryption_ids.sev.current
> > 	Current usage of SEV IDs in the cgroup and its children.
> > 3. encryption_ids.sev.stat
> > 	Shown only at the root cgroup. Displays total SEV IDs available
> > 	on the platform and current usage count.
> 
> Sorry, should have raised these earlier:
> 
> * Can we shorten the name to encids?

Sure.

> 
> * Why is .sev a separate namespace? Isn't the controller supposed to cover
>   encryption ids across different implementations? It's not like multiple
>   types of IDs can be in use on the same machine, right?
> 

On AMD platform we have two types SEV and SEV-ES which can exists
simultaneously and they have their own quota.

> > Other ID types can be easily added in the controller in the same way.
> 
> I'm not sure this is necessarily a good thing.

This is to just say that when Intel and PowerPC changes are ready it
won't be difficult for them to add their controller.

> 
> > +/**
> > + * enc_id_cg_uncharge_hierarchy() - Uncharge the enryption ID cgroup hierarchy.
> > + * @start_cg: Starting cgroup.
> > + * @stop_cg: cgroup at which uncharge stops.
> > + * @type: type of encryption ID to uncharge.
> > + * @amount: Charge amount.
> > + *
> > + * Uncharge the cgroup tree from the given start cgroup to the stop cgroup.
> > + *
> > + * Context: Any context. Expects enc_id_cg_lock to be held by the caller.
> > + */
> > +static void enc_id_cg_uncharge_hierarchy(struct encryption_id_cgroup *start_cg,
> > +					 struct encryption_id_cgroup *stop_cg,
> > +					 enum encryption_id_type type,
> > +					 unsigned int amount)
> > +{
> > +	struct encryption_id_cgroup *i;
> > +
> > +	lockdep_assert_held(&enc_id_cg_lock);
> > +
> > +	for (i = start_cg; i != stop_cg; i = parent_enc(i)) {
> > +		WARN_ON_ONCE(i->res[type].usage < amount);
> > +		i->res[type].usage -= amount;
> > +	}
> > +	css_put(&start_cg->css);
> 
> I'm curious whether this is necessary given that a css can't be destroyed
> while tasks are attached. Are there cases where this wouldn't hold true? If
> so, it'd be great to have some comments on how that can happen.

We are not moving charges when a task moves out. This can lead us to the
cases where all of the tasks in the cgroup have moved out but it
still has charges. In that scenarios cgroup can be deleted. Taking a
reference will make sure cgroup is atleast present internally.

Also, struct encryption_ic_cgroup has a reference to the cgroup which is
used during uncharge call to correctly identify from which cgroup charge
should be deducted.

> 
> > +/**
> > + * enc_id_cg_max_write() - Update the maximum limit of the cgroup.
> > + * @of: Handler for the file.
> > + * @buf: Data from the user. It should be either "max", 0, or a positive
> > + *	 integer.
> > + * @nbytes: Number of bytes of the data.
> > + * @off: Offset in the file.
> > + *
> > + * Uses cft->private value to determine for which enryption ID type results be
> > + * shown.
> > + *
> > + * Context: Any context. Takes and releases enc_id_cg_lock.
> > + * Return:
> > + * * >= 0 - Number of bytes processed in the input.
> > + * * -EINVAL - If buf is not valid.
> > + * * -ERANGE - If number is bigger than unsigned int capacity.
> > + * * -EBUSY - If usage can become more than max limit.
> 
> The aboves are stale, right?

-EBUSY is not valid anymore. We can now set max to be less than the usage. I
will remove it in the next patch.

> 
> > +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> > +{
> > +	unsigned long flags;
> > +	enum encryption_id_type type = seq_cft(sf)->private;
> > +
> > +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> > +
> > +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> > +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> 
> Dup with .current and no need to show total on every cgroup, right?

This is for the stat file which will only be seen in the root cgroup
directory.  It is to know overall picture for the resource, what is the
total capacity and what is the current usage. ".current" file is not
shown on the root cgroup.

This information is good for resource allocation in the cloud
infrastructure.

> 
> Thanks.
> 
> -- 
> tejun

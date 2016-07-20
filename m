From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v1 2/3] cgroup: allow for unprivileged subtree management
Date: Thu, 21 Jul 2016 08:59:12 +1000
Message-ID: <49c34e82-54a8-642d-18ab-1b876cbe709a@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-3-asarai@suse.de>
 <20160720154557.GF4574@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720154557.GF4574-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

>> +static int cgroup_permission(struct inode *inode, struct kernfs_node *kn,
>> +			     int mask)
>> +{
>> +	int ret;
>> +	struct cgroup *cgroup;
>> +	struct cgroup_namespace *cgroupns;
>> +
>> +	/*
>> +	 * First, compute the generic_permission return value. In most cases
>> +	 * this will succeed and we can also avoid duplicating this code.
>> +	 */
>> +
>> +	cgroup = kn->priv;
>> +	cgroup_get(cgroup);
>
> This pattern which is repated for cgroupns doesn't make sense.  The
> code is already assuming that the cgroup is safe to deref.  Getting
> its reference doesn't do anything.  Getting it here would only make
> sense if the pointer is passed to an asynchronous context.

I'll send out a fixed patchset once we figure out the 
cgroups_proc_write_permission() stuff.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 3/3] cgroupns: Only allow creation of hierarchies in the initial cgroup namespace
Date: Fri, 15 Jul 2016 06:16:02 -0500
Message-ID: <8760s72lu5.fsf@x220.int.ebiederm.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
	<87r3av32g1.fsf@x220.int.ebiederm.org>
	<20160715111659.GB3078@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160715111659.GB3078-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Fri, 15 Jul 2016 07:16:59 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hello, Eric.
>
> On Fri, Jul 15, 2016 at 12:17:18AM -0500, Eric W. Biederman wrote:
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index c99b0bcd2647..01f34edceb6b 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -2209,12 +2209,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>  		goto out_unlock;
>>  	}
>>  
>> -	/*
>> -	 * We know this subsystem has not yet been bound.  Users in a non-init
>> -	 * user namespace may only mount hierarchies with no bound subsystems,
>> -	 * i.e. 'none,name=user1'
>> -	 */
>> -	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
>> +	/* Hierarchies may only be created in the initial cgroup namespace. */
>> +	if (ns != &init_cgroup_ns) {
>
> Doesn't this allow any user in the init ns to create any hierarchies?

To perform the mount you must be ns_capable(ns->user_ns, CAP_SYS_ADMIN),
we check that at the top of cgroup_mount.

For init_cgroup_ns->user_ns == &init_user_ns.  Which means that when
ns == &init_cgroup_ns we know that capable(CAP_SYS_ADMIN) is true.

Or in short only root in the initial cgroup namespace is allowed to
create hiearchies after this.

Eric

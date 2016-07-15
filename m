From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroupns: Close race between cgroup_post_fork and
 copy_cgroup_ns
Date: Fri, 15 Jul 2016 07:58:35 -0400
Message-ID: <20160715115835.GE3078@mtj.duckdns.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
 <87r3av32g1.fsf@x220.int.ebiederm.org>
 <20160715111659.GB3078@mtj.duckdns.org>
 <8760s72lu5.fsf@x220.int.ebiederm.org>
 <87mvlj16co.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q5wEO+A0C47cx0vvbEC7butSkpGk950yKZt0Ygtp0A0=;
        b=cD4D6HzZGdKrd9nGFiMVRV51Nqf2b32MP+iPohW9SfGuKzDPzgtUoEDqZAtXL4N3TC
         xh77d9svDgPz4R1Edp8iiZUCzyQH6qe9rIdfItl2PuIErKz7mHT8KGuJ4Jj7HyhoutM2
         GqoDbLWjB3/hKvdtmH2igfYESG4ORPHNSxlM0WdTcT5Z/mcYf4AeJCEx4WR8WdfIsDnX
         9kW/8rq0okY8OiYjQTUkNAmqEm9x1byaVJwcGb+mxJRP18Zkqd9H/vNY89n/SRTYP8ny
         cgIzZLsSmg6hpki0UgXU3ULq8wOTXKLB1C+tOkwKEKepLzHlxGl9Ef8k0rO0lGZ7kX3R
         lldA==
Content-Disposition: inline
In-Reply-To: <87mvlj16co.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 15, 2016 at 06:35:51AM -0500, Eric W. Biederman wrote:
> 
> In most code paths involving cgroup migration cgroup_threadgroup_rwsem
> is taken.  There are two exceptions:
> 
> - remove_tasks_in_empty_cpuset calls cgroup_transfer_tasks
> - vhost_attach_cgroups_work calls cgroup_attach_task_all
> 
> With cgroup_threadgroup_rwsem held it is guaranteed that cgroup_post_fork
> and copy_cgroup_ns will reference the same css_set from the process calling
> fork.
> 
> Without such an interlock there process after fork could reference one
> css_set from it's new cgroup namespace and another css_set from
> task->cgroups, which semantically is nonsensical.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Applied 1-2 to cgroup/for-4.7-fixes.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process
 constraint
Date: Wed, 21 Jun 2017 16:40:50 -0400
Message-ID: <20170621204050.GA14720@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1AIWw/lsu41/itKxzWfvmWLy8WYJUjH6Ks4vQl4zVEo=;
        b=T1krJueaSplas4QPfLy/6JCb07L5QkwLJIFYd9By78K5zwIWEWuAQoEAjQ3cl8Tdlf
         mkyvXjSMn9Z/IgWcfctxzKDRIJiApo7tgUHPVPymAGBeCdXCcW6/AH0L6QG7iNRbOytE
         pVmuTu6QQ9m8Xe7f5WDDSEdSjlKKeM+rzh36jLpsf7lyfeTqFiKJvUryPC1fuzsQxr3W
         oBUsmSdLbNCHh2j44VAt/rwcD9Ac2C9t71ptiGHq/eaUZ6MJo4ENNgLod2KZryx/ivBz
         FX6kOe6yN/TEgygRVMgrI6kuwLfgG0siW4tKEoZVUxQaqZNdNsO4ksd7nwl8rMDzuqg5
         +uvQ==
Content-Disposition: inline
In-Reply-To: <1497452737-11125-2-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Waiman.

On Wed, Jun 14, 2017 at 11:05:32AM -0400, Waiman Long wrote:
>  2-4-3. No Internal Process Constraint
>  
> +When a non-root cgroup distributes resources to their children while
> +having processes of its own, its internal processes will then compete
> +against its children in term of resource allocation.  For some resource
> +types, that is not a problem and the controllers are able to handle
> +them correctly.  For others, the controllers may not be able to handle
> +internal process competition correctly.  This type of controllers are
> +called resource domain controllers in this document.
> +
> +Internal processes are not allowed on non-root cgroups which has
> +any one of those resource domain controllers enabled.  Currently all
> +controllers that are allowed in a threaded cgroup will be considered
> +as a non-resource domain controller and hence will not block internal
> +processes.  In other words, only cgroups which don't contain any

This isn't on this patch but I'm not sure this is a good way to define
resource domain controllers.  We probably should first define resource
domains and walk our way in to the accompanying restrictions and then
the distinction between the controller types.

...
> +Note that the restriction doesn't get in the way if there is no resource
> +domain controller enabled in the cgroup's "cgroup.subtree_control".
> +This is important as otherwise it wouldn't be possible to create
> +children of a populated cgroup.  To control resource distribution
> +of a cgroup, the cgroup must create children and transfer all
> +its processes to the children before enabling controllers in its
> +"cgroup.subtree_control" file.

What happens when we add domain handling to CPU so that it is both a
domain and resource controller?  Even if that somehow can be resolved,
wouldn't that come with a rather surprising userland behavior changes?
Also, I'm not sure what we're achieving by doing this.  It doesn't
really relax the restriction.  It just turns it off implicitly when
certain conditions are met, which doesn't really allow any real
capabilities and at least to me the behaviors feel more subtle and
complicated than before.

Thanks.

-- 
tejun

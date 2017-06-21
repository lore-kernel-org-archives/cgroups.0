From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 4/6] cgroup: Introduce subtree root mode
Date: Wed, 21 Jun 2017 17:38:07 -0400
Message-ID: <20170621213807.GC14720@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-5-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7oDBhRXk/wJHqPBi9EXeIh7qz/QlExClfkJlx5spBOc=;
        b=SfEOp5Zo4bqKWSMI+LtVu5WGBosT0bQ9mCEo+dZS0b/AAvJLdezNzt23G+mg9RO0Wp
         Lrjm5cEIkHt26Dy+FB7LXUkX9OSyf+vpc/MSsV9sCbiUfJV8CKDN8HRbws93XQqzV2QX
         iUp1S3C4uPMPv1DZ+qIWWo8tynDI7iExILCYuXE7CSnWNlediLiYLel+ZILddWSe4xG5
         hysiIMoEW+RazlWXJr7vBpNN5ebRaRSDcUV/ulcmNuscCyv8C4neCc9wHN0ynxfTUsBW
         rYGs4pOhdHa/bc2JxcPOZ0LZTeaqG7SciHnrGpScepascw1TkzQeXZTfKajZuAgcTRku
         BwVQ==
Content-Disposition: inline
In-Reply-To: <1497452737-11125-5-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Waiman.

On Wed, Jun 14, 2017 at 11:05:35AM -0400, Waiman Long wrote:
> Subtree root mode is a new cgroup mode which applies the following
> restrictions when turned on:
> 
>  1) Controllers are only allowed to be passed to the children in
>     bypass mode except those with the "enable_on_root" flag on.
>  2) Only 1 child cgroup is allowed.
> 
> That lone child can be used as the pseudo root of a container cgroup
> hierarchy.  All the resources, if controlled, are in the parent
> cgroup. There will be no control knobs in the child. That makes it
> look and feel like a root.

I'm not sure not having the control files in the child makes that much
difference.

> That pseudo root is also considered to be mixable and so can become
> root of a mixed threaded subtree. The no internal process constraint
> also does not apply.

Heh, you can't just declare a non-root cgroup to be a mixed root but
if you're special casing this and making the kernel play a masquerade
with special node, you can make cgroup provide a mixed root while
hosting the internal processes in a dedicated leaf cgroup which isn't
visible to the nested root, right?

It's all a game of masquerading tho and doesn't actually enable
anything which isn't possible now.  This would definitely be useful
for testing.

Thanks.

-- 
tejun

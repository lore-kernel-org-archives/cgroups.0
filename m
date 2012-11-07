From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/9 v2] cgroup: add cgroup_subsys->post_create()
Date: Wed, 7 Nov 2012 18:40:35 +0100
Message-ID: <20121107174035.GA24475@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <20121107171508.GF2660@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QIbqlNdEz40KozpBHbJFH3Yu1Jz86wJrpLuQzY7os7E=;
        b=i+dvjRxPIfj3kt4GBk14NAvWKzRKTPnXoya77XXt3JnMVDhl0HFXiWGaAw5PtT+hl4
         GSKzHYCXaykq4iBuy9bdWTGoi/3M9mzRDNNqibZ+xJ1lDcmCHrRsHihrjfo2gQKACdv8
         PXGKBNVy7JGEsrT6ttdMXE93p7y0qR2lDGIbnGU8yJKZQOTMggyjLFP8+0NUzUD4cqk9
         d6npmQe3IsEBgMM01QNXzEHGh/w4faxHJElUyfm3oD4NLqh04JjFYtyxqhFK0hRGsuJN
         jRhqMpj4jusPQ+SQSAoYqEMjqBLRnyXSdE/Ltk+naaP/NCH2qIYk2InVm1LqUQXp6Ogl
         Ddgw==
Content-Disposition: inline
In-Reply-To: <20121107171508.GF2660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed 07-11-12 09:15:08, Tejun Heo wrote:
[...]
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
> 
> When used in combination with the to-be-added generic descendant
> iterators, ->post_create() can be used to implement reliable state
> inheritance.  It will be explained with the descendant iterators.

Thanks
-- 
Michal Hocko
SUSE Labs

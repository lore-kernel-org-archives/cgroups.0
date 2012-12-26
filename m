From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
Date: Wed, 26 Dec 2012 07:04:15 -0500
Message-ID: <20121226120415.GA18193@mtj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <1354138460-19286-7-git-send-email-tj@kernel.org>
 <50DACF5B.6050705@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=aqpA2fA7fskJmJ7rz1Qacxvp4ZneLHHG9nAO56R41j4=;
        b=Rf4eBemjvkrvnZS5eyyqR7luB7ElYjh1CghXgYkDZG04Arz6xNlFk/DwpLoWGPpoUk
         QSSYc3Nm2k95qeqybtsU5qHStR07JTIBu2YLsswh3SLfhHcrXTHUr3tWtErSB7eXdtUH
         DCBZZlrhBKWRkWhPt2Y/LqUjTWeCSLJlp0N6T7E+JYIpJorHHQQZdAiylvQamhtuTDji
         YYWgzzwrtdEgzr0fdkWWNp4VJwSnrkRhVom7VRn2qNSiXmxDb6hK/Zg+Osucfbc0c+fz
         qwgSHAvXFwwD4nDYw9o0FCZsRIjCgNLSU0Hbh/Ktr5Qs4WI5GQKg/bKlp4hWxztMP1Gr
         tj9Q==
Content-Disposition: inline
In-Reply-To: <50DACF5B.6050705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>

(cc'ing Rusty, hi!)

Hello, Li.

On Wed, Dec 26, 2012 at 06:20:11PM +0800, Li Zefan wrote:
> On 2012/11/29 5:34, Tejun Heo wrote:
> > cpuset_can_attach() prepare global variables cpus_attach and
> > cpuset_attach_nodemask_{to|from} which are used by cpuset_attach().
> > There is no reason to prepare in cpuset_can_attach().  The same
> > information can be accessed from cpuset_attach().
> > 
> > Move the prepartion logic from cpuset_can_attach() to cpuset_attach()
> > and make the global variables static ones inside cpuset_attach().
> > 
> > While at it, convert cpus_attach to cpumask_t from cpumask_var_t.
> > There's no reason to mess with dynamic allocation on a static buffer.
> > 
> 
> But Rusty had been deprecating the use of cpumask_t. I don't know why
> the final deprecation hasn't been completed yet.

Hmmm?  cpumask_t can't be used for stack but other than that I don't
see how it would be deprecated completely.  Rusty, can you please
chime in?

Thanks.

-- 
tejun

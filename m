From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: remove synchronize_rcu() from
 rebind_subsystems()
Date: Mon, 14 Jan 2013 10:55:12 -0800
Message-ID: <20130114185512.GG27942@mtj.dyndns.org>
References: <50F3CE8E.5000402@huawei.com>
 <50F3CEC2.1020909@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=zl5QVHtNsUK5EjPMPxgiBWK76kyfHG/uke3YvmUKsCg=;
        b=ngUS1cYv4LR5DAiVaBpObFmo3sbNPRBGHz0enuPERHhDyFiM4sd8NVcnuYJVooFfjb
         Cct7VhQ/3tzsGyAVEc4Wlx2M5r1jAniwB3lNuFdAYBb86shiF8BOMILvmHgA7G3rHidv
         YvdJ/pgt5+dfIm/T4doJXqed+tEHK3suV7Boie69s38ZMVZIlF63Sf4cDPa81z3rwxsT
         fp3E+/CKOI7TkG9UxccKcWfA0HbhUSm2iZTGSz9GLsB9Il+KaKa6AF92pnVGeudNbX/5
         fhLGhDxsIpHENSLsAGCmWcaJFl7A9Dn+63KPa1aLlp7/sw1FEC+Gh2nl1NXxDBQa6A6Y
         5Yew==
Content-Disposition: inline
In-Reply-To: <50F3CEC2.1020909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 14, 2013 at 05:24:18PM +0800, Li Zefan wrote:
> Nothing's protected by RCU in rebind_subsystems(), and I can't think
> of a reason why it is needed.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.  We probably should synchornize_rcu() from
cgroup_diput() too.  Probably by punting css_free() and cgrp freeing
to a work item from call_rcu() callback.

Thanks.

-- 
tejun

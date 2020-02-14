From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: net: do not associate sock with unrelated memcg
Date: Fri, 14 Feb 2020 13:47:30 -0800
Message-ID: <20200214214730.GA99109@carbon.DHCP.thefacebook.com>
References: <20200214071233.100682-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=piEDK3sQ58eGY88b0/ZoEju6n9YkDVBjwZwW0orWUZc=;
 b=Nir3ex2agghP9Ed5QjdUx56ukqp2kn9k+JkuhD0a/nGfW0uYNlEGyLl7oD9PnREtL/je
 AYsNky2Pwa7LOXcI+MFkqjD+ss4EFBvLYonnv9rBFAOAQ2R61N5rDwedy7970QuI1gFe
 /iTzSNUJb3bXnh0WQOgGqRmHOr53qYH79ig= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piEDK3sQ58eGY88b0/ZoEju6n9YkDVBjwZwW0orWUZc=;
 b=bBQfcFyNWqOmDbVEkww4oMNcUKDrez8i2Prqf/aouOklZ31aQvtjKEr6SNR27+56SoQg5jL1qQQBN7tXB5Men73i6Zi3/qOpJqzQoGG/LVr8Aj0xXwSTwuQUFlawu97ruwk+NuC4SQcRD+YkpvtjsUXYHgPB/TjgTcQkGw1iNuE=
Content-Disposition: inline
In-Reply-To: <20200214071233.100682-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Shakeel!

On Thu, Feb 13, 2020 at 11:12:33PM -0800, Shakeel Butt wrote:
> We are testing network memory accounting in our setup and noticed
> inconsistent network memory usage and often unrelated memcgs network
> usage correlates with testing workload. On further inspection, it seems
> like mem_cgroup_sk_alloc() is broken in irq context specially for
> cgroup v1.

A great catch!

> 
> mem_cgroup_sk_alloc() can be called in irq context and kind
> of assumes that it can only happen from sk_clone_lock() and the source
> sock object has already associated memcg. However in cgroup v1, where
> network memory accounting is opt-in, the source sock can be not
> associated with any memcg and the new cloned sock can get associated
> with unrelated interrupted memcg.
> 
> Cgroup v2 can also suffer if the source sock object was created by
> process in the root memcg or if sk_alloc() is called in irq context.

Do you mind sharing a call trace?

Also, shouldn't cgroup_sk_alloc() be changed in a similar way?

Thanks!

Roman

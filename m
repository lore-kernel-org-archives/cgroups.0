From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rfc][patch 3/3] mm, memcg: introduce own oom handler to iterate
 only over its own threads
Date: Fri, 29 Jun 2012 13:30:33 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206291329520.6040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206251847180.24838@chino.kir.corp.google.com> <4FE94968.6010500@jp.fujitsu.com> <alpine.DEB.2.00.1206261323260.8673@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206262229380.32567@chino.kir.corp.google.com> <4FEC1C06.70802@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=T5sNkAR+zqd6nKCODUpWe/Iw7SYI2eaak/XdwCv6eRk=;
        b=Q3n5kg4FKS27M9MMhnrvJY5RoUlIHpHJgfhe9Zx3fqWqCjANsTw9AF87fl9Gk2V3K/
         9hineedkV/K2NF/afhK9rFkRt2BDtweRir3ihmz++MQqzJ9sAjNfjlbDDWfB5Thnc7UN
         wLXlMABszGBjlof4oE6yEuFqcuNe/+UR/eUjFqrYCOBiC2vy9EnfJFcHXYiNPiJaQXmn
         c2DtySSyZjWO9mNrsVDU9zQP1yIUkjsf/tzcPjMc8b2Ho4M/jQekqJmJ9QkbuvdWNQjd
         u6DM58w3i+3qYwrt0C/7Dpqa7qikAB6DGqwJfG8qw0VN/mNb6avtMwkm7QvQNztE0cyW
         +Jag==
In-Reply-To: <4FEC1C06.70802-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 28 Jun 2012, Kamezawa Hiroyuki wrote:

> > It turns out that task->children is not an rcu-protected list so this
> > doesn't work.
> 
> Can't we use sighand->lock to iterate children ?
> 

I don't think so, this list is protected by tasklist_lock.  Oleg?

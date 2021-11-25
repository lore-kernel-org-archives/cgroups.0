From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 03:30:44 +0000
Message-ID: <YZ8DZHERun6Fej2P@casper.infradead.org>
References: <20211124151915.GA6163@haolee.io>
 <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FJveyksDdIzezjLTh+rtqlw7W3mbjgrzS1zYLwDdyJw=; b=Vj1482sPd6MjdEtA4qCXvJvQgD
        WL8f/9idar4o0C/fULR3TZDxRtRNJMjmdXZyjO9qAMmUE6otb1jbAdlCat9KaXunIf3DoF/4SaiZo
        d70wYXABjupPPwTtTdu75c8n0aotcx9CFFrEmcXXFx33d6XSaX9SGWn6mkRv/yzmbEazqSowyQ5Jo
        ckv/+EaPXkcil4YJKlFWKRCpI3R0DFuCkatvSXzBb/qo3VzEipuSAbPba2decKg5GjX+JFvzCjY13
        8p0AYV+r1HdmRsCiFTBSXCLS4PaiyPOcWpuXgoEE0IQiFcnx9fm/vlOmtFRpBd+J89SK2FZJvTXlK
        r0s68t0Q==;
Content-Disposition: inline
In-Reply-To: <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Nov 25, 2021 at 11:24:02AM +0800, Hao Lee wrote:
> On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > We do batch currently so no single task should be
> > able to monopolize the cpu for too long. Why this is not sufficient?
> 
> uncharge and unref indeed take advantage of the batch process, but
> del_from_lru needs more time to complete. Several tasks will contend
> spinlock in the loop if nr is very large.

Is SWAP_CLUSTER_MAX too large?  Or does your architecture's spinlock
implementation need to be fixed?


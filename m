From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 2/4] mm/oom: handle remote ooms
Date: Sat, 20 Nov 2021 05:07:14 +0000
Message-ID: <YZiCgrTzcl/QQC+N@casper.infradead.org>
References: <20211120045011.3074840-1-almasrymina@google.com>
 <20211120045011.3074840-3-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wEdJcEBDOS+GDmIXrr71fbDgTyZK1MYWQaHlEXJLZ+U=; b=RoCqii8SlnkIZCDsu35QUFgqso
        PITjNmL1dwlGuPu8CjvRwOJcy2m/hYeBGQfdpPfwnOqBiM2CswkijqY7kAw/lXx66QDDMKiFTAA88
        rdsZLxB0mnvU12IFq8dBzAZORSXWHwrgiIjX51ttJCkU9CfVxobWCFpWhqWUsfY4KredcvAvSnoBF
        tyQpEFdr/VabIfumYydXb3HHwsX1YzZRrGI36hvu8UjsOfEJ5Qhux0kZt22bAigzQUCZffDPTr2gl
        jryvet5ScyXeiNvk5C/OI4Xd1Jctu42+rwS4xxvuDYwTw6iQD02X1Utxx/E2/FSFl5aTisiwnSBT0
        Oj7d9Sug==;
Content-Disposition: inline
In-Reply-To: <20211120045011.3074840-3-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 19, 2021 at 08:50:08PM -0800, Mina Almasry wrote:
> On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> to find a task to kill in the memcg under oom. The oom-killer may be
> unable to find a process to kill if there are no killable processes in
> the remote memcg. In this case, the oom-killer (out_of_memory()) will return
> false, and depending on the gfp, that will generally get bubbled up to
> mem_cgroup_charge_mapping() as an ENOMEM.

Why doesn't it try to run the shrinkers to get back some page cache /
slab cache memory from this memcg?  I understand it might not be able
to (eg if the memory is mlocked), but surely that's rare.


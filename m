From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Tue, 16 Nov 2021 10:39:08 +0100
Message-ID: <YZN8PCK9kmmYUXSp@dhcp22.suse.cz>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com>
 <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz>
 <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
 <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
 <CAHS8izPcnwOqf8bjfrEd9VFxdA6yX3+a-TeHsxGgpAR+_bRdNA@mail.gmail.com>
 <YZN5tkhHomj6HSb2@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637055549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CyoOkrmM4Ugx2tFGn3orFJRtgDuhEZbVLB7WBpXDCRI=;
        b=Td9R8Cpl9hprSCtmF2qOYLllhemJV/VM5LtSFcG6ch6W5tKUr6EsqYiq84CVlxTsBns0SF
        UzTICDbq38Wt+AlB3SOsGQYf1eSgtBne1YAokwEGCUTB3eR/CHNjZSgk7nzP0XADK0C/p0
        22pnnE5JPw3LiB85kDS6bJrX5PFy56s=
Content-Disposition: inline
In-Reply-To: <YZN5tkhHomj6HSb2-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 16-11-21 10:28:25, Michal Hocko wrote:
> On Mon 15-11-21 16:58:19, Mina Almasry wrote:
[...]
> > To be honest I think this is very workable, as is Shakeel's suggestion
> > of MEMCG_OOM_NO_VICTIM. Since this is an opt-in feature, we can
> > document the behavior and if the userspace doesn't want to get killed
> > they can catch the sigbus and handle it gracefully. If not, the
> > userspace just gets killed if we hit this edge case.
> 
> I am not sure about the MEMCG_OOM_NO_VICTIM approach. It sounds really
> hackish to me. I will get back to Shakeel's email as time permits. The
> primary problem I have with this, though, is that the kernel oom killer
> cannot really do anything sensible if the limit is reached and there
> is nothing reclaimable left in this case. The tmpfs backed memory will
> simply stay around and there are no means to recover without userspace
> intervention.

And just a small clarification. Tmpfs is fundamentally problematic from
the OOM handling POV. The nuance here is that the OOM happens in a
different memcg and thus a different resource domain. If you kill a task
in the target memcg then you effectively DoS that workload. If you kill
the allocating task then it is DoSed by anybody allowed to write to that
shmem. All that without a graceful fallback.

I still have very hard time seeing how that can work reasonably except
for a very special case with a lot of other measures to ensure the
target memcg never hits the hard limit so the OOM simply is not a
problem.

Memory controller has always been used to enforce and balance memory
usage among resource domains and this goes against that principle.
I would be really curious what Johannes thinks about this.
-- 
Michal Hocko
SUSE Labs

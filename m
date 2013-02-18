From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Mon, 18 Feb 2013 09:16:47 -0800
Message-ID: <20130218171647.GD17414@htj.dyndns.org>
References: <5121C647.7030608@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Con8oKr+KZciJJ9bzkEi3OThZdhTQtzXIonxP+F8ngk=;
        b=J4K5p2CewrP6eByVacyoQ8IVw9gq9POIv5xtBqwp8b5VJdZ5uFjoCWgnPX603//bgJ
         ffBu0d62+jNYph4KAwd3pcecpnnd7UtGB1+wf1g6WVpaiNJFHJHgSg8IItCqp9xxdw+j
         Ma3SnsQj/Opp72ZttXjjMF4cS8KTxnH4BPLoX2Q9LeZLjk9vGciKIfEjR9xBnerF2znU
         n0d11K7y3kK0t0sZhBpB2Pt5+IqUTWQ9lYWXWQdTCtDUU9qgHvDwoqvQyw30gD52qawY
         JPfTSlP9DeMak+adT7g+0Mo13XaRFsDxy1J4ZpWlUeFP02KZj+QG5nkjKOH8+oznkJOB
         eVIQ==
Content-Disposition: inline
In-Reply-To: <5121C647.7030608-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On Mon, Feb 18, 2013 at 02:12:23PM +0800, Li Zefan wrote:
> commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
> warning for event_control") solved a deadlock by introducing a new
> bug.
> 
> Move cgrp->event_list to a temporary list doesn't mean you can traverse
> this list locklessly, because at the same time cgroup_event_wake() can
> be called and remove the event from the list. The result of this race
> is disastrous.
> 
> We adopt the way how kvm irqfd code implements race-free event removal,
> which is now described in the comments in cgroup_event_wake().
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/8] cgroup: a bunch of cleanups
Date: Tue, 12 Mar 2013 15:38:39 -0700
Message-ID: <20130312223839.GM25266@htj.dyndns.org>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=HbX0LzPkhS21lq9Y5KGxrE6FnzhkND5Ua4Ri6qhIeSM=;
        b=TNYd3BlEMNrSVvNQczJ5KPqrF6sE49IS5gPPSJcdxWzvDLw9b8QJ1OZhXEc1vX9Bcr
         qeZ0PQp9bxLWdmXpoaEvh3Y1rPNmbZn8MGArVEdzlMUen70938t0ZTzNBBKkDDESQ/pw
         qskouex/Y1+Mxp3LT59j2kSRxsVNALRUd57XF5KxxPIKldQ8wKSUMQCxbJg9s4VaM+5c
         +tSeRFh9DiLAnKMQl8SSY7hICF4TO6fbR4b+NihYXjgosE4c++yapJ5Nx/TjHWwLfqql
         7wNBRCWK8nJw6KyTONWxcAoHYICwuDKACNtx7swj08mvqzd3Ncl8mHlJUrCPrTbNQ8Bf
         IBBw==
Content-Disposition: inline
In-Reply-To: <513ED010.5060906-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 12, 2013 at 02:49:52PM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> If you're busy with other stuff, just take your time to go through those
> patches.
> 
> 0001-cgroup-remove-cgroup_is_descentant.patch
> 0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
> 0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
> 0004-cgroup-don-t-bother-to-resize-pid-array.patch
> 0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
> 0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
> 0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
> 0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch

0001-0007 applied to cgroup/for-3.10.  0008 looks fine but in the diff
cgroup_attach_task_all() is removed completely and added back in
slightly different form.  If you wanna keep the functions ordered like
you posted, please put a separate patch to move
cgroup_attach_task_all() before the consolidation.

Thanks.

-- 
tejun

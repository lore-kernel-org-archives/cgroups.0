From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Fri, 22 Nov 2013 21:59:37 +0100
Message-ID: <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=LIbAxsJL+53yugZCPFjv9bUdk+ekONfVCj7Htwl3E9M=;
        b=L1mJi3H1xznVTw3SsFPWfOXD6VZa5Vace++LeK1YE3ce6+dNpJO8LKQCkcYRbydwum
         tf+BMli7h3Cpw73t50WwzZm0zf27XW8228P2Nf2w0oYEEY+ff3j2bb757Hyf3mqgPtpN
         QipxwaXNTZfTNt3f97sRD2QC1aJS5qe8uMOOYGwf82/v9aQACpjpPzByMHqlP/S/oU9F
         pcALmbtRsBihQ3zHkQrjbWZ4fgAIVDnbmWf8/j4CCTmbYWJMuuoMi+RauVFUs6TqqWg6
         7uQQOEDg3PvriRPViU11jP+8HSHDQhRqdKNXoYLp5HotQCkHGz16L8HAYXhp95qxU0dP
         8hlg==
In-Reply-To: <alpine.LNX.2.00.1311171746160.15789-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Mon, Nov 18, 2013 at 3:17 AM, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Sorry for the delay: I was on the point of reporting success last
> night, when I tried a debug kernel: and that didn't work so well
> (got spinlock bad magic report in pwd_adjust_max_active(), and
> tests wouldn't run at all).
>
> Even the non-early cgroup_init() is called well before the
> early_initcall init_workqueues(): though only the debug (lockdep
> and spinlock debug) kernel appeared to have a problem with that.
>
> Here's the patch I ended up with successfully on a 3.11.7-based
> kernel (though below I've rediffed it against 3.11.8): the
> schedule_work->queue_work hunks are slightly different on 3.11
> than in your patch against current, and I did alloc_workqueue()
> from a separate core_initcall.
>
> The interval between cgroup_init and that is a bit of a worry;
> but we don't seem to have suffered from the interval between
> cgroup_init and init_workqueues before (when system_wq is NULL)
> - though you may have more courage than I to reorder them!
>
> Initially I backed out my system_highpri_wq workaround, and
> verified that it was still easy to reproduce the problem with
> one of our cgroup stresstests.  Yes it was, then your modified
> patch below convincingly fixed it.
>
> I ran with Johannes's patch adding extra mem_cgroup_reparent_charges:
> as I'd expected, that didn't solve this issue (though it's worth
> our keeping it in to rule out another source of problems).  And I
> checked back on dumps of failures: they indeed show the tell-tale
> 256 kworkers doing cgroup_offline_fn, just as you predicted.

Hugh, Tejun,

Do we have some news about this patch? I'm also hitting this bug on a 3.10.x

Thanks,
-- 
William

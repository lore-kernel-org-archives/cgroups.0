From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Mon, 18 Feb 2013 09:17:56 -0800
Message-ID: <20130218171756.GE17414@htj.dyndns.org>
References: <512208CE.8000003@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Dn601HoNC7f2n2JQMxpVy2WiMs2vlpY0KO6JFQD1Ujc=;
        b=YtIiHbplTe2NdmTBYbPlr78Y3YorjYb9j7K01gXG6PfCWetnItnEepIGuw4TajWRK9
         AgYh8nxyRDlc4//r+FxhtyUaQIllzIJFTXba1Oruy2wYpdLkEyny6IlC+W3teDLnTN/6
         9cK13zdkbED5Y66pbM/SZwOtDNr7u6NdDSnx7M4ObEawhs8Izgs19VPGlDUXoKVlvhTD
         Cec4hyCzzRaJX7ukZUAsKKwaIOPgEEJRBFcppVFQ5GkLCtXsdHNsT4QSaVs02BFg95u7
         Fy7L4ND6KkLMEZkI40UtoJSja5KYsDxjdwj/XbKFwI0GWZf3cz4zbyxCHSALZ+KHXLRc
         Wcig==
Content-Disposition: inline
In-Reply-To: <512208CE.8000003-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 18, 2013 at 06:56:14PM +0800, Li Zefan wrote:
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
> v3:
> - call eventfd_signal() no matter it's eventfd close or cgroup removal
> that removes the cgroup event.
> 
> Acked-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Dropped v2 and applied this one to cgroup/for-3.9.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Sat, 16 Nov 2013 13:53:56 +0900
Message-ID: <20131116045356.GA5618@mtj.dyndns.org>
References: <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
 <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eDXKektQcnU99fGYDjFj/5xrZiv7CIzRIcSyALLew18=;
        b=mIOgNEjQ3zXfvoXL/ZFZyv8PvH2zq4PQVUehGnK8YCQziMTe8VZyn4lRmSuSTdCh2D
         iRCUvtTJBH7xCjZ7eYdnkqFNYobTpCYzIVD/JU/x4pZ9hut5Z3W8Fk9cn6GaY6YJmgBb
         QxUxk5Mu7Z2h89rZK1PC1ynZ14AiCFe8eUkINwUEYit6tnRyLeDFJ30uj9YbeUVtYxpO
         L44zeG98GmqvlrUwT4T1h2Lj+qpGh1GUqhWK+PfolSHzx2a+bAKnGagRqyPul5z/p9rz
         CVtrDAZVKe4ZRP5Qd1NWTnAcs69foBZqHCkmJUCsHqO60nCYIn27Rvc+ufwArrSTRlal
         2U3A==
Content-Disposition: inline
In-Reply-To: <20131116002820.GA31073-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Bjorn.

On Fri, Nov 15, 2013 at 05:28:20PM -0700, Bjorn Helgaas wrote:
> It would be better to fix PCI so we don't call VF driver .probe() methods
> from inside a PF driver .probe() method, but that's a bigger project.

Yeah, if pci doesn't need the recursion, we can simply revert restore
the lockdep annoation on work_on_cpu().

> @@ -293,7 +293,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	   its local memory on the right node without any need to
>  	   change it. */
>  	node = dev_to_node(&dev->dev);
> -	if (node >= 0) {
> +	preempt_disable();
> +
> +	if (node >= 0 && node != numa_node_id()) {

A bit of comment here would be nice but yeah I think this should work.
Can you please also queue the revert of c2fda509667b ("workqueue:
allow work_on_cpu() to be called recursively") after this patch?
Please feel free to add my acked-by.

Thanks.

-- 
tejun

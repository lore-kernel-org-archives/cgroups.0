From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Mon, 14 Apr 2014 13:52:36 -0400
Message-ID: <20140414175236.GB15249@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=k/VmRNLaoTTgsCSH2UeKBNGSQpLkbui6qNUePpdhBwg=;
	b=VMYUG5IRAvMRK2iGlla8czAY7is/9+JzTr5qwe90bqBWdB0mW0xoaokigI8sJMT27w
	mbqNHhFzZl1wcnSQka1iwolgW8d7qh8RmVOsolfC794MiOfAz+sWpevVFcazVfeE2nCd
	Q3xblvs5nuFXVlQW5b/MTMWSwfeUoNRxG3tWUeSMTJhciEOBHCmzDjgXW/+i4HcUmxzx
	cNZtrKuoNvhJOLYp3AvcaUt/1EGGmKZl3jgPiMI6+K+pyPgfzyVGFQ3drT6/eL+hHjdc
	07gr6uPXmX2mPkkbeMyXsxLeCjnfNNp3zsUZOMg28rlq8ssgKiwQkETcUASMiml3w9Dg
	zmDQ==
Content-Disposition: inline
In-Reply-To: <20140414154556.GA9552-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Apr 14, 2014 at 11:45:56AM -0400, Vivek Goyal wrote:
> So this patchset does not *enforce* a single hierarchy? So user space
> can still mount other hierarchies.

Nope, nothing is forced.  Controllers may be moved between unified and
traditional multiple hierarchies.

> How does this work for root's tasks now? Given that task can only be
> in leaf cgroups, that means tasks can't be in / cgroup (If one wants
> to create some cgroups). Does that mean / will be empty and init system
> need to setup things right.

Root is exempt from the restriction.  Root has always been special
anyway.

I'll soon post a document describing the design and restrictions of
unified hierarchy along with an updated version of this patchset.

Thanks.

-- 
tejun

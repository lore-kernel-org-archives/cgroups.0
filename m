From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-4.6] cgroup, perf_event: make perf_event
 work on v2 hierarchy
Date: Mon, 7 Mar 2016 20:44:10 -0500
Message-ID: <20160308014410.GC7065@htj.duckdns.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <20160303150654.GF11029@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UZzZs7blTImBJGXoQs4ec6GvpyyF/0dSvailtwNSlDE=;
        b=CviNWAKgp1TLoIdt1jWkKjYNfFJV7CSq0ENQdsH9SX5lVxDyiLjC/AbmPag99aZuBj
         fuomUW80ShRi1pN1WOeygN6m51GfvM6t4APPO4F/mGJ2MxeVGoYDqex25C8CYNcE1Pbb
         zzR8WlrFq4PoUp9ZWnArpOx/+CpdHrdmI7hlg0VzjiW/FEXfiX4c4sdBdwxywbtFtJg0
         mBmgU39HY58MahE+BJ3EVW/DA1S7J4OIwFJMpGKDYBleUQr4kesumfMZJ/QOo8etpRNZ
         nupA/XHz5OiX6v4hfhY/ALneUVlVk8MEslC8EO3qRnzBwonvls9BuwjHqWL9O+Zer0lr
         MSTQ==
Content-Disposition: inline
In-Reply-To: <20160303150654.GF11029-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 03, 2016 at 10:06:54AM -0500, Tejun Heo wrote:
> All the prerequisite patches are now available in cgroup/for-4.6
> branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6
> 
> If the perf_event changes look okay, we can either apply the first
> patch to cgroup/for-4.6, pull that into perf tree and aply the perf
> change there or route both through cgroup tree.  Ideas?

Ping.

-- 
tejun

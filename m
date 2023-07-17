From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/rstat: record the cumulative per-cpu time of
 cgroup and its descendants
Date: Mon, 17 Jul 2023 09:52:24 -1000
Message-ID: <ZLWb-LsBD041hMvr@slm.duckdns.org>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689623546; x=1692215546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWoO0TUyoZ+Qmv9rHsFJp85hT+0xnOPhDe/kh1QoW+4=;
        b=b/OD9dQBwXE1T8MrYijlWFmG5nFgVYLUSGDixvQrh4A+Vyno/KDVv+Pz7WNzBol1c7
         hgPj6C5a/CdM8V4v9GlJbGJegX4cmUqZhY386PFQo/u2kdOS0H4F+ItE8lvfOabQMBq4
         B+t9XaxuY0MkH70snVL8s0ePHjc8aFM4oFpf04Gbq9YxNiylU21jGRFT0TNyzjtuCIgC
         4PuELLmlzmV0xkS9mzXnFdHXNCEkugpQcM7PUci+dtuq5vf475R0VjnGL8r4cmHGgXTo
         /swLnuNI5MMi1CSwtcMJdKE52LgaAn2tNjyeq/xMKoRE3jD+BOKiRoB2KLYtpMkgvRrm
         2Nwg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230717093612.40846-1-jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Jul 17, 2023 at 05:36:12PM +0800, Hao Jia wrote:
> Now the member variable bstat of the structure cgroup_rstat_cpu

You said "now" indicating that the behavior has changed recently but I don't
see what changed there. Can you elaborate?

> records the per-cpu time of the cgroup itself, but does not
> include the per-cpu time of its descendants. The per-cpu time

It does. The per-cpu delta is added to its parent and then that will in turn
be used to propagate to its parent.

> including descendants is very useful for calculating the
> per-cpu usage of cgroups.
> 
> Although we can indirectly obtain the total per-cpu time
> of the cgroup and its descendants by accumulating the per-cpu
> bstat of each descendant of the cgroup. But after a child cgroup
> is removed, we will lose its bstat information. This will cause
> the cumulative value to be non-monotonic, thus affecting
> the accuracy of cgroup per-cpu usage.
> 
> So we add the cumul_bstat variable to record the total
> per-cpu time of this cgroup and its descendants, which is
> similar to "cpuacct.usage*" in cgroup v1. And this is
> also helpful for the migration from cgroup v1 to cgroup v2.
> After adding this variable, we can obtain the per-cpu time of
> cgroup and its descendants in user mode through eBPF, etc.

I think you're misunderstanding how the code works. Can you please double
check?

Thanks.

-- 
tejun

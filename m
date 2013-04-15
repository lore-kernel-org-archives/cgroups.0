From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_path() not print
 double slashes
Date: Sun, 14 Apr 2013 20:18:57 -0700
Message-ID: <20130415031857.GH3050@htj.dyndns.org>
References: <20130414173704.GB3050@htj.dyndns.org>
 <516B6FA9.9030301@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/GKa92pBIj+znLMPlK+FeYc7d8s67o06DfUn1j41ZaQ=;
        b=CmBnTdayHxBq7IFMJnyC6QSqxE8Yeh3rBqvIt/KdIO2r5DGy4ZSLRMntnh1af89iuA
         sE59b43+dA/fTDjPkzpoilByobzaKuqrF0tcutLqqQ9pmQMlt8Nj/9JFeuqZIQ8OzBuX
         5iZoPwIB14ZBOUj6Uq1qiHq3R3ZaYnGzhhErSCeABG+7u/xpqfKkEXXNVCt1PCH4rjzX
         OyYPBl12GTeLQN+RpPayKNQvrHrrWcj6x+ZCPX5ggvI4xyk0QfVSb7jBDYnwBVrgq5F4
         Yvs9SGMVYATJ86Ekpr+Z1MQgODvUHxFCGAt1SWHwbFSY/kfWVX8lmtxHhhhZ1+9smef3
         5AuA==
Content-Disposition: inline
In-Reply-To: <516B6FA9.9030301-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 15, 2013 at 11:10:33AM +0800, Li Zefan wrote:
> On 2013/4/15 1:37, Tejun Heo wrote:
> >>From 277f3d4be79aefe2071d9053a9c7c89c4e5dad30 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Date: Sun, 14 Apr 2013 10:32:19 -0700
> > 
> > While reimplementing cgroup_path(), 65dff759d2 ("cgroup: fix
> > cgroup_path() vs rename() race") introduced a bug where the path of a
> > non-root cgroup would have two slahses at the beginning, which is
> > caused by adding '/' before the name of the root cgroup which is an
> > empty string.
> > 
> 
> I guess I booted a wrong kernel when testing that patch...
> 
> >  $ grep systemd /proc/self/cgroup
> >  1:name=systemd://user/root/1
> > 
> > Fix it by special casing root cgroup.
> > 
> 
> I made a patch to fix it before the weekend, but didn't post it. It doesn't
> treat root-only cgroup specially.
> 
> You can apply whichever you like better.

Already applied the special case patch this morning.  Neither seems
much better than each other so I'll just leave it that way.

Thanks!

-- 
tejun

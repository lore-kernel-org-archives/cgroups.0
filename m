From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] res_counter: remove include of cgroup.h from
 res_counter.h
Date: Tue, 5 Mar 2013 09:34:17 -0800
Message-ID: <20130305173417.GC12795@htj.dyndns.org>
References: <5135688E.5080604@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=2HOz/LxM8Rq2ousgW5TU5WODoUiGhWPiCQty8USrzkg=;
        b=eF2TTtXUOD9Bne3UwiCGc1dPvg2BLlgE7+PtqPP+CBbUPkKiijMq5tSPNS2kAPNHn7
         xqLuWrRYvYn3LUOT1+rjSkZ9TmVmZnXdQ13ZeyP12+fgfYxckfxbGraDDE/bMetX66Pa
         1ImM/DfgDrrxQ374EnySXxSK6V9WyptkMsnpKynNDLsgiQk4fWtnpXEQeBfr41h7uHL6
         y92lsnwpJ5fuf3SJ2VROpfyrM11S53ELvZk8su2No7i2EadIpzWZ7Vb3G1oCD50eVeof
         MzmVhe4IQGUWFlU1kuFns0ZlAETw5FD+dCxN8dP6f2njMTeyPe2zFULJbe1LmdC1Qw7Z
         2bYg==
Content-Disposition: inline
In-Reply-To: <5135688E.5080604-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 05, 2013 at 11:37:50AM +0800, Li Zefan wrote:
> It's not needed at all.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun

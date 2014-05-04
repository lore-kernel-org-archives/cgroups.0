From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: blkcg: circular dependency between blkcg_pol_mutex and s_active
Date: Sun, 4 May 2014 15:26:30 -0400
Message-ID: <20140504192630.GE26279@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wE3XBC7eh5tVrlMUMKImdSoLhAWzUmcNE1i7RuwJvMk=;
        b=v0tnskgGAQCdS1xwgOQDG+4wRv0hdu+pPAQEqQIzFT8pbRyssx5v4Blq1RDeOQhXfE
         Wn5BEHvCHDte8V74oky637ntlEFOl67dOOxnqLJJhyks1LEz85FKYGJ/lmlpEg4WYMSR
         DdNldkMLFKY3xJUyDoJcvJiPXuIYHvrHDCyGPqhVXhU+MTnO+jFjr6kXAHxe+OmlqyVh
         s4G2eGUvrzhYvsIQ30ebHgzDg1Ed6cvO1feLbAW4cPZoHlqPNrJyhFMcu1Ml1E/Ip7eR
         Fi9YkLwWCGC/fi3WHHVwrMAB29L/+L1LT9xmX/IycV4bdxPZXDFS/i6cZkSwT5jo2/91
         byMQ==
Content-Disposition: inline
In-Reply-To: <5363C04B.4010400-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, May 02, 2014 at 11:56:59AM -0400, Sasha Levin wrote:
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following:

This is a highly unlikely deadlock which got introduced by recent
changes in cgroup core.  I'm working to further simplify locking in
cgroup core.  Will prep a quick fix for this issue soon.

Thanks.

-- 
tejun

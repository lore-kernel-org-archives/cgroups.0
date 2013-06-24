From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.11] cgroup: miscellaneous cleanups
Date: Mon, 24 Jun 2013 15:32:01 -0700
Message-ID: <20130624223201.GL1918@mtj.dyndns.org>
References: <1371864854-28364-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=L51Ku0LqHBgh6AlJTnNyFFE/lzg7kQp4sll3+vz9whc=;
        b=u1TYXgjDaeFD3trMG631xmwew5p1gz0DlJnTe8v+HGEX06e7DkapcuXCLyfv7Rvja5
         HZ4XXEtzmVTcpHAT8XJkgf5RjkPVtpKPKUCj2Rp7SRXLAqVbgXg0bndTfjv969s2UYJy
         MH1fjE9KtaPqDOnl+8mrk5dcbFQMGcp6gQsnVP1WJ3Ju4i4522xN/JJr6E+CnfNFX1v+
         QrDlu/QRAYpzP9V/Pfnv6fNwjnsQS1bLGYbEwaX3HRMyd+27OUl6p3eBRWZ6TfxR2lHL
         m52nAZXgEVY/MffI5AvqZiKpbfpgPLEYJTP4pLy9AAy67Cc/8zEO12H1yCCzsk1EFsSh
         eRQQ==
Content-Disposition: inline
In-Reply-To: <1371864854-28364-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 21, 2013 at 06:34:08PM -0700, Tejun Heo wrote:
> Hello,
> 
> These are misc clean up patches mostly focused on subsys handling that
> I ended up with while working on unified hierarchy support.  Nothing
> too interesting.  Just cleanups.
> 
>  0001-cgroup-convert-CFTYPE_-flags-to-enums.patch
>  0002-cgroup-prefix-global-variables-with-cgroup_.patch
>  0003-cgroup-remove-cgroup-actual_subsys_mask.patch
>  0004-cgroup-clean-up-find_css_set-and-friends.patch
>  0005-cgroup-s-for_each_subsys-for_each_root_subsys.patch
>  0006-cgroup-implement-for_each_-builtin_-subsys.patch

Applied 0001-0005.  The patches are re-sequenced so that they can be
applied before the RCU fixes.  Nothing noteworthy, just a couple
trivial context conflicts.  Will soon post updated version of 0006.

Thanks.

-- 
tejun

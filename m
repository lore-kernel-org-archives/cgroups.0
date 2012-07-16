From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Mon, 16 Jul 2012 09:45:27 -0700
Message-ID: <20120716164527.GB30872@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4FF3E063.5010604@huawei.com>
 <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
 <4FFB8F39.9030209@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MAez3gZMqH+lUK2OFv8TCdbxLvU+evZjy+n6iFY2AWE=;
        b=XcP0h4UcW+Ls+7l+mh4wDNwGYT2LkhV8+08yaLtnLgtcdhZnIHlN5VuvsPcRLjvVPa
         l8Evs3j9/3UlIoH38SoBVr04GgsKbySuhXqw2InrVojAQtpjOSOwSPTMUTKS06kbLxZ9
         xakx52GNRWoZaYgNiwyuPclsYwag3IWhnu0c6PcW+FOfv6Yk+Vs6iXPp4hB3rD871bqR
         H4MjinyzXtmNTZQ6xu/nC4PnLK8Ghq7b4se5Ho3/rWCS5iEK7G0+e+ib7yWjm1DW3oSS
         nlZtFmAeTqsIcon77QoNIr3n4iUpF01esEKMHg2hXYCzSUBvjz53TpXwwPFD5RidH0n6
         utrw==
Content-Disposition: inline
In-Reply-To: <4FFB8F39.9030209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Tue, Jul 10, 2012 at 10:11:05AM +0800, Li Zefan wrote:
> Right, but that should be safe. The css objects of the root cgroup are
> allocated at boot, and won't be destroyed at umount.
> 
> Furthermore when a cgroup hierarchy is going to be unmounted, those css's
> will be made to point to a cgroup named dummytop in rebind_subsystems(),
> and there's a syncronize_rcu() in the end of the function, so accessing
> css->cgroup is always safe.
> 
> In this case, dummytop->dentry is NULL, and that's safe too, because
> cgroup_path() is aware of this case.

I see.  Thanks for the explanation.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Sat, 7 Jul 2012 23:35:36 -0700
Message-ID: <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4FF3E063.5010604@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0vI1kXTSKiffjornWrDG2VIWiQeV7MannGGZABBZMLA=;
        b=OajZ4Gw2HA5ICzm79eWMFmEkyA7L+CT3hH9OW8kko6za6PsHzXywK6FKLIGZskyNyK
         SrzkOYxbw4goLxkzaV+0ffAne3V09dlG5b/4hx2jqByLTLgtB6iOKLTH+tMZ1sl3fr0Q
         2v1lAHwckNscluusfQG3DxE7aJfF7w5U2BkEUjTWvsLGhMKEJ3wf161HYSMO/Vn7zzCn
         PCOVfKniaJFvRBhoqN4d/KbParP7CFizfTkPBGiM1oAvEC3hmWX4uu83aMvpgejiobkc
         5wzLHlV8G7rx6rdjQggVYANpl4C9z4Sk0D+DZoixyuEc939yARRE4Js/APcVzvG090dS
         V6/w==
Content-Disposition: inline
In-Reply-To: <4FF3E063.5010604-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello, Li.

On Wed, Jul 04, 2012 at 02:19:15PM +0800, Li Zefan wrote:
> > I think we're horridly broken for
> > root cgroup tho - and it has been broken for very long time.  I think
> > it's mostly hidden because most (all?) controllers short-circuit root
> > cgroup.  Eh, well....
> > 
> 
> Could you elaborate a bit on what's broken for root cgroup?

If someone holds css ref of a root cgroup, AFAICS nothing is
preventing the cgroup hierarchy from being unmounted and root cgroup
destroyed.

Thanks.

-- 
tejun

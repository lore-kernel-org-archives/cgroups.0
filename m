From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] [RFC PATCH] cgroup, cpuset: add cpuset.remap_cpus
Date: Wed, 30 Aug 2017 17:41:31 -0700
Message-ID: <20170831004131.GZ491396@devbig577.frc2.facebook.com>
References: <1482419271-15410-1-git-send-email-w.bumiller@proxmox.com>
 <20170830132755.tnqmuttodexc3oh6@mailbox.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qMFzUnWBOvthJDrlYxfqDAQgIKhgh37RBEclaBJVb+I=;
        b=InXQSSNK+172b92cm6Spy1A31gly2E6fRMUaUyjE3Lsovluf7lhj/2wwGDoWTLQ7Kz
         KHxj3a0ftW4S+lKIhxMElWGLd5HToQPqOspypXicsWj0g+EjzxWCxkOX4SuV0PICW7cu
         WAnHVL8gPMBmbjf/LZ6HJp0MA42bxB611j+cobBoxAyqIBc9X7/VHfLFKftyBZ+7fnfo
         tAM8CUeum70CYJheuDG8oloHkHHVzbYoOCKR6wHZXIHZA3JUqfIz9SLYlZ4Eo1LIq2lG
         SZ4GKms0h86znB+VXX0nzk8zStFnjCMm7vpWsqlFcyInBhbUrxBa14qWmItvAHCKvHlg
         di/w==
Content-Disposition: inline
In-Reply-To: <20170830132755.tnqmuttodexc3oh6-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org, stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

Hello,

On Wed, Aug 30, 2017 at 03:27:55PM +0200, Christian Brauner wrote:
> The following patch was sent a while back by Wolfgang Bumiller to remap cpusets
> for a whole subtree in a cgroup v1 cpuset hierarchy. The fact that currently
> this is not possible in a non-racy why is a pretty big limitation. This is
> especially true for nested containers. Where the nested containers often create
> additional subcgroups in the cpuset controller at will. The fact that you can't
> *easily* and in a non-racy way tighten the restriction on them after having
> created the parent container's cpuset cgroup seems really troubling.

There was a recent patch to enable v2 behavior on v1, which feels like
the better approach at this point.  I'm not sure about adding a whole
new interface for this.

Thanks.

-- 
tejun

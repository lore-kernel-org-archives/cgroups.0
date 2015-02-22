From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 23/27] cgroup: Remove use of seq_printf return value
Date: Sun, 22 Feb 2015 08:41:32 -0500
Message-ID: <20150222134132.GA3964@htj.duckdns.org>
References: <cover.1424573328.git.joe@perches.com>
 <bbe7b355b687cf112bfeed3bc5e2a9cdef8d9d50.1424573328.git.joe@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Sg3uuLKnitRkOBeirAE4PtLBwdOqPrsT1FWmNJeRA4Q=;
        b=QlCeF0zbQqOcQ3sfRKjCYrFM8FfB8k2mgJ2tf42o02fK5PZNirbfIBjTSCQ1yzMrc6
         KV1zcCEQpHBvNtdG6gcsA0xcr1VX4/LEvYk/wF4qkC74k7E3f+F5g/fgkIIiyFhTiCzt
         vSlhMYhWORvHdFj0i750bvvpczgb0UrM4VrsVPCEi/lbb5J0+9xhR2lFSwo5yvNlz2sM
         Vn2JI1eJhtvc73NBIyeWhmbuDwWBY1UIUFhy/pFZvDDS99KUqZyzdvbo0X82K3oy8VQ8
         RIQ4FgB1niV9nLGhEsKivwx75Rk/ftc0UFJOG39Hp4J6kC3DPPuia0wnxJWVend03o2R
         A+Xg==
Content-Disposition: inline
In-Reply-To: <bbe7b355b687cf112bfeed3bc5e2a9cdef8d9d50.1424573328.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Feb 21, 2015 at 06:53:50PM -0800, Joe Perches wrote:
> The seq_printf return value, because it's frequently misused,
> will eventually be converted to void.
> 
> See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
>      seq_has_overflowed() and make public")
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Please feel free to route the patch as you see fit.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: limit max copied char length for cgroup file name
Date: Mon, 11 Dec 2017 07:05:51 -0800
Message-ID: <20171211150551.GC2421075@devbig577.frc2.facebook.com>
References: <20171209054758.13870-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K27FuU82Bmj9Kg4jFeJP7LkNNu0PF7hJIHYycfHmKp8=;
        b=dt8eek6avsVr77PBC7XbrWBqE2zXJNr5t2FTx7D2iAzenK1Uw7T4aecw1PdbhrzYSC
         LIaUjg62nmeDDi6vSmza7c2S3DAsNPEnbkWdwZzXZNHxGMUCcIdLNv7RJXYElyjvsSIJ
         ccZZT/xuTo9pz9v7FOKl08yXNojDRlsGe/2gCLZ2cnHHmkvRrGAvM+eT8C3Y7kYazZmR
         h12M3sSwWOqvrtoH2wSnDtaeBPTgFvwJAWOkI6R2atQb7FEWcoVp5liHU2mQbElE2Meq
         oZWO0MS1bzV4gdCRTd+JkLwlRPgyP+WIItDTjzL5qzcobOFnA4f39S02QLWM3ZsNI4/a
         iPcQ==
Content-Disposition: inline
In-Reply-To: <20171209054758.13870-1-mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 09, 2017 at 01:47:58PM +0800, Ma Shimiao wrote:
> the result of cgroup_file_name will be used by kernfs_remove_name,
> and then by kernfs_remove_by_name_ns().
> If reached the max length, may have problem printed by WARN() in
> kernfs_remove_by_name_ns().
> 
> Signed-off-by: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Can we use strscpy() instead?

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2] cgroup: return early if it is already on preloaded
 list
Date: Tue, 14 Dec 2021 09:45:54 -1000
Message-ID: <Ybj0cicbccR2OM1I@slm.duckdns.org>
References: <20211214004607.9296-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WXQ4L3qp7NpGXbdQ/vd/POJH3pL/Rk5cETFAlE06wQg=;
        b=amqRniWefUWtIJ056Oy+3xDZEqFPheGvE9Orcx+F0E4zfdLvUazfQwtYHPu5kjhhAI
         ofBNdFsIW7gp8WJfw4oI/yZSbxVjS29P+EKk9S+qTHMiGxouTUqfZYmPBVgcdvqpd86h
         eaNolPyGzpGa3eWbqupzQv8eK969rcD/Bf8Cv6aXU2Clw+4iqUKy2oGW8XwlpM8s1n7c
         q7uw2Zk9YV2J56oHbmmBM8Nf6UuLo3qUo8r+Uwp3F+MRoS3Xune4T/fBXoByn2sRE0QQ
         KEJOoNUFEq/SvDfmUUp/35n53pN6BQxu7/J084YlL66sHAjS8J6XXd+m7UradoS8Ge9n
         eo+g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211214004607.9296-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 14, 2021 at 12:46:07AM +0000, Wei Yang wrote:
> If a cset is already on preloaded list, this means we have already setup
> this cset properly for migration.
> 
> This patch just relocate the root cgrp lookup which isn't used anyway
> when the cset is already on the preloaded list.
> 
> [tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org: rephrase the commit log]
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-5.17.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2] cgroup: pretty format /proc/cgroups
Date: Mon, 15 Nov 2021 11:21:43 -1000
Message-ID: <YZLPZwo7IkgctGwD@slm.duckdns.org>
References: <20211115011253.20778-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZUQPppR9ZjdFkfvvbN8Bq2EG2Ba0aYSmf4rrcM4Gmzw=;
        b=QtWenNQeXFjBE1vmgcC7t0MMDldUBUq9hovNAQXWl/AZPpQXLrm9PUGLdGxY47kUYT
         y2LDUJHzeO54cT5ezi2EW3SWD/blO+R2SQToifds73Sge4ro6JWPbCH9/IqUPPZ7PsGF
         xrDjZ6P6bJce25D0eKtzhbymuBuCt9OdEI4kmT1ij5gkD9PaONAVj47FghdY//lazm+P
         JkdSWQXKJ9r+xpXMmlcOcdlxw0YzaHxB0Jh+yz7+6fG2HZ0TLFD5UjMn6FmY6Ox9PFxy
         L+h/l4zBePwFwrOgD5m6AUGh2kXQ3ukcxvDaBLBj7k+DnooNzJR+LBuCG1OUeOhoQ5ci
         lfRg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211115011253.20778-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 15, 2021 at 01:12:53AM +0000, Wei Yang wrote:
> Current /proc/cgroups looks like this:
> 
>  subsys_name    hierarchy       num_cgroups     enabled
> cpuset  3       1       1
> cpu     2       1       1
> cpuacct 2       1       1
> memory  4       71      1
> freezer 5       1       1
> 
> Let's align the title and value. After this patch, it looks like this.
> 
>  subsys_name    hierarchy       num_cgroups     enabled
>       cpuset            5                 1           1
>          cpu            3                 1           1
>      cpuacct            3                 1           1
>       memory            2                71           1
>      freezer            4                 1           1
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

So, I know it's silly but the file is dumb \t formatted (ie. single \t
between fields) and am slightly worried that changing the format might break
some dumb userspace tooling. Given that the information isn't really needed
for cgroup2 anyway, it prolly is better to leave it as-is, I think.

Thanks.

-- 
tejun

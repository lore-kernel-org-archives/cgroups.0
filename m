From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: rstat: explicitly put loop variant in while
Date: Thu, 6 Jan 2022 11:10:33 -1000
Message-ID: <YddayTDXQd21lxvt@slm.duckdns.org>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MJG9lGZ6QLSV3BSYotGztqDw0fy0Zwnl6zTi3BAaNIs=;
        b=B1XPEpvAtkf3Q1a5/T7kG5xY8AU6SOVPZ1+GtVa82Sbi26LKm4UyCC7TliLFocG7cW
         huTZjXszQXSttUSSFiURgxdLRC6X7MW0YdVervf5CdOz0Q1iq7SpLuKXF0Q2PMKPPgzg
         NledNo2s88DkvZf76UPIJ4VwgTBDpkJp9Z5vbXeRKJqgQaJPZb9K1cpOIZwYyATsmBC9
         jJKa1nWLk1o24FDfnMjSux2DUWnVQynLrsbNyAH0Skb6sSOspjtXRRiE8DzA6c0uZr5S
         jqvlNpzMg9FyJrRqlN0ieSn14DWPER0NZKovM99TQzxnzGCEWIRENTbNbro3f2qXlveX
         t7NQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211225000932.7253-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 25, 2021 at 12:09:31AM +0000, Wei Yang wrote:
> Instead of do while unconditionally, let's put the loop variant in
> while.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgorup/for-5.17.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: cleanup the format of /proc/cgroups
Date: Sun, 21 Aug 2022 21:30:28 -1000
Message-ID: <YwMwlMv/tK3sRXbB@slm.duckdns.org>
References: <20220821073446.92669-1-feng.tang@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=WsjMP58d6ZpqOpY4g9K6ddeUAxtCR0pSHuJhrbzNXTo=;
        b=Ls+0KIV/R7C/J45UdABQdD2zPd+7rtN4jhl8+/KMzRRsPlHQiMW14XHUIjj4mOLM+D
         adYE7r9KD7biiD3hGUtNsE79kJrt7tFlB9IYrroqyGa+axqcNxGFZcKUXx5rot/MwwGZ
         XMvmyjhg9lpFLDTqVroPAgj+eOhz9fsTlp6qP440GVNWyRVlZkD6BgIxhLznaUI9zLKO
         MHJA2apgk9+giWRvCNWeh9OEVfQfriea1HY5pDxCKGVKi+feozjMmbMBrs4x7V69wLCk
         pmDolW1g/fZ2pm/mPJqPyWOZLjAHZYMA052bwBh/jN4ftuMd7S9ziiimxWJull3rCci5
         jBUQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220821073446.92669-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sun, Aug 21, 2022 at 03:34:46PM +0800, Feng Tang wrote:
> Currrent /proc/cgroup output is like:
> 
>   #subsys_name	hierarchy	num_cgroups	enabled
>   cpuset	6	1	1
>   cpu	4	7	1
>   cpuacct	4	7	1
>   blkio	8	7	1
>   memory	9	7	1
>   ...
> 
> Add some indentation to make it more readable without any functional
> change:

So, this has been suggested a couple times before and I fully agree that the
file is really ugly. In the past, we didn't pull the trigger on it for two
reasons - 1. It is user-visible functional change in that it can break
really dumb parsers 2. the file is only useful for cgroup1 which has been in
mostly maintenance mode for many years now. I don't feel that strongly
either way but still kinda lean towards just leaving it as-is.

Thanks.

-- 
tejun

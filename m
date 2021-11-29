From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: cgroup_subsys[ssid] is never NULL
Date: Mon, 29 Nov 2021 07:35:54 -1000
Message-ID: <YaUPej4QUZoFAuOM@slm.duckdns.org>
References: <20211127145919.31159-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MNad6ulQb2gA8R5sf3rwypcW1oTk+N6PJavU21UoSX0=;
        b=FWGyKh4ir5dwLU6wzNY4AJLk7HljqhNMYCeFeVvaqxs8gCT50QJ3U9flAKWziqBkf2
         FzjNYNrbWyJuqX3bpLJzG1t/HB6WsNsu5AZQRT+j276x6Xc+sIHok3QqohhwiNvjEt+I
         bHs6cBnaZ7EOnF3Djjg4IftrmvvmsLvavkapkrluDn9Vem/m/8k7LrMKjHm7/s8TzKgj
         rWCb6qsPd4owm4M5CTfPXHnKfeiaMsCargSrBEpRCZ1HYSqvDpWmYv1PSeLXfTUNfKsq
         +J7M722MkLXPzJBLNbw9Ohzriae/gSsCaenN6sbv+znTBeXsbnn85WHsWn2m2+qa6XWA
         8pfQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211127145919.31159-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Nov 27, 2021 at 02:59:18PM +0000, Wei Yang wrote:
> When the check, (ssid) < CGROUP_SUBSYS_COUNT, passed, it means
> cgroup_subsys[ssid] is defined to its proper value. It is not
> necessary to use a true to enter the loop.
...
>  #define for_each_subsys(ss, ssid)					\
>  	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
> -	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
> +	     ((ss) = cgroup_subsys[ssid]); (ssid)++)

So, now the compiler has to test whether ss is NULL or not before each
iteration even though we know that it's never NULL. The whole point of that
"|| true" is telling the compiler that the pointer is never NULL.

Thanks.

-- 
tejun

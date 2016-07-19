From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Tue, 19 Jul 2016 14:13:29 -0400
Message-ID: <20160719181329.GH3078@mtj.duckdns.org>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
 <20160613213354.GH31708@htj.duckdns.org>
 <3b03822f-c5d0-5b84-79c3-edeb8e78e2dd@gmail.com>
 <20160719010931.GG3078@mtj.duckdns.org>
 <45e50dcb-7446-d203-de6e-0a59dc09a874@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M40tFMFIFYDPRaqBHncGsXHG0deJzs4ianN4z1jefr8=;
        b=l2JPzddi8PT6lyz21zYTlL2Pg7zvZHWl9gDwvyFwMGHUwtyrjJBMAABYgn6IVCAnmU
         UzDoukG+u/5eH4lnXcA+6B9eOx6xDtQN8WRAmV3akhbJQEavPaWwD7GuAyvtM9y7lVH3
         +D0E1fdefm2jL+dfNaMK5TX9SY7zVI5sJsWv5UYgKX3zstmhZ4PS1q88GGyCKH9E0KZy
         UlDQFQuyPpxZY31e4/Wt2Mumiaf3gFstQs5po2VpXgqzN0lKUNhFrnX0A1W/7qYBLLt7
         Swpy43CLRVWAuyPiwmgP55YSVn/fEil+ixeF+A5S3DI51xgprrtThZ89K/z+vX9ZlIfL
         ZEnQ==
Content-Disposition: inline
In-Reply-To: <45e50dcb-7446-d203-de6e-0a59dc09a874-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 19, 2016 at 04:59:18PM +0000, Topi Miettinen wrote:
> With the example systemd-timesyncd case, I was only getting 1 as the
> highwatermark, but there were already two tasks.

Can you please find out why that is so?  Given that that's where we
charge pid usage, it doesn't make sense to me that you're getting
lower numbers than actual usage there.

Thanks.

-- 
tejun

From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Wed, 12 Jan 2022 00:46:34 +0000
Message-ID: <20220112004634.dc5suwei4ymyxaxg@master>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <Yd1CdJA5NelzoK1D@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YgB9W3ER2Fk3JAkU4HFtCEF3WoMMr2PxfP7Sgs5PJD0=;
        b=PtupSkCZRZdKSmNDUGbWNksFXWjrpfe+bp3K19mEv1Fmx2j4cSpPPJhKRWn1cgPohI
         PPkEfVVVPrGBsl3fBy6LbNz8AKw/Mn+7/2i/tgkPXnH0cFtdl5/yP+jvPTOHBZszTOHY
         rh0C8UnwkvrFlCP+tie4bR/5NETPf6dji+imcsAX6pg/Nhhy5NrdqAfKWj9cXt5eGvIt
         8rubtDI/vYYUHq3VFK+89ZQ2921Db/hBi+yzO5Lx43tLTR3K4R2lqaz45mrza6d+ULkJ
         zHZcYNP/tCuz8TpUTXtkQooCLA8m5eo2D9OyVsPJAKB5qKTpPN45InBPD/Tey+Wreqz/
         jeVg==
Content-Disposition: inline
In-Reply-To: <Yd1CdJA5NelzoK1D-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 09:40:20AM +0100, Michal Hocko wrote:
>On Tue 11-01-22 01:02:59, Wei Yang wrote:
>> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>I am not really sure this is worth it. After the merge window I plan to
>post http://lkml.kernel.org/r/20211214100732.26335-1-mhocko-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org

Give me some time to understand it :-)


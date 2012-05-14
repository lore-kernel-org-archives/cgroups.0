From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] add res_counter_uncharge_until()
Date: Mon, 14 May 2012 12:56:38 +0200
Message-ID: <CAFTL4hzFiFDTUAAgo=1RBLFhG5Xe8VEUESkpc-RgN7L-haMMbA@mail.gmail.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
	<4FACE01A.4040405@jp.fujitsu.com>
	<20120511141945.c487e94c.akpm@linux-foundation.org>
	<4FB05B8F.8020408@jp.fujitsu.com>
	<CAFTL4hwGEhyxZO0sXx5gVyK_xjhMQEbHojJbHzQmVKafNyVWtw@mail.gmail.com>
	<4FB0DF4A.5010506@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=R40kkviYpcuEsz6/Ca1MgAkPSed/YLDnSg74lA34vFM=;
        b=YShuH2Sxfr2ppD7ltBdDfJCfX5OfmrrgL3RvgB1sGifgHVJp/6Olqz1Sc3HbwE20sX
         EHpHidl8/iy88pE4dBf90VWkmP/C1+BqLylVUGYbNoJsfPDpbm4LDSylE5SJsbdCWFwF
         AkqeoIZapcRPrk8NOvjMTKwkZwcWn3PBg45D0vBbZWn6YF6MZXS+eLRuJNW235Q6isox
         VTia4DUGTuUoWZdIhkoXJiuiG+fBt5cBF+zOd7Xfvf9o9fD4hUC2DEFBlVIiXiY2bU5Q
         9wsV2Y3L7lJW7dRmPF3MNf2GINAFtp458Qv4szX0BZiR5y7vaq4v+qogPlHxmRq3n07g
         1FSg==
In-Reply-To: <4FB0DF4A.5010506-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2012/5/14 KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>:
>> There may be some special cases with "Original-patch-from:" tags used when
>> one heavily inspire from a patch without taking much of its original code.
>>
>
>
> Is this ok ?

Yep, or even better since I plan to use my company's address now to
sign my patches:

Signed-off-by: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks!
